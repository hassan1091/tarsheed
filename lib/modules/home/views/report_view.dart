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
              DropdownButton(
                value: state.periodic,
                items: const [
                  DropdownMenuItem(
                    value: Periodic.daily,
                    child: Text("Daily"),
                  ),
                  DropdownMenuItem(
                    value: Periodic.monthly,
                    child: Text("Monthly"),
                  ),
                  DropdownMenuItem(
                    value: Periodic.yearly,
                    child: Text("Yearly"),
                  ),
                ],
                onChanged: (value) {
                  context.read<HomeBloc>().add(ChangePeriodicEvent(value!));
                },
              ),
              SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, top: 16.0),
                  child: switch (state.periodic) {
                    Periodic.daily => _DailyLineChart(data: _daysData),
                    Periodic.monthly => _MonthlyLineChart(data: _monthlyData),
                    Periodic.yearly => _YearlyLineChart(data: _yearsData),
                  },
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(
                    parent: ClampingScrollPhysics()),
                itemCount: state.props.length,
                itemBuilder: (context, index) {
                  final Device device = state.props[index];
                  final Widget lineChart = switch (state.periodic) {
                    Periodic.daily =>
                      _DailyLineChart(data: _monthlyChartData(device)),
                    Periodic.monthly =>
                      _MonthlyLineChart(data: _dailyChartData(device)),
                    Periodic.yearly =>
                      _YearlyLineChart(data: _yearlyChartData(device))
                  };

                  return SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [Text(device.id), Text(device.name)],
                        ),
                        SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 16.0,
                              top: 16.0,
                            ),
                            child: lineChart,
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

  static final _daysData = [
    ChartData(DateTime(2024, 11, 1), 9),
    ChartData(DateTime(2024, 11, 2), 9),
    ChartData(DateTime(2024, 11, 2), 2),
    ChartData(DateTime(2024, 11, 3), 4),
    ChartData(DateTime(2024, 11, 4), 7),
    ChartData(DateTime(2024, 11, 5), 6),
    ChartData(DateTime(2024, 11, 6), 5),
    ChartData(DateTime(2024, 11, 7), 7),
    ChartData(DateTime(2024, 11, 8), 3),
    ChartData(DateTime(2024, 11, 9), 8),
    ChartData(DateTime(2024, 11, 10), 4),
    ChartData(DateTime(2024, 11, 11), 9),
    ChartData(DateTime(2024, 11, 12), 6),
    ChartData(DateTime(2024, 11, 13), 2),
    ChartData(DateTime(2024, 11, 14), 7),
    ChartData(DateTime(2024, 11, 15), 8),
    ChartData(DateTime(2024, 11, 16), 4),
    ChartData(DateTime(2024, 11, 17), 6),
    ChartData(DateTime(2024, 11, 18), 9),
    ChartData(DateTime(2024, 11, 19), 3),
    ChartData(DateTime(2024, 11, 20), 5),
    ChartData(DateTime(2024, 11, 21), 7),
    ChartData(DateTime(2024, 11, 22), 4),
    ChartData(DateTime(2024, 11, 23), 6),
    ChartData(DateTime(2024, 11, 24), 8),
    ChartData(DateTime(2024, 11, 25), 9),
    ChartData(DateTime(2024, 11, 26), 3),
    ChartData(DateTime(2024, 11, 27), 5),
    ChartData(DateTime(2024, 11, 28), 7),
    ChartData(DateTime(2024, 11, 29), 4),
    ChartData(DateTime(2024, 11, 30), 6),
  ];

  List<ChartData> _dailyChartData(Device device) {
    Iterable<DeviceHistory> dHs = device.history!.where(
      (element) =>
          element.createdAt.month == DateTime.now().month &&
          element.createdAt.year == DateTime.now().year,
    );

    Map<int, ChartData> dailyDataMap = {};

    for (DeviceHistory deviceHistory in dHs) {
      int day = deviceHistory.createdAt.day;
      if (dailyDataMap.containsKey(day)) {
        dailyDataMap[day] = ChartData(
          deviceHistory.createdAt,
          deviceHistory.usage + dailyDataMap[day]!.yData,
        );
      } else {
        dailyDataMap[day] =
            ChartData(deviceHistory.createdAt, deviceHistory.usage);
      }
    }
    return dailyDataMap.values.toList();
  }

  static final _monthlyData = [
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

  List<ChartData> _monthlyChartData(Device device) {
    Iterable<DeviceHistory> dHs = device.history!.where(
      (element) => element.createdAt.year == DateTime.now().year,
    );

    Map<int, ChartData> monthlyDataMap = {};

    for (DeviceHistory deviceHistory in dHs) {
      int month = deviceHistory.createdAt.month;
      if (monthlyDataMap.containsKey(month)) {
        monthlyDataMap[month] = ChartData(
          deviceHistory.createdAt,
          deviceHistory.usage + monthlyDataMap[month]!.yData,
        );
      } else {
        monthlyDataMap[month] =
            ChartData(deviceHistory.createdAt, deviceHistory.usage);
      }
    }
    return monthlyDataMap.values.toList();
  }

  static final _yearsData = [
    ChartData(DateTime(2021, 1, 1), 2),
    ChartData(DateTime(2022, 2, 2), 5),
    ChartData(DateTime(2023, 3, 2), 6),
    ChartData(DateTime(2024, 4, 3), 8),
  ];

  List<ChartData> _yearlyChartData(Device device) {
    Map<int, ChartData> yearlyDataMap = {};

    for (DeviceHistory deviceHistory in device.history!) {
      int year = deviceHistory.createdAt.year;
      if (yearlyDataMap.containsKey(year)) {
        yearlyDataMap[year] = ChartData(
          deviceHistory.createdAt,
          deviceHistory.usage + yearlyDataMap[year]!.yData,
        );
      } else {
        yearlyDataMap[year] =
            ChartData(deviceHistory.createdAt, deviceHistory.usage);
      }
    }
    return yearlyDataMap.values.toList();
  }
}

class ChartData {
  final DateTime xTime;
  final int yData;

  ChartData(this.xTime, this.yData);

  int get year => xTime.year;

  int get month => xTime.month;

  int get day => xTime.day;
}

class _DailyLineChart extends StatelessWidget {
  final List<ChartData> data;

  const _DailyLineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final yAxisIntervals = calculateYAxisIntervals(data);

    return LineChart(
      LineChartData(
        lineBarsData: lineBarsData,
        titlesData: titlesData(yAxisIntervals),
        gridData: gridData,
        borderData: borderData,
        maxX: 30,
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
              .map((dataPoint) =>
                  FlSpot(dataPoint.day.toDouble(), dataPoint.yData.toDouble()))
              .toList(),
        ),
      ];

  FlTitlesData titlesData(List<int> yAxisIntervals) => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            reservedSize: 22,
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
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

  List<int> calculateYAxisIntervals(List<ChartData> data) {
    final maxY = data.map((d) => d.yData).reduce((a, b) => a > b ? a : b);
    final interval = (maxY / 5).ceil();
    return List<int>.generate(6, (i) => i * interval);
  }
}

class _MonthlyLineChart extends StatelessWidget {
  final List<ChartData> data;

  const _MonthlyLineChart({required this.data});

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

class _YearlyLineChart extends StatelessWidget {
  final List<ChartData> data;

  const _YearlyLineChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final yAxisIntervals = calculateYAxisIntervals(data);

    return LineChart(
      LineChartData(
        lineBarsData: lineBarsData,
        titlesData: titlesData(yAxisIntervals),
        gridData: gridData,
        borderData: borderData,
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
                  dataPoint.xTime.year.toDouble(), dataPoint.yData.toDouble()))
              .toList(),
        ),
      ];

  FlTitlesData titlesData(List<int> yAxisIntervals) => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            reservedSize: 22,
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
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

  List<int> calculateYAxisIntervals(List<ChartData> data) {
    final maxY = data.map((d) => d.yData).reduce((a, b) => a > b ? a : b);
    final interval = (maxY / 5).ceil();
    return List<int>.generate(6, (i) => i * interval);
  }
}
