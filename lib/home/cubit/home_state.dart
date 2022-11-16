part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.selectedPage = 0,
    this.temperature = 0,
    this.humidity = 0,
    this.temperatureLectures = const <double>[],
    this.humidityLectures = const <double>[],
  });

  final int selectedPage;
  final double temperature;
  final double humidity;
  final List<double> temperatureLectures;
  final List<double> humidityLectures;

  @override
  List<Object> get props => [
        selectedPage,
        temperature,
        humidity,
        temperatureLectures,
        humidityLectures,
      ];

  HomeState copyWith({
    int? selectedPage,
    double? temperature,
    double? humidity,
    List<double>? temperatureLectures,
    List<double>? humidityLectures,
  }) {
    return HomeState(
      selectedPage: selectedPage ?? this.selectedPage,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      temperatureLectures: temperatureLectures ?? this.temperatureLectures,
      humidityLectures: humidityLectures ?? this.humidityLectures,
    );
  }
}
