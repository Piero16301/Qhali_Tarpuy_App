import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qhali_tarpuy_app/charts/charts.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({
    super.key,
    required this.httpClient,
  });

  final Dio httpClient;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChartCubit(
        httpClient,
      ),
      child: const ChartView(),
    );
  }
}
