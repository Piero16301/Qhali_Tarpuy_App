import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qhali_tarpuy_app/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.preferences,
  });

  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(preferences),
      child: HomeView(
        preferences: preferences,
      ),
    );
  }
}
