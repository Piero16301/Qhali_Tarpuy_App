part of 'chart_cubit.dart';

enum ChartStatus {
  initial,
  loading,
  success,
  error;

  bool get isInitial => this == ChartStatus.initial;
  bool get isLoading => this == ChartStatus.loading;
  bool get isSuccess => this == ChartStatus.success;
  bool get isError => this == ChartStatus.error;
}

class LecturesResponse {
  LecturesResponse({
    required this.lectures,
  });

  factory LecturesResponse.fromJson(Map<String, dynamic> json) =>
      LecturesResponse(
        lectures: List<Lecture>.from(
          json.keys.map(
            (x) => Lecture.fromJson(json[x] as Map<String, dynamic>),
          ),
        ),
      );

  final List<Lecture> lectures;
}

class Lecture {
  Lecture({
    required this.datetime,
    required this.values,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) => Lecture(
        datetime: DateTime(
          int.parse(json.keys.first.split('|')[2]),
          int.parse(json.keys.first.split('|')[1]),
          int.parse(json.keys.first.split('|')[0]),
          int.parse(json.keys.first.split('|')[3]),
          int.parse(json.keys.first.split('|')[4]),
          int.parse(json.keys.first.split('|')[5]),
        ),
        values: List<double>.from(json.values.first as List<dynamic>),
      );

  final DateTime datetime;
  final List<double> values;
}

class ChartState extends Equatable {
  const ChartState({
    this.status = ChartStatus.initial,
    this.selectedChartType = 0,
    this.temperatureLectures,
    this.humidityLectures,
  });

  final ChartStatus status;
  final int selectedChartType;
  final LecturesResponse? temperatureLectures;
  final LecturesResponse? humidityLectures;

  @override
  List<Object?> get props => [
        status,
        selectedChartType,
        temperatureLectures,
        humidityLectures,
      ];

  ChartState copyWith({
    ChartStatus? status,
    int? selectedChartType,
    LecturesResponse? temperatureLectures,
    LecturesResponse? humidityLectures,
  }) {
    return ChartState(
      status: status ?? this.status,
      selectedChartType: selectedChartType ?? this.selectedChartType,
      temperatureLectures: temperatureLectures ?? this.temperatureLectures,
      humidityLectures: humidityLectures ?? this.humidityLectures,
    );
  }
}
