import '../entities/user_profile.dart';
import '../entities/practice_reward_result.dart';

abstract class IProfileRepository {
  Future<UserProfile> getProfile();

  Future<void> setName(String name);

  Future<PracticeRewardResult> registerPracticeResult({
    required String itemsId,
    required int score,
    required int total,
  });
}
