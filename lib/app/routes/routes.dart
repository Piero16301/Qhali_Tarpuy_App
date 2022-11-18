import 'package:go_router/go_router.dart';
import 'package:qhali_tarpuy_app/home/home.dart';
import 'package:qhali_tarpuy_app/settings/settings.dart';

GoRouter goRouter() {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
