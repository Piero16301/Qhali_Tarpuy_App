import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  ChartCubit(
    this._httpClient,
  ) : super(const ChartState());

  final Dio _httpClient;

  Future<void> changeChartType(int index) async {
    try {
      emit(
        state.copyWith(
          selectedChartType: index,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getLectures() async {
    try {
      emit(
        state.copyWith(
          status: ChartStatus.loading,
        ),
      );
      final temperatureResponse =
          await _httpClient.get<Map<String, dynamic>>('/temperature.json');
      final humidityResponse =
          await _httpClient.get<Map<String, dynamic>>('/humidity.json');
      if (temperatureResponse.statusCode == 200 &&
          humidityResponse.statusCode == 200) {
        emit(
          state.copyWith(
            status: ChartStatus.success,
            temperatureLectures: LecturesResponse.fromJson(
              temperatureResponse.data!,
            ),
            humidityLectures: LecturesResponse.fromJson(
              humidityResponse.data!,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: ChartStatus.error,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: ChartStatus.error,
        ),
      );
    }
  }
}
