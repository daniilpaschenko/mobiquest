import 'package:flutter_test/flutter_test.dart';
import 'package:mobiquest/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:mobiquest/features/profile/data/repositories/profile_repository.dart';
import 'package:mobiquest/features/profile/domain/entities/user_profile.dart';

class FakeProfileLocalDatasource implements ProfileLocalDatasource {
  FakeProfileLocalDatasource({
    this.user = const UserProfile(name: 'Гость', experience: 0),
  });

  UserProfile user;
  String? lastChangedName;
  Object? error;
  Object? errorOnSetExpDate;
  final Map<String, String> _expDates = {};

  @override
  String getName() {
    if (error != null) throw error!;
    return user.name;
  }

  @override
  Future<void> setName(String name) async {
    if (error != null) throw error!;
    lastChangedName = name;
    user = user.copyWith(name: name);
  }

  @override
  int getExperience() {
    if (error != null) throw error!;
    return user.experience;
  }

  @override
  Future<void> addExperience(int amount) async {
    if (error != null) throw error!;
    user = user.copyWith(experience: user.experience + amount);
  }

  @override
  Map<String, String> getExpDates() {
    if (error != null) throw error!;
    return Map<String, String>.from(_expDates);
  }

  @override
  Future<void> setExpDateForItem(String itemsId, String isoDate) async {
    if (error != null) throw error!;
    if (errorOnSetExpDate != null) throw errorOnSetExpDate!;
    _expDates[itemsId] = isoDate;
  }
}

void main() {
  late FakeProfileLocalDatasource dataSource;
  late ProfileRepository repository;

  setUp(() {
    dataSource = FakeProfileLocalDatasource();
    repository = ProfileRepository(dataSource);
  });

  group('getProfile', () {
    test('returns default name Гость and experience 0', () async {
      final profile = await repository.getProfile();

      expect(profile.name, 'Гость');
      expect(profile.experience, 0);
    });
  });

  group('setName', () {
    test('updates name', () async {
      await repository.setName('someone');
      final profile = await repository.getProfile();

      expect(profile.name, 'someone');
    });
  });

  group('registerPracticeResult', () {
    test('does not award when score is not perfect', () async {
      final result = await repository.registerPracticeResult(
        itemsId: 'x',
        score: 7,
        total: 8,
      );

      expect(result.awarded, false);
      expect(result.profile.experience, 0);
    });

    test('awards 5 exp on perfect score', () async {
      final result = await repository.registerPracticeResult(
        itemsId: 'x',
        score: 7,
        total: 7,
      );

      expect(result.awarded, true);
      expect(result.pointsAwarded, 5);
      expect(result.profile.experience, 5);
    });

    test('does not award again for same item on same day', () async {
      await repository.registerPracticeResult(
        itemsId: 'x',
        score: 7,
        total: 7,
      );

      final result = await repository.registerPracticeResult(
        itemsId: 'x',
        score: 7,
        total: 7,
      );

      expect(result.awarded, false);
      expect(result.pointsAwarded, 0);
      expect(result.profile.experience, 5);
    });

    test('awards for different practices', () async {
      await repository.registerPracticeResult(
        itemsId: 'x',
        score: 7,
        total: 7,
      );

      final result = await repository.registerPracticeResult(
        itemsId: 'y',
        score: 7,
        total: 7,
      );

      expect(result.awarded, true);
      expect(result.pointsAwarded, 5);
      expect(result.profile.experience, 10);
    });

    test('does not award twice when saving exp date fails', () async {
      // имитация ошибки, что hive не смог сохранить запись даты
      dataSource.errorOnSetExpDate = Exception('hive is down');

      await expectLater(
        repository.registerPracticeResult(itemsId: 'x', score: 7, total: 7),
        throwsA(isA<Exception>()),
      );

      // ошибка ушла наружу, а не превратилась в молчаливый awarded: false,
      // и ничего не записалось: опыт не начислен, дата не сохранена
      expect(dataSource.user.experience, 0);
      expect(dataSource.getExpDates(), isEmpty);

      dataSource.errorOnSetExpDate = null; // снимаем поломку

      final retry = await repository.registerPracticeResult(
        itemsId: 'x',
        score: 7,
        total: 7,
      );

      // повтор начисляет опыт ровно один раз, а не удваивает
      expect(retry.awarded, true);
      expect(retry.pointsAwarded, 5);
      expect(retry.profile.experience, 5);
    });
  });
}