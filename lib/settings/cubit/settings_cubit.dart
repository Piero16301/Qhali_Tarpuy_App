import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._preferences) : super(const SettingsState()) {
    _loadSettings();
  }

  final SharedPreferences _preferences;

  Future<void> _loadSettings() async {
    emit(
      state.copyWith(
        broker: _preferences.getString('broker') ?? '',
        port: _preferences.getInt('port') ?? 0,
        clientId: _preferences.getString('clientId') ?? '',
        topic: _preferences.getString('topic') ?? '',
      ),
    );
  }

  Future<void> brokerChanged(String broker) async {
    emit(
      state.copyWith(
        savingStatus: SavingStatus.initial,
        broker: broker,
      ),
    );
  }

  Future<void> portChanged(String port) async {
    emit(
      state.copyWith(
        savingStatus: SavingStatus.initial,
        port: int.tryParse(port) ?? 0,
      ),
    );
  }

  Future<void> clientIdChanged(String clientId) async {
    emit(
      state.copyWith(
        savingStatus: SavingStatus.initial,
        clientId: clientId,
      ),
    );
  }

  Future<void> topicChanged(String topic) async {
    emit(
      state.copyWith(
        savingStatus: SavingStatus.initial,
        topic: topic,
      ),
    );
  }

  Future<void> saveSettings() async {
    try {
      emit(state.copyWith(savingStatus: SavingStatus.saving));
      await _preferences.setString('broker', state.broker);
      await _preferences.setInt('port', state.port);
      await _preferences.setString('clientId', state.clientId);
      await _preferences.setString('topic', state.topic);
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(state.copyWith(savingStatus: SavingStatus.saved));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(savingStatus: SavingStatus.initial));
    }
  }
}
