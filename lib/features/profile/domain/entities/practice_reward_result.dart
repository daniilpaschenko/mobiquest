import 'user_profile.dart';

class PracticeRewardResult {
  final UserProfile profile;
  final bool awarded; // был ли начислен опыт
  final int pointsAwarded; // сколько очков начислено

  const PracticeRewardResult({
    required this.profile,
    required this.awarded,
    this.pointsAwarded = 0, // по дефолту 0
  });
}
