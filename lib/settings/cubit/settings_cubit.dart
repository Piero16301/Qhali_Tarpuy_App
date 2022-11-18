import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState()) {
    _init();
  }

  Future<void> _init() async {
    final preferences = await SharedPreferences.getInstance();
    emit(state.copyWith(preferences: preferences));
  }

  Future<void> brokerChanged(String broker) async {
    emit(state.copyWith(broker: broker));
  }

  Future<void> portChanged(String port) async {
    emit(state.copyWith(port: int.tryParse(port) ?? 0));
  }

  Future<void> clientIdChanged(String clientId) async {
    emit(state.copyWith(clientId: clientId));
  }

  Future<void> topicChanged(String topic) async {
    emit(state.copyWith(topic: topic));
  }
}
