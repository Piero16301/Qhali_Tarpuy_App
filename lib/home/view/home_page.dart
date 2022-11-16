import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qhali_tarpuy_app/home/home.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qhali Tarpuy App'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            TemperatureIndicator(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Conectar',
        child: const Icon(Icons.cloud),
      ),
    );
  }
}

class TemperatureIndicator extends StatelessWidget {
  const TemperatureIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      animationDuration: 3500,
      enableLoadingAnimation: true,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: -50,
          maximum: 150,
          interval: 20,
          minorTicksPerInterval: 9,
          showAxisLine: false,
          radiusFactor: 0.9,
          labelOffset: 8,
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: -50,
              endValue: 0,
              startWidth: 0.265,
              sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.265,
              color: const Color.fromRGBO(34, 144, 199, 0.75),
            ),
            GaugeRange(
              startValue: 0,
              endValue: 10,
              startWidth: 0.265,
              sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.265,
              color: const Color.fromRGBO(34, 195, 199, 0.75),
            ),
            GaugeRange(
              startValue: 10,
              endValue: 30,
              startWidth: 0.265,
              sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.265,
              color: const Color.fromRGBO(123, 199, 34, 0.75),
            ),
            GaugeRange(
              startValue: 30,
              endValue: 40,
              startWidth: 0.265,
              sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.265,
              color: const Color.fromRGBO(238, 193, 34, 0.75),
            ),
            GaugeRange(
              startValue: 40,
              endValue: 150,
              startWidth: 0.265,
              sizeUnit: GaugeSizeUnit.factor,
              endWidth: 0.265,
              color: const Color.fromRGBO(238, 79, 34, 0.65),
            ),
          ],
          annotations: const <GaugeAnnotation>[
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.35,
              widget: Text(
                'Temp.°C',
                style: TextStyle(color: Color(0xFFF8B195), fontSize: 16),
              ),
            ),
            GaugeAnnotation(
              angle: 90,
              positionFactor: 0.8,
              widget: Text(
                '  22.5  ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            )
          ],
          pointers: const <GaugePointer>[
            NeedlePointer(
              value: 22.5,
              needleStartWidth: 0,
              needleEndWidth: 5,
              animationType: AnimationType.easeOutBack,
              enableAnimation: true,
              animationDuration: 1200,
              knobStyle: KnobStyle(
                  knobRadius: 0.06,
                  borderColor: Color(0xFFF8B195),
                  color: Colors.white,
                  borderWidth: 0.035),
              tailStyle:
                  TailStyle(color: Color(0xFFF8B195), width: 4, length: 0.15),
              needleColor: Color(0xFFF8B195),
            )
          ],
          axisLabelStyle: const GaugeTextStyle(fontSize: 10),
          majorTickStyle: const MajorTickStyle(
              length: 0.25, lengthUnit: GaugeSizeUnit.factor),
          minorTickStyle: const MinorTickStyle(
            length: 0.13,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
