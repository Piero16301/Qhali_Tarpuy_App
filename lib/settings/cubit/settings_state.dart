part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.preferences,
    this.broker = '',
    this.port = 0,
    this.clientId = '',
    this.topic = '',
  });

  final SharedPreferences? preferences;
  final String broker;
  final int port;
  final String clientId;
  final String topic;

  @override
  List<Object?> get props => [
        preferences,
        broker,
        port,
        clientId,
        topic,
      ];

  SettingsState copyWith({
    SharedPreferences? preferences,
    String? broker,
    int? port,
    String? clientId,
    String? topic,
  }) {
    return SettingsState(
      preferences: preferences ?? this.preferences,
      broker: broker ?? this.broker,
      port: port ?? this.port,
      clientId: clientId ?? this.clientId,
      topic: topic ?? this.topic,
    );
  }
}
