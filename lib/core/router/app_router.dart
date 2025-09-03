import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lemon/core/my_app.dart';
import 'package:lemon/features/playList/songs_list_page.dart';
import 'package:lemon/features/settings/presentation/InnerPages/info_page.dart';
import 'package:lemon/core/data/models/models.dart';

/// Route names for type-safe navigation.
abstract class AppRoutes {
  static const String home = '/';
  static const String album = '/album';
  static const String info = '/info';
}

/// A simple route data object for album details.
/// We pass the Album via `extra` to avoid deep serialization.
class AlbumRouteData {
  final Album album;
  const AlbumRouteData(this.album);
}

/// A Riverpod provider that exposes a configured GoRouter.
final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => const NoTransitionPage(child: MyApp()),
      ),
      GoRoute(
        path: AppRoutes.album,
        name: 'album',
        pageBuilder: (context, state) {
          final data = state.extra;
          if (data is! AlbumRouteData) {
            return const MaterialPage(
                child:
                    Scaffold(body: Center(child: Text('Invalid album route'))));
          }
          // SongsListPage reads state from songListProvider which must be
          // initialized by the caller before navigation.
          return const MaterialPage(child: SongsListPage());
        },
      ),
      GoRoute(
        path: AppRoutes.info,
        name: 'info',
        pageBuilder: (context, state) => const MaterialPage(child: InfoPage()),
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        appBar: AppBar(title: const Text('Not found')),
        body: Center(child: Text(state.error?.toString() ?? 'Route not found')),
      ),
    ),
    // Restores the last route on hot reload in dev nicely.
    debugLogDiagnostics: false,
    observers: <NavigatorObserver>[
      _RouteObserver(),
    ],
  );
});

class _RouteObserver extends NavigatorObserver {}
