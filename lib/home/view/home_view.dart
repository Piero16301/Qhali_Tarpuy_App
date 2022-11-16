import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qhali_tarpuy_app/home/home.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final _pages = <Widget>[
      const TemperatureIndicator(),
      const HumidityIndicator(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qhali Tarpuy App'),
        centerTitle: true,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return _pages[state.selectedPage];
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
                borderWidth: 0.035,
              ),
              tailStyle:
                  TailStyle(color: Color(0xFFF8B195), width: 4, length: 0.15),
              needleColor: Color(0xFFF8B195),
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
    );
  }
}

class HumidityIndicator extends StatelessWidget {
  const HumidityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
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
          maximum: 120,
          pointers: <GaugePointer>[
            WidgetPointer(
              offset: -2.5,
              value: 55.5,
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
                height: 37,
                width: 35,
                child: Center(
                  child: Row(
                    children: const <Widget>[
                      Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                      Center(
                        child: Text(
                          '55.5',
                          style: TextStyle(
                            color: Color.fromRGBO(126, 126, 126, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
          ranges: <GaugeRange>[
            GaugeRange(
              startValue: 0,
              endValue: 40,
              color: const Color.fromRGBO(74, 177, 70, 1),
            ),
            GaugeRange(
              startValue: 40,
              endValue: 80,
              color: const Color.fromRGBO(251, 190, 32, 1),
            ),
            GaugeRange(
              startValue: 80,
              endValue: 120,
              color: const Color.fromRGBO(237, 34, 35, 1),
            )
          ],
        )
      ],
    );
  }
}
