import '../../domain/entities/user_profile.dart';

sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  final int? awardedPoints;

  const ProfileLoaded(this.profile, {this.awardedPoints});

  ProfileLoaded copyWith({UserProfile? profile, int? awardedPoints}) {
    return ProfileLoaded(
      profile ?? this.profile,
      awardedPoints: awardedPoints ?? this.awardedPoints,
    );
  }
}

final class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
}
