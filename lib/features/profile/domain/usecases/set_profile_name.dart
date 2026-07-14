import '../interfaces/i_profile_repository.dart';

class SetProfileName {
  final IProfileRepository _repo;

  const SetProfileName(this._repo);

  Future<void> call(String name) => _repo.setName(name);
}
