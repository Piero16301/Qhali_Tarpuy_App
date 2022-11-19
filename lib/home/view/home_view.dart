// ignore_for_file: cancel_subscriptions, strict_raw_type

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:qhali_tarpuy_app/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.preferences,
  });

  final SharedPreferences preferences;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  MqttServerClient? client;
  mqtt.MqttConnectionState? connectionState;
  StreamSubscription? subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qhali Tarpuy App'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          switch (state.selectedPage) {
            case 0:
              return TemperatureIndicator(
                temperature: state.temperature,
              );
            case 1:
              return HumidityIndicator(
                humidity: state.humidity,
              );
            default:
              return const Center(
                child: Text('No se ha seleccionado ninguna página'),
              );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Temperatura',
            icon: Icon(Icons.thermostat),
          ),
          BottomNavigationBarItem(
            label: 'Humedad',
            icon: Icon(Icons.water),
          ),
        ],
        currentIndex:
            context.select((HomeCubit cubit) => cubit.state).selectedPage,
        selectedItemColor: Colors.amber[800],
        onTap: (index) => context.read<HomeCubit>().changeNavigationPage(index),
      ),
      floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              context.read<HomeCubit>().startStopReadingMQTT();
              if (!state.isReadingMQTT) {
                connectToMQTT(
                  broker: state.broker,
                  clientId: state.clientId,
                  port: state.port,
                  topic: state.topic,
                );
              } else {
                context.read<HomeCubit>().saveLecturesToDatabase();
                disconnect();
              }
            },
            child: state.isReadingMQTT
                ? const Icon(Icons.pause_circle_filled_outlined)
                : const Icon(Icons.play_circle_filled_outlined),
          );
        },
      ),
    );
  }

  Future<void> connectToMQTT({
    required String broker,
    required String clientId,
    required int port,
    required String topic,
  }) async {
    try {
      client = MqttServerClient(broker, clientId);
      client!.port = port;
      client!.logging(on: false);
      client!.keepAlivePeriod = 30;
      client!.onDisconnected = onDisconnected;

      final connMess = mqtt.MqttConnectMessage()
          .withClientIdentifier(clientId)
          .startClean()
          .withWillQos(mqtt.MqttQos.atMostOnce);

      debugPrint('[MQTT client] MQTT client connecting....');
      client!.connectionMessage = connMess;

      try {
        await client!.connect();
      } catch (e) {
        debugPrint('[MQTT client] ERROR: $e');
        disconnect();
      }

      if (client!.connectionStatus!.state ==
          mqtt.MqttConnectionState.connected) {
        debugPrint('[MQTT client] connected');
        setState(() {
          connectionState = client!.connectionStatus!.state;
        });
      } else {
        debugPrint('[MQTT client] ERROR: MQTT client connection failed - '
            'disconnecting, state is ${client!.connectionStatus!.state}');
        disconnect();
      }

      subscription = client!.updates!.listen(onMessage);

      subscribeToTopic(topic);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      debugPrint('[MQTT client] Subscribing to ${topic.trim()}');
      client!.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    }
  }

  void onMessage(List<mqtt.MqttReceivedMessage> event) {
    debugPrint('[MQTT client] message received ${event.length}');
    final recMess = event[0].payload as mqtt.MqttPublishMessage;
    final message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    debugPrint('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- $message -->');
    debugPrint(client!.connectionStatus!.state.toString());
    debugPrint('[MQTT client] message with topic: ${event[0].topic}');
    debugPrint('[MQTT client] message with message: $message');

    if (message[6] == 'T') {
      context.read<HomeCubit>().updateTemperature(
            double.tryParse(
                  message.replaceRange(
                    0,
                    10,
                    '',
                  ),
                ) ??
                0,
          );
    } else {
      context.read<HomeCubit>().updateHumidity(
            double.tryParse(
                  message.replaceRange(
                    0,
                    9,
                    '',
                  ),
                ) ??
                0,
          );
    }
  }

  void disconnect() {
    debugPrint('[MQTT client] MQTT client disconnected');
    try {
      client!.disconnect();
    } catch (e) {
      debugPrint('[MQTT client] ERROR: $e');
    }
    onDisconnected();
  }

  void onDisconnected() {
    debugPrint('[MQTT client] onDisconnected');
    try {
      setState(() {
        connectionState = client!.connectionStatus!.state;
        client = null;
        subscription!.cancel();
        subscription = null;
      });
    } catch (e) {
      debugPrint('[MQTT client] ERROR: $e');
    }
    debugPrint('[MQTT client] MQTT client disconnected');
  }
}

class TemperatureIndicator extends StatelessWidget {
  const TemperatureIndicator({
    super.key,
    required this.temperature,
  });

  final double temperature;

  @override
  Widget build(BuildContext context) {
    const interval1 = 15.0;
    const interval2 = 30.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SfRadialGauge(
        animationDuration: 1000,
        enableLoadingAnimation: true,
        axes: <RadialAxis>[
          RadialAxis(
            interval: 5,
            minorTicksPerInterval: 4,
            showAxisLine: false,
            radiusFactor: 0.9,
            labelOffset: 8,
            maximum: 101,
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: interval1,
                startWidth: 0.265,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.265,
                color: Colors.blueAccent.withOpacity(0.75),
              ),
              GaugeRange(
                startValue: interval1,
                endValue: interval2,
                startWidth: 0.265,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.265,
                color: Colors.greenAccent.withOpacity(0.75),
              ),
              GaugeRange(
                startValue: interval2,
                endValue: 101,
                startWidth: 0.265,
                sizeUnit: GaugeSizeUnit.factor,
                endWidth: 0.265,
                color: Colors.redAccent.withOpacity(0.75),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                angle: temperature >= 25 ? 90 : 270,
                positionFactor: 0.3,
                widget: const Text(
                  'Temperatura (°C)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GaugeAnnotation(
                angle: 90,
                positionFactor: 0.8,
                widget: Text(
                  temperature.toStringAsFixed(2),
                  style: TextStyle(
                    color: temperature <= interval1
                        ? Colors.blueAccent
                        : temperature <= interval2
                            ? Colors.greenAccent
                            : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: temperature,
                needleStartWidth: 0,
                needleEndWidth: 5,
                animationType: AnimationType.easeOutBack,
                enableAnimation: true,
                animationDuration: 1200,
                knobStyle: KnobStyle(
                  knobRadius: 0.06,
                  borderColor: temperature <= interval1
                      ? Colors.blueAccent
                      : temperature <= interval2
                          ? Colors.greenAccent
                          : Colors.redAccent,
                  color: Colors.white,
                  borderWidth: 0.035,
                ),
                tailStyle: TailStyle(
                  color: temperature <= interval1
                      ? Colors.blueAccent
                      : temperature <= interval2
                          ? Colors.greenAccent
                          : Colors.redAccent,
                  width: 4,
                  length: 0.15,
                ),
                needleColor: temperature <= interval1
                    ? Colors.blueAccent
                    : temperature <= interval2
                        ? Colors.greenAccent
                        : Colors.redAccent,
              )
            ],
            axisLabelStyle: const GaugeTextStyle(fontSize: 10),
            majorTickStyle: const MajorTickStyle(
              length: 0.25,
              lengthUnit: GaugeSizeUnit.factor,
            ),
            minorTickStyle: const MinorTickStyle(
              length: 0.13,
              lengthUnit: GaugeSizeUnit.factor,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class HumidityIndicator extends StatelessWidget {
  const HumidityIndicator({
    super.key,
    required this.humidity,
  });

  final double humidity;

  @override
  Widget build(BuildContext context) {
    const interval1 = 35.0;
    const interval2 = 65.0;

    return SfRadialGauge(
      animationDuration: 1000,
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
          interval: 10,
          labelOffset: 0.1,
          tickOffset: 0.125,
          minorTicksPerInterval: 0,
          labelsPosition: ElementsPosition.outside,
          offsetUnit: GaugeSizeUnit.factor,
          showAxisLine: false,
          showLastLabel: true,
          radiusFactor: 0.8,
          pointers: <GaugePointer>[
            WidgetPointer(
              offset: -2.5,
              value: humidity,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.black.withOpacity(0.1),
                  ),
                ),
                height: 45,
                width: 45,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.opacity,
                        color: humidity <= interval1
                            ? Colors.redAccent
                            : humidity <= interval2
                                ? Colors.greenAccent
                                : Colors.blueAccent,
                        size: 20,
                      ),
                      Text(
                        humidity.toStringAsFixed(2),
                        style: TextStyle(
                          color: humidity <= interval1
                              ? Colors.redAccent
                              : humidity <= interval2
                                  ? Colors.greenAccent
                                  : Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
          annotations: <GaugeAnnotation>[
            const GaugeAnnotation(
              angle: 90,
              positionFactor: 0.1,
              widget: Text(
                'Humedad (%)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.8,
              widget: Text(
                humidity.toStringAsFixed(2),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: humidity <= interval1
                      ? Colors.redAccent
                      : humidity <= interval2
                          ? Colors.greenAccent
                          : Colors.blueAccent,
                ),
              ),
            ),
          ],
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: interval1,
              color: Colors.redAccent,
            ),
            GaugeRange(
              startValue: interval1,
              endValue: interval2,
              color: Colors.greenAccent,
            ),
            GaugeRange(
              startValue: interval2,
              endValue: 100,
              // blue color
              color: Colors.blueAccent,
            )
          ],
        )
      ],
    );
  }
}
