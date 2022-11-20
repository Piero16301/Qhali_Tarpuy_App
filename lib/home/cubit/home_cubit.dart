import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._preferences, this._httpClient) : super(const HomeState());

  final SharedPreferences _preferences;
  final Dio _httpClient;

  Future<void> intitializeMQTTValues() async {
    final broker = _preferences.getString('broker') ?? '';
    final port = _preferences.getInt('port') ?? 0;
    final clientId = _preferences.getString('clientId') ?? '';
    final topic = _preferences.getString('topic') ?? '';

    emit(
      state.copyWith(
        broker: broker,
        port: port,
        clientId: clientId,
        topic: topic,
      ),
    );
  }

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

  Future<void> saveLecturesToDatabase() async {
    try {
      final currentDateTime = DateTime.now().toStringSpanishDateTime();
      final temperatureResponse = await _httpClient.post<Map<String, dynamic>>(
        '/temperature.json',
        data: {currentDateTime: state.temperatureLectures},
      );
      final humidityResponse = await _httpClient.post<Map<String, dynamic>>(
        '/humidity.json',
        data: {currentDateTime: state.humidityLectures},
      );
      if (temperatureResponse.statusCode == 200 &&
          humidityResponse.statusCode == 200) {
        debugPrint('Lectures saved to database');
      }
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
      emit(
        state.copyWith(
          temperature: 0,
          humidity: 0,
          temperatureLectures: const <double>[],
          humidityLectures: const <double>[],
        ),
      );
    }
  }
}

extension on DateTime {
  String toStringSpanishDateTime() {
    return '$day|$month|$year|$hour|$minute|$second';
  }
}
