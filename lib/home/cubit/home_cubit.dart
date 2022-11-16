import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:mac_address/mac_address.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

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
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> setUpClientId() async {
    try {
      final macAddress = await GetMac.macAddress;
      emit(
        state.copyWith(
          clientId: state.clientId + macAddress,
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
}
