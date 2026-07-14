import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../injection.dart';
import '../widgets/mainshell.dart';

import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/themes/presentation/screens/themes_screen.dart';
import '../../features/themes/presentation/blocs/themes_bloc.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/items/presentation/screens/items_theory_screen.dart';
import '../../features/items/presentation/screens/items_practice_screen.dart';
import '../../features/items/presentation/blocs/items_bloc.dart';

import '../../features/themes/presentation/blocs/themes_event.dart';

import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'homeNav');
final _themesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'themesNav');
final _profileNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'profileNav');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        // ── THEMES ──────────────────────────────────────────────────
        StatefulShellBranch(
          navigatorKey: _themesNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.themes,
              name: 'themes',
              // ThemesBloc — singleton, живёт пока живёт ветка
              builder: (context, state) => BlocProvider.value(
                value: sl<ThemesBloc>()..add(const LoadItems()),
                child: const ThemesScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'items/:itemsId/theory',
                  builder: (context, state) => BlocProvider(
                    create: (_) => sl<ItemsBloc>(),
                    child: ItemsTheoryScreen(
                      itemsId: state.pathParameters['itemsId']!,
                      itemsTitle: state.extra as String,
                    ),
                  ),
                ),
                GoRoute(
                  path: 'items/:itemsId/practice',
                  builder: (context, state) => BlocProvider(
                    create: (_) => sl<ItemsBloc>(),
                    child: ItemsPracticeScreen(
                      itemsId: state.pathParameters['itemsId']!,
                      itemsTitle: state.extra as String,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // ── HOME ────────────────────────────────────────────────────
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // ── PROFILE ─────────────────────────────────────────────────
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              name: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);