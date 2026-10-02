import 'package:clock/clock.dart';

import '../../domain/entities/user_profile.dart';
import '../../domain/entities/practice_reward_result.dart';
import '../../domain/interfaces/i_profile_repository.dart';
import '../datasources/profile_local_datasource.dart';

class ProfileRepository implements IProfileRepository {
  final ProfileLocalDatasource _local;
  final Clock _clock;

  const ProfileRepository(this._local, [this._clock = const Clock()]);

  // сколько очков опыта даётся за 100% прохождение темы
  static const int rewardPoints = 5;

  @override
  Future<UserProfile> getProfile() async {
    return UserProfile(
      name: _local.getName(),
      experience: _local.getExperience(),
    );
  }

  @override
  Future<void> setName(String name) => _local.setName(name);

  @override
  Future<PracticeRewardResult> registerPracticeResult({
    required String itemsId,
    required int score,
    required int total,
  }) async {
    final isPerfect = total > 0 && score == total;

    // не 100% прозождение
    if (!isPerfect) {
      return PracticeRewardResult(profile: await getProfile(), awarded: false);
    }

    final today = _todayString();
    final dates = _local.getExpDates();
    final lastAwardedDate = dates[itemsId];

    // по этой теме опыт сегодня уже получали
    if (lastAwardedDate == today) {
      return PracticeRewardResult(profile: await getProfile(), awarded: false);
    }

    // дата пишется до начисления опыта: если начисление упадёт, повторное
    // прохождение в тот же день уже не начислит опыт второй раз
    await _local.setExpDateForItem(itemsId, today);
    await _local.addExperience(rewardPoints);

    return PracticeRewardResult(
      profile: await getProfile(),
      awarded: true,
      pointsAwarded: rewardPoints,
    );
  }

  String _todayString() {
    final now = _clock.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
