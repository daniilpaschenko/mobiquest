class UserProfile {
  final String name;
  final int experience;

  const UserProfile({
    required this.name,
    required this.experience,
  });

  UserProfile copyWith({String? name, int? experience}) => UserProfile(
    name: name ?? this.name,
    experience: experience ?? this.experience,
  );
}
