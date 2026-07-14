import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/navigation/app_router.dart';
import 'features/profile/data/datasources/profile_local_datasource.dart';
import 'features/profile/presentation/blocs/profile_bloc.dart';
import 'features/profile/presentation/blocs/profile_event.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // локальное хранилище профиля (имя + опыт), без регистрации/сети
  await Hive.initFlutter();
  await Hive.openBox(ProfileLocalDatasource.boxName);

  setupDependencies();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ProfileBloc — singleton на всё приложение, доступен с любого экрана
    // (нужен и на экране практики, и на экране профиля)
    return BlocProvider<ProfileBloc>.value(
      value: sl<ProfileBloc>()..add(const LoadProfile()),
      child: MaterialApp.router(
        title: 'MobiQuest',
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false, // убрать баннер дебага
      ),
    );
  }
}
