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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Broker',
              ),
              onChanged: context.read<SettingsCubit>().brokerChanged,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Puerto',
              ),
              onChanged: context.read<SettingsCubit>().portChanged,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Cliente ID',
              ),
              onChanged: context.read<SettingsCubit>().clientIdChanged,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Tópico',
              ),
              onChanged: context.read<SettingsCubit>().topicChanged,
            ),
          ],
        ),
      ),
    );
  }
}
