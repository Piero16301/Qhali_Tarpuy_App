import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._preferences)
      : super(
          HomeState(
            broker: _preferences.getString('broker') ?? '',
            port: _preferences.getInt('port') ?? 0,
            clientId: _preferences.getString('clientId') ?? '',
            topic: _preferences.getString('topic') ?? '',
          ),
        );

  final SharedPreferences _preferences;

  Future<void> changeNavigationPage(int index) async {
    try {
      emit(
        state.copyWith(
          selectedPage: index,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> startStopReadingMQTT() async {
    try {
      emit(
        state.copyWith(
          isReadingMQTT: !state.isReadingMQTT,
          broker: _preferences.getString('broker') ?? '',
          port: _preferences.getInt('port') ?? 0,
          clientId: _preferences.getString('clientId') ?? '',
          topic: _preferences.getString('topic') ?? '',
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateTemperature(double temperature) async {
    try {
      emit(
        state.copyWith(
          temperature: temperature,
          temperatureLectures: List<double>.from(state.temperatureLectures)
            ..add(temperature),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> updateHumidity(double humidity) async {
    try {
      emit(
        state.copyWith(
          humidity: humidity,
          humidityLectures: List<double>.from(state.humidityLectures)
            ..add(humidity),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> restartLectures() async {
    try {
      emit(
        state.copyWith(
          temperature: 0,
          humidity: 0,
          temperatureLectures: const <double>[],
          humidityLectures: const <double>[],
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveNewTemperatureLecture() async {
    try {
      final currentTimeAsString = DateTime.now().toIso8601String();
      emit(
        state.copyWith(
          temperatureLectures: const <double>[],
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
