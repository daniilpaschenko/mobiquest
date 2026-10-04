import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobiquest/features/themes/domain/entities/items_preview.dart';
import 'package:mobiquest/features/themes/domain/usecases/get_items.dart';
import 'package:mobiquest/features/themes/presentation/blocs/themes_bloc.dart';
import 'package:mobiquest/features/themes/presentation/blocs/themes_event.dart';
import 'package:mobiquest/features/themes/presentation/blocs/themes_state.dart';

import '../../../../helpers/fake_themes_repository.dart';

/// Держит первый [IThemesRepository.getItems] на [gate], чтобы поймать
/// второй запрос, пока первый ещё в полёте
class GatedThemesRepository extends FakeThemesRepository {
  GatedThemesRepository(super.items);

  final Completer<void> gate = Completer<void>();

  /// Считаем именно старты запросов, а не их завершения
  int started = 0;

  @override
  Future<List<ItemsPreview>> getItems() {
    started++;
    return gate.future.then((_) => super.getItems());
  }
}

void main() {
  late FakeThemesRepository repository;
  late ThemesBloc bloc;

  const widget = ItemsPreview(
    id: 'widget',
    title: 'Widget',
    description: 'Описание виджета',
    theoryCount: 3,
    practiceCount: 5,
    tags: ['state', 'bloc'],
  );
  const layout = ItemsPreview(
    id: 'layout',
    title: 'Layout',
    description: 'Вёрстка и виджеты',
    theoryCount: 2,
    practiceCount: 4,
    tags: ['state'],
  );
  const blocTopic = ItemsPreview(
    id: 'bloc',
    title: 'Bloc',
    description: 'Состояние и события',
    theoryCount: 4,
    practiceCount: 6,
    tags: ['bloc'],
  );
  const all = [widget, layout, blocTopic];

  setUp(() {
    repository = FakeThemesRepository(all);
    bloc = ThemesBloc(getItems: GetItems(repository));
  });

  tearDown(() => bloc.close()); // закрываем bloc после каждого теста

  Future<ThemesLoaded> load() async {
    bloc.add(const LoadItems());
    await bloc.stream.firstWhere((s) => s is ThemesLoaded);
    return bloc.state as ThemesLoaded;
  }

  Future<ThemesLoaded> filter({
    String query = '',
    Set<String> selectedTags = const {},
  }) async {
    bloc.add(FilterItems(query: query, selectedTags: selectedTags));
    await bloc.stream
        .firstWhere((s) => s is ThemesLoaded && s.query == query)
        .then((_) => bloc.state as ThemesLoaded);
    return bloc.state as ThemesLoaded;
  }

  List<String> idsOf(ThemesLoaded state) =>
      state.items.map((e) => e.id).toList();

  group('LoadItems', () {
    test('не отправляет второй запрос, пока первый ещё грузится', () async {
      final gated = GatedThemesRepository(all);
      final gatedBloc = ThemesBloc(getItems: GetItems(gated));
      addTearDown(gatedBloc.close);

      gatedBloc.add(const LoadItems());
      await pumpEventQueue();
      expect(gated.started, 1);

      // экран тем и роутер отправляли LoadItems каждый: экран ждал бы второй
      // запрос индекса, а оба ответа писали бы в один файл кэша
      gatedBloc.add(const LoadItems());
      await pumpEventQueue();

      expect(gated.started, 1, reason: 'второй запрос всё-таки ушёл в сеть');

      gated.gate.complete();
      await pumpEventQueue();

      expect(gatedBloc.state, isA<ThemesLoaded>());
      expect(idsOf(gatedBloc.state as ThemesLoaded), ['widget', 'layout', 'bloc']);
    });

    test('перезагружает данные, когда предыдущая загрузка уже завершилась',
        () async {
      await load();
      expect(repository.getItemsCalls, 1);

      bloc.add(const LoadItems());
      await pumpEventQueue();

      expect(repository.getItemsCalls, 2);
    });

    test('не залипает после ошибки и позволяет повторить загрузку', () async {
      repository.error = Exception('network is down');
      bloc.add(const LoadItems());
      await bloc.stream.firstWhere((s) => s is ThemesError);

      repository.error = null;
      final state = await load();

      expect(idsOf(state), ['widget', 'layout', 'bloc']);
    });

    test('перезагрузка сбрасывает применённые фильтры', () async {
      await load();
      await filter(query: 'виджет', selectedTags: {'bloc'});

      final state = await load();

      expect(state.query, '');
      expect(state.selectedTags, isEmpty);
      expect(idsOf(state), ['widget', 'layout', 'bloc']);
    });
  });

  group('FilterItems: поиск', () {
    test('находит по title независимо от регистра', () async {
      await load();

      final state = await filter(query: 'WIDGET');

      expect(idsOf(state), ['widget']);
    });

    test('находит по description, даже если в title нет совпадения', () async {
      await load();

      final state = await filter(query: 'вёрстка');

      expect(idsOf(state), ['layout']);
    });

    test('пустой запрос оставляет все темы', () async {
      await load();

      final state = await filter();

      expect(idsOf(state), ['widget', 'layout', 'bloc']);
    });

    test('пустое совпадение даёт пустой список', () async {
      await load();

      final state = await filter(query: 'нет такого');

      expect(state.items, isEmpty);
    });
  });

  group('FilterItems: теги', () {
    test('одиночный тег оставляет все темы с ним', () async {
      await load();

      final state = await filter(selectedTags: {'bloc'});

      expect(idsOf(state), ['widget', 'bloc']);
    });

    test('несколько тегов объединяются через AND, а не OR', () async {
      await load();

      // 'state' есть у widget и layout, 'bloc' — у widget и bloc
      // AND оставляет только widget, OR вернул бы всех троих
      final state = await filter(selectedTags: {'state', 'bloc'});

      expect(idsOf(state), ['widget']);
    });

    test('теги неизвестные дают пустой список', () async {
      await load();

      final state = await filter(selectedTags: {'sql'});

      expect(state.items, isEmpty);
    });

    test('запрос и теги применяются одновременно', () async {
      await load();

      // 'виджет' находит widget и layout, тег 'bloc' — widget и bloc
      // Вместе остаётся только widget: OR вернул бы всех троих
      final state = await filter(query: 'виджет', selectedTags: {'bloc'});

      expect(idsOf(state), ['widget']);
    });
  });

  group('FilterItems: инварианты', () {
    test('повторные фильтры не сжимают список необратимо', () async {
      await load();

      await filter(query: 'виджет');
      await filter(selectedTags: {'bloc'});
      final state = await filter();

      expect(idsOf(state), ['widget', 'layout', 'bloc']);
      expect(state.allItems, hasLength(3));
    });

    test('сужение фильтра не меняет allItems и availableTags', () async {
      await load();

      final state = await filter(query: 'виджет');

      expect(idsOf(state), ['widget', 'layout']);
      expect(state.allItems, hasLength(3));
      expect(state.availableTags, ['bloc', 'state']);
    });

    test('фильтр до загрузки игнорируется, состояние не меняется', () async {
      final states = <ThemesState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const FilterItems(query: 'widget'));
      await pumpEventQueue();

      expect(states, isEmpty);
      expect(bloc.state, isA<ThemesInitial>());

      await sub.cancel();
    });

    test('фильтр после ошибки загрузки игнорируется', () async {
      repository.error = Exception('network is down');
      bloc.add(const LoadItems());
      await bloc.stream.firstWhere((s) => s is ThemesError);

      final states = <ThemesState>[];
      final sub = bloc.stream.listen(states.add);
      bloc.add(const FilterItems(query: 'widget'));
      await pumpEventQueue();

      expect(states, isEmpty);
      expect(bloc.state, isA<ThemesError>());

      await sub.cancel();
    });
  });
}