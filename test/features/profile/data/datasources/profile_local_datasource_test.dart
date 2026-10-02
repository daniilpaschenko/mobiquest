import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mobiquest/features/profile/data/datasources/profile_local_datasource.dart';

void main() {
  late Directory dir;
  late ProfileLocalDatasource datasource;

  setUp(() async {
    // настоящий Hive на временной директории, чтобы тесты не трогали данные
    // приложения и не зависели от порядка запуска
    dir = await Directory.systemTemp.createTemp('mobiquest_profile_test');
    Hive.init(dir.path);
    await Hive.openBox(ProfileLocalDatasource.boxName);
    datasource = ProfileLocalDatasource();
  });

  tearDown(() async {
    await Hive.close();
    await dir.delete(recursive: true);
  });

  group('getName', () {
    test('returns defaultName when nothing is stored', () {
      expect(datasource.getName(), ProfileLocalDatasource.defaultName);
      expect(datasource.getName(), 'Гость');
    });

    test('returns the stored name', () async {
      await datasource.setName('Вася');

      expect(datasource.getName(), 'Вася');
    });

    test('does not expose the default when an empty name is stored', () async {
      
      await datasource.setName('');

      expect(datasource.getName(), 'Гость');
    });
  });

  group('getExperience', () {
    test('returns 0 when nothing is stored', () {
      expect(datasource.getExperience(), 0);
    });
  });

  group('addExperience', () {
    test('starts from 0 on an empty box', () async {
      await datasource.addExperience(5);

      expect(datasource.getExperience(), 5);
    });

    test('accumulates instead of overwriting', () async {
      await datasource.addExperience(5);
      await datasource.addExperience(5);
      await datasource.addExperience(10);

      expect(datasource.getExperience(), 20);
    });

    test('does not allow adding a negative number of points', () async {
      await datasource.addExperience(5);
      await datasource.addExperience(-1);

      expect(datasource.getExperience(), 5);
    });
  });

  group('getExpDates', () {
    test('returns an empty map when nothing is stored', () {
      expect(datasource.getExpDates(), isEmpty);
    });

    test('returns a defensive copy that does not affect storage', () async {
      await datasource.setExpDateForItem('x', '2026-03-10');

      final dates = datasource.getExpDates();
      dates['y'] = '2026-03-10';
      dates.remove('x');

      expect(datasource.getExpDates(), {'x': '2026-03-10'});
    });
  });

  group('setExpDateForItem', () {
    test('stores the date for the item', () async {
      await datasource.setExpDateForItem('x', '2026-03-10');

      expect(datasource.getExpDates(), {'x': '2026-03-10'});
    });

    test('keeps dates of other items', () async {
      await datasource.setExpDateForItem('x', '2026-03-10');
      await datasource.setExpDateForItem('y', '2026-03-11');

      expect(datasource.getExpDates(), {'x': '2026-03-10', 'y': '2026-03-11'});
    });

    test('overwrites the date of the same item', () async {
      await datasource.setExpDateForItem('x', '2026-03-10');
      await datasource.setExpDateForItem('x', '2026-03-11');

      expect(datasource.getExpDates(), {'x': '2026-03-11'});
    });
  });

  group('persistence', () {
    test('data survives closing and reopening the box', () async {
      await datasource.setName('Вася');
      await datasource.addExperience(15);
      await datasource.setExpDateForItem('x', '2026-03-10');

      await Hive.close();
      await Hive.openBox(ProfileLocalDatasource.boxName);

      expect(datasource.getName(), 'Вася');
      expect(datasource.getExperience(), 15);
      // after a reopen Hive hands back a Map<dynamic, dynamic>, so this also
      // covers the Map<String, String>.from cast
      expect(datasource.getExpDates(), {'x': '2026-03-10'});
    });
  });
}
