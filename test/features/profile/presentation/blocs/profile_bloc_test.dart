import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobiquest/features/profile/data/repositories/profile_repository.dart';
import 'package:mobiquest/features/profile/domain/usecases/get_profile.dart';
import 'package:mobiquest/features/profile/domain/usecases/register_practice_result.dart';
import 'package:mobiquest/features/profile/domain/usecases/set_profile_name.dart';
import 'package:mobiquest/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:mobiquest/features/profile/presentation/blocs/profile_event.dart';
import 'package:mobiquest/features/profile/presentation/blocs/profile_state.dart';

import '../../../../helpers/fake_profile_local_datasource.dart';

void main() {
  late FakeProfileLocalDatasource dataSource;
  late ProfileBloc bloc;

  // mutable "current time" for tests that need to cross a day boundary
  late DateTime now;

  setUp(() {
    dataSource = FakeProfileLocalDatasource();
    now = DateTime(2026, 3, 10, 9, 30);

    // The real repository on purpose: reward rules live there, so a fake would
    // silently duplicate them and go stale on the next refactor.
    final repository = ProfileRepository(dataSource, Clock(() => now));

    bloc = ProfileBloc(
      getProfile: GetProfile(repository),
      setProfileName: SetProfileName(repository),
      registerPracticeResult: RegisterPracticeResult(repository),
    );
  });

  tearDown(() => bloc.close()); // закрываем bloc после каждого теста

  // Stream.firstWhere не сужает тип элемента, поэтому здесь явные касты
  // хелперы
  Future<ProfileLoaded> nextLoaded() async =>
      await bloc.stream.firstWhere((s) => s is ProfileLoaded) as ProfileLoaded;

  Future<ProfileError> nextError() async =>
      await bloc.stream.firstWhere((s) => s is ProfileError) as ProfileError;

  Future<void> loadProfile() async {
    bloc.add(const LoadProfile());
    await nextLoaded();
  }

  // perfect score run
  Future<ProfileLoaded> submitAt(DateTime moment, {String itemsId = 'x'}) {
    now = moment;
    bloc.add(SubmitPracticeResult(itemsId: itemsId, score: 7, total: 7));
    return nextLoaded();
  }

  group('loadProfile', () {
    test('emits ProfileLoading then ProfileLoaded', () async {
      final states = <ProfileState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const LoadProfile());
      await pumpEventQueue(); // чтобы тест дождался, пока асинхронный код bloc-а отработает.

      expect(states, [
        isA<ProfileLoading>(),
        isA<ProfileLoaded>()
            .having((s) => s.profile.name, 'name', 'Гость')
            .having((s) => s.profile.experience, 'experience', 0),
      ]);

      await sub.cancel();
    });

    test(
      'emits ProfileLoading then ProfileError when repository throws',
      () async {
        dataSource.error = Exception('hive is down');

        final states = <ProfileState>[];
        final sub = bloc.stream.listen(states.add);

        bloc.add(const LoadProfile());
        await pumpEventQueue();

        expect(states, [
          isA<ProfileLoading>(),
          isA<ProfileError>().having(
            (s) => s.message,
            'message',
            contains('hive is down'),
          ),
        ]);

        await sub.cancel();
      },
    );
  });

  group('changeProfileName', () {
    test('trims name before saving', () async {
      await loadProfile();

      bloc.add(const ChangeProfileName('  Alex  '));
      final state = await nextLoaded();

      expect(dataSource.lastChangedName, 'Alex');
      expect(state.profile.name, 'Alex');
    });

    test('ignores blank name', () async {
      await loadProfile();

      bloc.add(const ChangeProfileName('   '));
      await pumpEventQueue();

      expect(dataSource.lastChangedName, isNull);
      expect(bloc.state, isA<ProfileLoaded>());
      expect((bloc.state as ProfileLoaded).profile.name, 'Гость');
    });

    test('keeps awardedPoints when name changes after a reward', () async {
      bloc.add(const SubmitPracticeResult(itemsId: 'x', score: 7, total: 7));
      final rewarded = await nextLoaded();
      expect(rewarded.awardedPoints, 5);

      bloc.add(const ChangeProfileName('Вася'));
      final renamed = await nextLoaded();

      expect(renamed.profile.name, 'Вася');
      expect(renamed.awardedPoints, 5);
    });

    test('emits ProfileError when saving fails', () async {
      await loadProfile();
      dataSource.error = Exception('hive is down');

      bloc.add(const ChangeProfileName('Вася'));
      final error = await nextError();

      expect(error.message, contains('hive is down'));
      expect(dataSource.lastChangedName, isNull);
      expect(bloc.state, isA<ProfileError>());
    });

    test('reloads the profile when the state is not loaded yet', () async {
      // состояние ещё ProfileInitial, поэтому опереться не на что и профиль
      // приходится перечитывать из репозитория
      expect(bloc.state, isA<ProfileInitial>());

      bloc.add(const ChangeProfileName('Вася'));
      final state = await nextLoaded();

      expect(state.profile.name, 'Вася');
      expect(state.awardedPoints, isNull);
    });

    test('reloads the profile after an error', () async {
      dataSource.error = Exception('hive is down');

      bloc.add(const LoadProfile());
      await nextError();

      dataSource.error = null;

      bloc.add(const ChangeProfileName('Вася'));
      final state = await nextLoaded();

      expect(bloc.state, isA<ProfileLoaded>());
      expect(state.profile.name, 'Вася');
    });

    test('emits ProfileError when reloading the profile fails', () async {
      // the name is written first and succeeds, the reload after it fails
      dataSource.errorOnRead = Exception('hive read is down');

      bloc.add(const ChangeProfileName('Вася'));
      final error = await nextError();

      expect(error.message, contains('hive read is down'));
      expect(dataSource.lastChangedName, 'Вася');
      expect(bloc.state, isA<ProfileError>());
    });
  });

  group('submitPracticeResult', () {
    test('emits ProfileLoaded with awardedPoints on perfect score', () async {
      bloc.add(const SubmitPracticeResult(itemsId: 'x', score: 7, total: 7));
      final state = await nextLoaded();

      expect(state.profile.experience, 5);
      expect(state.awardedPoints, 5);
    });

    test('emits awardedPoints null on imperfect score', () async {
      bloc.add(const SubmitPracticeResult(itemsId: 'x', score: 7, total: 8));
      final state = await nextLoaded();

      expect(state.profile.experience, 0);
      expect(state.awardedPoints, isNull);
    });

    test('emits ProfileError when repository throws', () async {
      dataSource.error = Exception('hive is down');

      bloc.add(const SubmitPracticeResult(itemsId: 'x', score: 7, total: 7));
      final error = await nextError();

      expect(error.message, contains('hive is down'));
    });

    test('emits awardedPoints null on a repeat run on the same day', () async {
      await submitAt(DateTime(2026, 3, 10, 9, 30));

      final state = await submitAt(DateTime(2026, 3, 10, 21, 0));

      expect(state.profile.experience, 5);
      expect(state.awardedPoints, isNull);
    });

    test('emits awardedPoints again on the next day', () async {
      await submitAt(DateTime(2026, 3, 10, 23, 59));

      final state = await submitAt(DateTime(2026, 3, 11, 0, 1));

      expect(state.profile.experience, 10);
      expect(state.awardedPoints, 5);
    });
  });
}
