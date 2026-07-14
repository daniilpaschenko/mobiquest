sealed class ProfileEvent {
  const ProfileEvent();
}

final class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

final class ChangeProfileName extends ProfileEvent {
  final String name;
  const ChangeProfileName(this.name);
}

// отправляется по завершении практики. Bloc сам решает, начислять ли опыт (100% + не начисляли сегодня по этой теме)
final class SubmitPracticeResult extends ProfileEvent {
  final String itemsId;
  final int score;
  final int total;

  const SubmitPracticeResult({
    required this.itemsId,
    required this.score,
    required this.total,
  });
}
