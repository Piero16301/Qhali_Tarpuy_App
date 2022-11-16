import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
}
