import 'package:go_router/go_router.dart';
import 'package:qhali_tarpuy_app/home/home.dart';
import 'package:qhali_tarpuy_app/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoRouter goRouter({required SharedPreferences preferences}) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => HomePage(
          preferences: preferences,
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => SettingsPage(
          preferences: preferences,
        ),
      ),
    ],
    debugLogDiagnostics: true,
  );
}
