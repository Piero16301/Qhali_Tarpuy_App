import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qhali_tarpuy_app/settings/settings.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Broker',
                  ),
                  initialValue: context.select<SettingsCubit, String>(
                    (cubit) => cubit.state.broker,
                  ),
                  onChanged: context.read<SettingsCubit>().brokerChanged,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Puerto',
                  ),
                  initialValue: context
                      .select<SettingsCubit, int>(
                        (cubit) => cubit.state.port,
                      )
                      .toString(),
                  keyboardType: TextInputType.number,
                  onChanged: context.read<SettingsCubit>().portChanged,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'ID Cliente',
                  ),
                  initialValue: context.select<SettingsCubit, String>(
                    (cubit) => cubit.state.clientId,
                  ),
                  onChanged: context.read<SettingsCubit>().clientIdChanged,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Topic',
                  ),
                  initialValue: context.select<SettingsCubit, String>(
                    (cubit) => cubit.state.topic,
                  ),
                  onChanged: context.read<SettingsCubit>().topicChanged,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: state.savingStatus.isInitial
                          ? const Color(0xFF13B9FF)
                          : state.savingStatus.isSaving
                              ? Colors.amber
                              : Colors.green,
                    ),
                    onPressed: () =>
                        context.read<SettingsCubit>().saveSettings(),
                    child: state.savingStatus.isInitial
                        ? const Text(
                            'Guardar ajustes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : state.savingStatus.isSaving
                            ? const SizedBox.square(
                                dimension: 25,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Ajustes guardados',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
