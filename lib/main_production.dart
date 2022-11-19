import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:qhali_tarpuy_app/app/app.dart';
import 'package:qhali_tarpuy_app/bootstrap.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  bootstrap(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final preferences = await SharedPreferences.getInstance();
    final httpClient = Dio(
      BaseOptions(
        baseUrl: 'https://qhali-tarpuy-app-default-rtdb.firebaseio.com',
        receiveTimeout: 3000,
      ),
    );
    return App(
      preferences: preferences,
      httpClient: httpClient,
    );
  });
}
