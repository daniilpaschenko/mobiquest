import '../entities/practice_reward_result.dart';
import '../interfaces/i_profile_repository.dart';

class RegisterPracticeResult {
  final IProfileRepository _repo;

  const RegisterPracticeResult(this._repo);

  Future<PracticeRewardResult> call({
    required String itemsId,
    required int score,
    required int total,
  }) =>
      _repo.registerPracticeResult(itemsId: itemsId, score: score, total: total);
}
