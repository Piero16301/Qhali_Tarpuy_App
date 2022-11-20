import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:qhali_tarpuy_app/charts/view/view.dart';
import 'package:qhali_tarpuy_app/home/home.dart';
import 'package:qhali_tarpuy_app/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoRouter goRouter({
  required SharedPreferences preferences,
  required Dio httpClient,
}) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => HomePage(
          preferences: preferences,
          httpClient: httpClient,
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsPage(
          preferences: preferences,
        ),
      ),
      GoRoute(
        path: '/charts',
        builder: (context, state) => ChartPage(
          httpClient: httpClient,
        ),
      ),
    ],
    debugLogDiagnostics: true,
  );
}
