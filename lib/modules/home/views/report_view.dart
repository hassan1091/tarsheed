import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/core/constants/app_constants.dart';
import 'package:tarsheed/models/device.dart';
import 'package:tarsheed/modules/home/blocs/home_bloc/home_bloc.dart';
import 'package:tarsheed/shared/themes/app_theme.dart';

class ReportView extends StatelessWidget {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: _homeListener,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: ListView(
            children: [
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                  child: _LineChart(data: _data),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(
                    parent: ClampingScrollPhysics()),
                itemCount: state.props.length,
                itemBuilder: (context, index) {
                  Iterable<DeviceHistory> dHs = state.props[index].history!
                      .where((element) =>
                          element.createdAt.year == DateTime.now().year);

                  Map<int, ChartData> monthlyDataMap = {};

                  for (DeviceHistory deviceHistory in dHs) {
                    int month = deviceHistory.createdAt.month;
                    if (monthlyDataMap.containsKey(month)) {
                      monthlyDataMap[month] = ChartData(
                        deviceHistory.createdAt,
                        deviceHistory.usage + monthlyDataMap[month]!.yData,
                      );
                    } else {
                      monthlyDataMap[month] = ChartData(
                          deviceHistory.createdAt, deviceHistory.usage);
                    }
                  }

                  List<ChartData> chartDataListTemp =
                      monthlyDataMap.values.toList();

                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(state.props[index].id),
                            Text(state.props[index].name),
                          ],
                        ),
                        SizedBox(
                          height: 200,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 16.0, top: 16.0),
                            child: _LineChart(data: chartDataListTemp),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _homeListener(BuildContext context, HomeState state) {
    if (state is HomeLoadingState) {
      AppTheme.showLoadingDialog(context);
    } else if (state is HomeSuccessState) {
      Navigator.pop(context); // Close the loading dialog
      AppTheme.showSnackBar(context, 'Device loading successful!');
    } else if (state is HomeErrorState) {
      Navigator.pop(context); // Close the loading dialog
      AppTheme.showSnackBar(context, state.message);
    }
  }

  Future<void> _refresh(BuildContext context) async {
    context.read<HomeBloc>().add(LoadHomeEvent());
  }

  static final _data = [
    ChartData(DateTime(2024, 1), 3),
    ChartData(DateTime(2024, 1), 2),
    ChartData(DateTime(2024, 2), 4),
    ChartData(DateTime(2024, 3), 6),
    ChartData(DateTime(2024, 4), 0),
    ChartData(DateTime(2024, 5), 7),
    ChartData(DateTime(2024, 6), 3),
    ChartData(DateTime(2024, 7), 8),
    ChartData(DateTime(2024, 8), 4),
    ChartData(DateTime(2024, 9), 9),
    ChartData(DateTime(2024, 10), 6),
    ChartData(DateTime(2024, 11), 2),
    ChartData(DateTime(2024, 12), 7),
  ];
}

class ChartData {
  final DateTime xTime;
  final int yData;

  ChartData(this.xTime, this.yData);

  int get month => xTime.month;

  int get day => xTime.day;
}

class _LineChart extends StatelessWidget {
  final List<ChartData> data;

  const _LineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final yAxisIntervals = calculateYAxisIntervals(data);

    return LineChart(
      LineChartData(
        lineBarsData: lineBarsData,
        titlesData: titlesData(yAxisIntervals),
        gridData: gridData,
        borderData: borderData,
        minX: 1,
        maxX: 12,
        minY: 0,
        maxY: yAxisIntervals.last.toDouble(),
      ),
    );
  }

  List<LineChartBarData> get lineBarsData => [
        LineChartBarData(
          isCurved: true,
          color: Colors.primaries[Random().nextInt(17)],
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(show: false),
          dotData: const FlDotData(show: false),
          spots: data
              .map((dataPoint) => FlSpot(
                  dataPoint.month.toDouble(), dataPoint.yData.toDouble()))
              .toList(),
        ),
      ];

  FlTitlesData titlesData(List<int> yAxisIntervals) => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 18,
            getTitlesWidget: (value, meta) => Text(
              _getMonthLabel(value.toInt()),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10),
            ),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            interval: 2,
            getTitlesWidget: (value, meta) {
              if (yAxisIntervals.contains(value.toInt())) {
                return Text(
                  '${value.toInt()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 10),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
              color: AppConstants.primaryColor.withOpacity(0.2), width: 2),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  String _getMonthLabel(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[month - 1];
  }

  // Function to calculate Y-axis intervals based on max Y value in the data
  List<int> calculateYAxisIntervals(List<ChartData> data) {
    final maxY = data.map((d) => d.yData).reduce((a, b) => a > b ? a : b);
    final interval = (maxY / 5).ceil();
    return List<int>.generate(6, (i) => i * interval);
  }
}
