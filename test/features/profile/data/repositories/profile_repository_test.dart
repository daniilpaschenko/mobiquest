import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobiquest/features/profile/data/repositories/profile_repository.dart';
import 'package:mobiquest/features/profile/domain/entities/practice_reward_result.dart';

import '../../../../helpers/fake_profile_local_datasource.dart';

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

    test('does not award when there are no questions', () async {
      // an empty practice passes score == total (0 == 0), so the total > 0
      // guard is the only thing that keeps it from being a perfect run
      final result = await repository.registerPracticeResult(
        itemsId: 'x',
        score: 0,
        total: 0,
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
      await repository.registerPracticeResult(itemsId: 'x', score: 7, total: 7);

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
      await repository.registerPracticeResult(itemsId: 'x', score: 7, total: 7);

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

  group('registerPracticeResult across days (clock injection)', () {
    late DateTime now;
    late Clock clock;

    setUp(() {
      // fixed "current time": March 10, 2026, 09:30
      now = DateTime(2026, 3, 10, 9, 30);
      clock = Clock(() => now);
      repository = ProfileRepository(dataSource, clock);
    });

    tearDown(() {
      // restore the repository that reads the real system clock
      repository = ProfileRepository(dataSource);
    });

    Future<PracticeRewardResult> practiceAt(
      DateTime moment, {
      String itemsId = 'x',
    }) {
      now = moment;
      return repository.registerPracticeResult(
        itemsId: itemsId,
        score: 7,
        total: 7,
      );
    }

    test('awards once a day and blocks a second run on the same day', () async {
      final first = await practiceAt(DateTime(2026, 3, 10, 9, 30));
      expect(first.awarded, true);

      // same day, evening: the date did not change, so no reward
      final evening = await practiceAt(DateTime(2026, 3, 10, 23, 59, 59));
      expect(evening.awarded, false);
      expect(evening.pointsAwarded, 0);
      expect(evening.profile.experience, 5);
    });

    test('awards again one minute after midnight', () async {
      await practiceAt(DateTime(2026, 3, 10, 23, 59, 59));

      final nextDay = await practiceAt(DateTime(2026, 3, 11, 0, 0, 1));

      expect(nextDay.awarded, true);
      expect(nextDay.pointsAwarded, 5);
      expect(nextDay.profile.experience, 10);
    });

    test('awards every consecutive day (5 days = 25 exp)', () async {
      for (var day = 10; day < 15; day++) {
        final result = await practiceAt(DateTime(2026, 3, day, 12));
        expect(result.awarded, true, reason: 'day $day must award exp');
      }

      expect(dataSource.user.experience, 25);
      expect(dataSource.getExpDates()['x'], '2026-03-14');
    });

    test('awards across month boundary', () async {
      await practiceAt(DateTime(2026, 1, 31, 23, 0));

      final february = await practiceAt(DateTime(2026, 2, 1, 0, 30));

      expect(february.awarded, true);
      expect(february.profile.experience, 10);
      expect(dataSource.getExpDates()['x'], '2026-02-01');
    });

    test('awards across year boundary', () async {
      await practiceAt(DateTime(2026, 12, 31, 23, 0));

      final newYear = await practiceAt(DateTime(2027, 1, 1, 8, 0));

      expect(newYear.awarded, true);
      expect(newYear.profile.experience, 10);
      expect(dataSource.getExpDates()['x'], '2027-01-01');
    });

    test('stale date from a previous year does not block the award', () async {
      // Feb 29, 2024: a stale date left over more than a year ago
      await dataSource.setExpDateForItem('x', '2024-02-29');

      final result = await practiceAt(DateTime(2026, 3, 10, 9, 30));

      expect(result.awarded, true);
      expect(result.profile.experience, 5);
      expect(dataSource.getExpDates()['x'], '2026-03-10');
    });

    test('items are limited independently and reset every day', () async {
      await practiceAt(DateTime(2026, 3, 10, 9, 30), itemsId: 'x');

      // a different item still earns exp on the same day
      final sameDay = await practiceAt(
        DateTime(2026, 3, 10, 20, 0),
        itemsId: 'y',
      );
      expect(sameDay.awarded, true);

      // the next day the daily limit resets for both items
      expect(
        (await practiceAt(DateTime(2026, 3, 11, 9, 30), itemsId: 'x')).awarded,
        true,
      );
      expect(
        (await practiceAt(DateTime(2026, 3, 11, 10, 0), itemsId: 'y')).awarded,
        true,
      );

      // but a repeated run on that same day awards nothing
      expect(
        (await practiceAt(DateTime(2026, 3, 11, 11, 0), itemsId: 'x')).awarded,
        false,
      );
      expect(
        (await practiceAt(DateTime(2026, 3, 11, 23, 0), itemsId: 'y')).awarded,
        false,
      );

      expect(dataSource.user.experience, 20);
      expect(dataSource.getExpDates(), {'x': '2026-03-11', 'y': '2026-03-11'});
    });

    test(
      'imperfect run does not consume the daily limit of the item',
      () async {
        await practiceAt(DateTime(2026, 3, 10, 9, 30));

        now = DateTime(2026, 3, 11, 9, 30);
        final partial = await repository.registerPracticeResult(
          itemsId: 'x',
          score: 6,
          total: 7,
        );
        expect(partial.awarded, false);

        // a perfect run later that day still gets the reward
        final perfect = await practiceAt(DateTime(2026, 3, 11, 10, 0));

        expect(perfect.awarded, true);
        expect(perfect.profile.experience, 10);
      },
    );

    test(
      'failing to store the date on a new day does not block retry',
      () async {
        await practiceAt(DateTime(2026, 3, 10, 9, 30));

        dataSource.errorOnSetExpDate = Exception('hive is down');

        await expectLater(
          practiceAt(DateTime(2026, 3, 11, 9, 30)),
          throwsA(isA<Exception>()),
        );

        dataSource.errorOnSetExpDate = null;

        final retry = await practiceAt(DateTime(2026, 3, 11, 12, 0));

        expect(retry.awarded, true);
        expect(retry.profile.experience, 10);
      },
    );
  });
}
