import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qhali_tarpuy_app/charts/charts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartView extends StatelessWidget {
  const ChartView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ChartCubit>().getLectures();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<ChartCubit, ChartState>(
        builder: (context, state) {
          switch (state.selectedChartType) {
            case 0:
              return state.status == ChartStatus.success
                  ? TemperatureLineChart(
                      temperatureLectures: state.temperatureLectures!,
                    )
                  : const Center(child: CircularProgressIndicator());
            case 1:
              return state.status == ChartStatus.success
                  ? HumidityLineChart(
                      humidityLectures: state.humidityLectures!,
                    )
                  : const Center(child: CircularProgressIndicator());
            default:
              return const Center(
                child: Text('No se ha seleccionado un tipo de gráfico'),
              );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.select<ChartCubit, int>(
          (cubit) => cubit.state.selectedChartType,
        ),
        selectedItemColor: Colors.amber[800],
        onTap: (index) => context.read<ChartCubit>().changeChartType(index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat_outlined),
            label: 'Temperatura',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.water_outlined),
            label: 'Humedad',
          ),
        ],
      ),
    );
  }
}

class Data {
  Data(this.x, this.y);

  final DateTime x;
  final double y;
}

class TemperatureLineChart extends StatelessWidget {
  const TemperatureLineChart({
    super.key,
    required this.temperatureLectures,
  });

  final LecturesResponse temperatureLectures;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: 'Temperatura'),
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          dateFormat: DateFormat('hh:mm'),
          intervalType: DateTimeIntervalType.days,
          interval: 1,
          name: 'Fecha',
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}°C',
          minimum: 15,
          maximum: 35,
          interval: 1,
          majorGridLines: const MajorGridLines(color: Colors.transparent),
          name: 'Temperatura',
        ),
        series: <ChartSeries<Data, DateTime>>[
          LineSeries<Data, DateTime>(
            animationDuration: 1000,
            dataSource: _getTemperatureData(),
            xValueMapper: (Data data, _) => data.x,
            yValueMapper: (Data data, _) => data.y,
            width: 2,
            markerSettings: const MarkerSettings(isVisible: true),
            xAxisName: 'Fecha',
            yAxisName: 'Temperatura',
            name: 'Temperatura',
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }

  List<Data> _getTemperatureData() {
    final data = <Data>[];
    for (final lecture in temperatureLectures.lectures) {
      for (var i = 0; i < lecture.values.length; i++) {
        if (lecture.datetime
            .subtract(Duration(seconds: lecture.values.length - i))
            .isToday()) {
          data.add(
            Data(
              lecture.datetime.subtract(
                Duration(
                  seconds: lecture.values.length - i,
                ),
              ),
              lecture.values[i],
            ),
          );
        }
      }
    }
    return data;
  }
}

class HumidityLineChart extends StatelessWidget {
  const HumidityLineChart({
    super.key,
    required this.humidityLectures,
  });

  final LecturesResponse humidityLectures;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        title: ChartTitle(text: 'Humedad'),
        primaryXAxis: DateTimeAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          dateFormat: DateFormat('hh:mm'),
          intervalType: DateTimeIntervalType.days,
          interval: 1,
          name: 'Fecha',
        ),
        primaryYAxis: NumericAxis(
          labelFormat: '{value}%',
          minimum: 0,
          maximum: 100,
          interval: 5,
          majorGridLines: const MajorGridLines(color: Colors.transparent),
          name: 'Humedad',
        ),
        series: <ChartSeries<Data, DateTime>>[
          LineSeries<Data, DateTime>(
            animationDuration: 1000,
            dataSource: _getHumidityData(),
            xValueMapper: (Data data, _) => data.x,
            yValueMapper: (Data data, _) => data.y,
            width: 2,
            markerSettings: const MarkerSettings(isVisible: true),
            xAxisName: 'Fecha',
            yAxisName: 'Humedad',
            name: 'Humedad',
          ),
        ],
        tooltipBehavior: TooltipBehavior(enable: true),
      ),
    );
  }

  List<Data> _getHumidityData() {
    final data = <Data>[];
    for (final lecture in humidityLectures.lectures) {
      for (var i = 0; i < lecture.values.length; i++) {
        if (lecture.datetime
            .subtract(Duration(seconds: lecture.values.length - i))
            .isToday()) {
          data.add(
            Data(
              lecture.datetime.subtract(
                Duration(
                  seconds: lecture.values.length - i,
                ),
              ),
              lecture.values[i],
            ),
          );
        }
      }
    }
    return data;
  }
}

extension on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  // bool isYesterday() {
  //   final yesterday = DateTime.now().subtract(const Duration(days: 1));
  //   return year == yesterday.year &&
  //       month == yesterday.month &&
  //       day == yesterday.day;
  // }
}
