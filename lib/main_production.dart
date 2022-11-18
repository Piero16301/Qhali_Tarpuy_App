import 'package:flutter/cupertino.dart';
import 'package:qhali_tarpuy_app/app/app.dart';
import 'package:qhali_tarpuy_app/bootstrap.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  bootstrap(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final preferences = await SharedPreferences.getInstance();
    return App(
      preferences: preferences,
    );
  });
}
