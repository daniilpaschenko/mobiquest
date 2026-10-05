import 'package:flutter_test/flutter_test.dart';
import 'package:mobiquest/core/datasources/items_content_source.dart';

import '../../helpers/fake_items_datasources.dart';

void main() {
  late FakeItemsRemoteDatasource remote;
  late FakeItemsCacheDatasource cache;
  late ItemsContentSource source;

  const cacheBody = {'from': 'cache'};
  const freshBody = {'from': 'remote'};

  setUp(() {
    remote = FakeItemsRemoteDatasource(items: {'a': freshBody});
    cache = FakeItemsCacheDatasource();
    source = ItemsContentSource(remote, cache);
  });

  group('getItem: когда кэш считается свежим', () {
    test('берёт кэш и не ходит в сеть, если версии равны', () async {
      cache.items['a'] = cacheBody;
      cache.versions['a'] = 5;

      final result = await source.getItem('a', remoteVersion: 5);

      expect(result, cacheBody);
      expect(remote.fetchedItems, isEmpty);
      expect(cache.savedItems, isEmpty);
    });

    test('берёт кэш, если он новее известной удалённой версии', () async {
      cache.items['a'] = cacheBody;
      cache.versions['a'] = 7;

      final result = await source.getItem('a', remoteVersion: 5);

      expect(result, cacheBody);
      expect(remote.fetchedItems, isEmpty);
    });

    test('идёт в сеть и перезаписывает кэш, если кэш отстал', () async {
      cache.items['a'] = cacheBody;
      cache.versions['a'] = 4;

      final result = await source.getItem('a', remoteVersion: 5);

      expect(result, freshBody);
      expect(remote.fetchedItems, ['a']);
      expect(cache.savedItems, [('a', freshBody, 5)]);
    });

    test('идёт в сеть, если известной версии в кэше вообще нет', () async {
      cache.items['a'] = cacheBody;

      final result = await source.getItem('a', remoteVersion: 5);

      expect(result, freshBody);
      expect(remote.fetchedItems, ['a']);
    });

    test('идёт в сеть, если кэш обещает свежесть, а тела в нём нет', () async {
      cache.versions['a'] = 5;

      final result = await source.getItem('a', remoteVersion: 5);

      expect(result, freshBody);
      expect(remote.fetchedItems, ['a']);
    });

    test('без remoteVersion не ходит в сеть даже при отставшем кэше', () async {
      cache.items['a'] = cacheBody;
      cache.versions['a'] = 1;

      final result = await source.getItem('a');

      expect(result, cacheBody);
      expect(remote.fetchedItems, isEmpty);
      expect(cache.savedItems, isEmpty);
    });

    test('без remoteVersion версия в кэше вообще не влияет на выбор', () async {
      cache.items['a'] = cacheBody;
      cache.versions['a'] = 99;

      final result = await source.getItem('a');

      expect(result, cacheBody);
      expect(remote.fetchedItems, isEmpty);
    });
  });

  group('getItem: сеть подвела', () {
    test('отдаёт протухший кэш вместо падения', () async {
      remote.error = Exception('offline');
      cache.items['a'] = cacheBody;
      cache.versions['a'] = 4;

      final result = await source.getItem('a', remoteVersion: 5);

      expect(result, cacheBody);
      expect(cache.savedItems, isEmpty);
    });

    test('отдаёт кэш и когда remoteVersion не передан', () async {
      cache.items['a'] = cacheBody;

      final result = await source.getItem('a');

      expect(result, cacheBody);
      expect(remote.fetchedItems, isEmpty);
    });

    test('бросает исключение с id, когда сеть упала и кэша нет', () async {
      remote.error = Exception('offline');

      await expectLater(
        source.getItem('a', remoteVersion: 5),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            allOf(contains('No data available'), contains('a')),
          ),
        ),
      );
    });

    test('бросает исключение с id, когда кэша нет и сеть не запрашивали', () async {
      await expectLater(
        source.getItem('a'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            allOf(contains('No data available'), contains('a')),
          ),
        ),
      );
      expect(remote.fetchedItems, isEmpty);
    });
  });

  group('getIndex', () {
    test('отдаёт ответ сети и кладёт его в кэш', () async {
      remote.index = const {'items': []};

      final result = await source.getIndex();

      expect(result, {'items': []});
      expect(cache.saveIndexCalls, 1);
      expect(cache.index, {'items': []});
    });

    test('при упавшей сети отдаёт кэш и не перезаписывает его', () async {
      remote.error = Exception('offline');
      cache.index = const {'items': []};

      final result = await source.getIndex();

      expect(result, {'items': []});
      expect(cache.saveIndexCalls, 0);
    });

    test('бросает понятное исключение, когда нет ни сети, ни кэша', () async {
      remote.error = Exception('offline');

      await expectLater(
        source.getIndex(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('No index available: no network and no cache'),
          ),
        ),
      );
    });
  });

  group('versionOf', () {
    test('возвращает версию нужного item', () {
      final index = {
        'items': [
          {'id': 'a', 'version': 3},
          {'id': 'b', 'version': 9},
        ],
      };

      expect(ItemsContentSource.versionOf(index, 'a'), 3);
      expect(ItemsContentSource.versionOf(index, 'b'), 9);
    });

    test('считает версией 1, если поле version отсутствует', () {
      final index = {
        'items': [
          {'id': 'a'},
        ],
      };

      expect(ItemsContentSource.versionOf(index, 'a'), 1);
    });
  });
}