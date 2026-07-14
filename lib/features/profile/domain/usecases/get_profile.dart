import '../entities/user_profile.dart';
import '../interfaces/i_profile_repository.dart';

class GetProfile {
  final IProfileRepository _repo;

  const GetProfile(this._repo);

  Future<UserProfile> call() => _repo.getProfile();
}
