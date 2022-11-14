import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mac_address/mac_address.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qhali Tarpuy App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Qhali Tarpuy App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String broker = '192.168.137.1';
  int port = 10000;
  String clientId = 'Mobile-App ';

  MqttServerClient? client;
  mqtt.MqttConnectionState? connectionState;

  double _temperture = 0.0;
  double _humidity = 0.0;

  StreamSubscription? subscription;

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttConnectionState.connected) {
      debugPrint('[MQTT client] Subscribing to ${topic.trim()}');
      client!.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    }
  }

  @override
  void initState() {
    super.initState();
    GetMac.macAddress.then((value) {
      clientId = clientId + value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Temperatura: $_temperture',
            ),
            Text(
              'Humedad: $_humidity',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _connect,
        tooltip: 'Conectar',
        child: const Icon(Icons.cloud),
      ),
    );
  }

  void _connect() async {
    client = MqttServerClient(broker, clientId);
    client!.port = port;
    client!.logging(on: false);
    client!.keepAlivePeriod = 30;
    client!.onDisconnected = _onDisconnected;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(mqtt.MqttQos.atMostOnce);

    debugPrint('[MQTT client] MQTT client connecting....');
    client!.connectionMessage = connMess;

    try {
      await client!.connect();
    } catch (e) {
      debugPrint('[MQTT client] ERROR: $e');
      _disconnect();
    }

    if (client!.connectionStatus!.state == mqtt.MqttConnectionState.connected) {
      debugPrint('[MQTT client] connected');
      setState(() {
        connectionState = client!.connectionStatus!.state;
      });
    } else {
      debugPrint('[MQTT client] ERROR: MQTT client connection failed - '
          'disconnecting, state is ${client!.connectionStatus!.state}');
      _disconnect();
    }

    subscription = client!.updates!.listen(_onMessage);

    _subscribeToTopic('test/topic');
  }

  void _disconnect() {
    debugPrint('[MQTT client] MQTT client disconnected');
    client!.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    debugPrint('[MQTT client] onDisconnected');
    setState(() {
      connectionState = client!.connectionStatus!.state;
      client = null;
      subscription!.cancel();
      subscription = null;
    });
    debugPrint('[MQTT client] MQTT client disconnected');
  }

  void _onMessage(List<mqtt.MqttReceivedMessage> event) {
    debugPrint('[MQTT client] message received ${event.length}');
    final mqtt.MqttPublishMessage recMess =
        event[0].payload as mqtt.MqttPublishMessage;
    final String message =
        mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    debugPrint('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- $message -->');
    debugPrint(client!.connectionStatus!.state.toString());
    debugPrint('[MQTT client] message with topic: ${event[0].topic}');
    debugPrint('[MQTT client] message with message: $message');

    if (message[6] == 'T') {
      setState(() {
        _temperture = double.parse(message.replaceRange(0, 10, ''));
      });
    } else {
      setState(() {
        _humidity = double.parse(message.replaceRange(0, 9, ''));
      });
    }
  }
}
