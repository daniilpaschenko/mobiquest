import 'package:mobiquest/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:mobiquest/features/profile/domain/entities/user_profile.dart';

class FakeProfileLocalDatasource implements ProfileLocalDatasource {
  FakeProfileLocalDatasource({
    this.user = const UserProfile(name: 'Гость', experience: 0),
  });

  UserProfile user;
  String? lastChangedName;

  Object? error;

  /// thrown from [setExpDateForItem] only
  Object? errorOnSetExpDate;

  /// thrown from the read methods only ([getName], [getExperience]), so a write
  /// can succeed while a later reload fails
  Object? errorOnRead;

  final Map<String, String> _expDates = {};

  @override
  String getName() {
    if (error != null) throw error!;
    if (errorOnRead != null) throw errorOnRead!;
    return user.name;
  }

  @override
  Future<void> setName(String name) async {
    if (error != null) throw error!;
    lastChangedName = name;
    user = user.copyWith(name: name);
  }

  @override
  int getExperience() {
    if (error != null) throw error!;
    if (errorOnRead != null) throw errorOnRead!;
    return user.experience;
  }

  @override
  Future<void> addExperience(int amount) async {
    if (error != null) throw error!;
    if (amount <= 0) return;
    user = user.copyWith(experience: user.experience + amount);
  }

  @override
  Map<String, String> getExpDates() {
    if (error != null) throw error!;
    return Map<String, String>.from(_expDates);
  }

  @override
  Future<void> setExpDateForItem(String itemsId, String isoDate) async {
    if (error != null) throw error!;
    if (errorOnSetExpDate != null) throw errorOnSetExpDate!;
    _expDates[itemsId] = isoDate;
  }
}
