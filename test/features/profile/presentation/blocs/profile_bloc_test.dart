import 'package:flutter_test/flutter_test.dart';
import 'package:mobiquest/features/profile/domain/entities/practice_reward_result.dart';
import 'package:mobiquest/features/profile/domain/entities/user_profile.dart';
import 'package:mobiquest/features/profile/domain/interfaces/i_profile_repository.dart';
import 'package:mobiquest/features/profile/domain/usecases/get_profile.dart';
import 'package:mobiquest/features/profile/domain/usecases/register_practice_result.dart';
import 'package:mobiquest/features/profile/domain/usecases/set_profile_name.dart';
import 'package:mobiquest/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:mobiquest/features/profile/presentation/blocs/profile_event.dart';
import 'package:mobiquest/features/profile/presentation/blocs/profile_state.dart';

class FakeProfileRepository implements IProfileRepository {
  FakeProfileRepository({
    this.profile = const UserProfile(name: 'Гость', experience: 0),
  });

  UserProfile profile;
  Object? error;
  String? lastChangedName;

  @override
  Future<UserProfile> getProfile() async {
    if (error != null) throw error!;
    return profile;
  }

  @override
  Future<void> setName(String name) async {
    if (error != null) throw error!;
    lastChangedName = name;
    profile = profile.copyWith(name: name);
  }

  @override
  Future<PracticeRewardResult> registerPracticeResult({
    required String itemsId,
    required int score,
    required int total,
  }) async {
    if (error != null) throw error!;

    final isPerfect = total > 0 && score == total;
    if (!isPerfect) {
      return PracticeRewardResult(profile: profile, awarded: false);
    }

    profile = profile.copyWith(experience: profile.experience + 5);
    return PracticeRewardResult(profile: profile, awarded: true, pointsAwarded: 5);
  }
}

void main() {
  late FakeProfileRepository repository;
  late ProfileBloc bloc;

  setUp(() {
    repository = FakeProfileRepository();
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

    test('emits ProfileLoading then ProfileError when repository throws', () async {
      repository.error = Exception('hive is down');

      final states = <ProfileState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const LoadProfile());
      await pumpEventQueue();

      expect(states, [
        isA<ProfileLoading>(),
        isA<ProfileError>()
            .having((s) => s.message, 'message', contains('hive is down')),
      ]);

      await sub.cancel();
    });
  });

  group('changeProfileName', () {
    test('trims name before saving', () async {
      await loadProfile();

      bloc.add(const ChangeProfileName('  Alex  '));
      final state = await nextLoaded();

      expect(repository.lastChangedName, 'Alex');
      expect(state.profile.name, 'Alex');
    });

    test('ignores blank name', () async {
      await loadProfile();

      bloc.add(const ChangeProfileName('   '));
      await pumpEventQueue();

      expect(repository.lastChangedName, isNull);
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
      repository.error = Exception('hive is down');

      bloc.add(const ChangeProfileName('Вася'));
      final error = await nextError();

      expect(error.message, contains('hive is down'));
      expect(repository.lastChangedName, isNull);
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
      repository.error = Exception('hive is down');

      bloc.add(const SubmitPracticeResult(itemsId: 'x', score: 7, total: 7));
      final error = await nextError();

      expect(error.message, contains('hive is down'));
    });
  });
}