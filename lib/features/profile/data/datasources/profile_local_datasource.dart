import 'package:hive/hive.dart';

// хранилище профиля на Hive, один Box с несколькими простыми ключами
class ProfileLocalDatasource {
  static const String boxName = 'profile_box';

  static const String _keyName = 'name';
  static const String _keyExperience = 'experience';
  // itemsId -> дата последнего начисления опыта по теме (yyyy-MM-dd)
  static const String _keyExpDates = 'expDates';

  static const String defaultName = 'Гость';

  Box get _box => Hive.box(boxName);

  String getName() => (_box.get(_keyName) as String?) ?? defaultName;

  Future<void> setName(String name) => _box.put(_keyName, name);

  int getExperience() => (_box.get(_keyExperience) as int?) ?? 0;

  Future<void> addExperience(int amount) async {
    final current = getExperience();
    await _box.put(_keyExperience, current + amount);
  }

  Map<String, String> getExpDates() {
    final raw = _box.get(_keyExpDates);
    if (raw == null) return {};
    return Map<String, String>.from(raw as Map);
  }

  Future<void> setExpDateForItem(String itemsId, String isoDate) async {
    final dates = getExpDates();
    dates[itemsId] = isoDate;
    await _box.put(_keyExpDates, dates);
  }
}
