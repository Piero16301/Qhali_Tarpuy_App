part of 'home_cubit.dart';

class HomeState extends Equatable {
  const HomeState({
    this.selectedPage = 0,
    this.isReadingMQTT = false,
    this.temperature = 0,
    this.humidity = 0,
    this.temperatureLectures = const <double>[],
    this.humidityLectures = const <double>[],

    // MQTT variables
    this.broker = '',
    this.port = 0,
    this.clientId = '',
    this.topic = '',
  });

  final int selectedPage;
  final bool isReadingMQTT;
  final double temperature;
  final double humidity;
  final List<double> temperatureLectures;
  final List<double> humidityLectures;

  // MQTT variables
  final String broker;
  final int port;
  final String clientId;
  final String topic;

  @override
  List<Object> get props => [
        selectedPage,
        isReadingMQTT,
        temperature,
        humidity,
        temperatureLectures,
        humidityLectures,

        // MQTT variables
        broker,
        port,
        clientId,
        topic,
      ];

  HomeState copyWith({
    int? selectedPage,
    bool? isReadingMQTT,
    double? temperature,
    double? humidity,
    List<double>? temperatureLectures,
    List<double>? humidityLectures,

    // MQTT variables
    String? broker,
    int? port,
    String? clientId,
    String? topic,
  }) {
    return HomeState(
      selectedPage: selectedPage ?? this.selectedPage,
      isReadingMQTT: isReadingMQTT ?? this.isReadingMQTT,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      temperatureLectures: temperatureLectures ?? this.temperatureLectures,
      humidityLectures: humidityLectures ?? this.humidityLectures,

      // MQTT variables
      broker: broker ?? this.broker,
      port: port ?? this.port,
      clientId: clientId ?? this.clientId,
      topic: topic ?? this.topic,
    );
  }
}
