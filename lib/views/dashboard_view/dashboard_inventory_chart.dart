import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardInventoryChart extends StatefulWidget {
  DashboardInventoryChart({Key? key}) : super(key: key);

  @override
  State<DashboardInventoryChart> createState() =>
      _DashboardInventoryChartState();
}

class _DashboardInventoryChartState extends State<DashboardInventoryChart> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart();
  }
}
