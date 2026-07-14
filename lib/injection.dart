import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// core
import 'core/datasources/items_remote_datasource.dart';
import 'core/datasources/items_cache_datasource.dart';
import 'core/datasources/items_content_source.dart';

// themes
import 'features/themes/data/repositories/themes_repository.dart';
import 'features/themes/domain/usecases/get_items.dart';
import 'features/themes/presentation/blocs/themes_bloc.dart';

// items
import 'features/items/data/repositories/items_repository.dart';
import 'features/items/domain/usecases/get_items_theory.dart';
import 'features/items/domain/usecases/get_items_practice.dart';
import 'features/items/domain/usecases/get_items_preview.dart';
import 'features/items/presentation/blocs/items_bloc.dart';

// profile
import 'features/profile/data/datasources/profile_local_datasource.dart';
import 'features/profile/data/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_profile.dart';
import 'features/profile/domain/usecases/set_profile_name.dart';
import 'features/profile/domain/usecases/register_practice_result.dart';
import 'features/profile/presentation/blocs/profile_bloc.dart';

final sl = GetIt.instance;

void setupDependencies() {
  // core — общий источник контента (remote + cache + bundled fallback),
  final dio = Dio();
  final remoteDatasource = ItemsRemoteDatasource(dio);
  final cacheDatasource = ItemsCacheDatasource();
  final contentSource = ItemsContentSource(remoteDatasource, cacheDatasource);

  sl.registerLazySingleton<ItemsContentSource>(() => contentSource);

  // themes
  final themesRepo = ThemesRepository(sl<ItemsContentSource>());
  final getItems = GetItems(themesRepo);

  // singleton — список тем один на всё приложение
  sl.registerLazySingleton<ThemesBloc>(
    () => ThemesBloc(getItems: getItems),
  );

  // items
  final itemsRepo = ItemsRepository(sl<ItemsContentSource>());

  // factory — новый bloc для каждого открытого экрана темы
  sl.registerFactory<ItemsBloc>(
    () => ItemsBloc(
      getItemsTheory: GetItemsTheory(itemsRepo),
      getItemsPractice: GetItemsPractice(itemsRepo),
      getItemsPreviews: GetItemsPreviews(itemsRepo),
    ),
  );

  // profile — только локальное хранилище (Hive), без сети и регистрации
  final profileLocal = ProfileLocalDatasource();
  final profileRepo = ProfileRepository(profileLocal);

  // singleton — профиль (имя + опыт) один на всё приложение
  sl.registerLazySingleton<ProfileBloc>(
    () => ProfileBloc(
      getProfile: GetProfile(profileRepo),
      setProfileName: SetProfileName(profileRepo),
      registerPracticeResult: RegisterPracticeResult(profileRepo),
    ),
  );
}