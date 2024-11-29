import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:audiometer/model/data_model.dart';
import 'package:audiometer/constant/color.dart';

class ChartWidget extends StatelessWidget {
  final List<TestData> leftEarData;
  final List<TestData> rightEarData;

  const ChartWidget({
    super.key,
    required this.leftEarData,
    required this.rightEarData,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      // primaryXAxis: NumericAxis(
      //   title: const AxisTitle(
      //     text: 'Frequency (Hz)',
      //     textStyle: TextStyle(
      //       fontWeight: FontWeight.w800,
      //       color: kTextColor,
      //     ),
      //   ),
      //   minimum: 100,
      //   interval: 1000,
      //   maximum: 8000,
      //   majorGridLines: const MajorGridLines(width: 1),
      //   edgeLabelPlacement: EdgeLabelPlacement.shift,
      //   labelFormat: '{value}',
      //   labelStyle: TextStyle(color: kTextColor.withOpacity(0.7)),
      // ),
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: const NumericAxis(
        title: AxisTitle(
          text: 'Decibel (dB)',
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: kTextColor,
          ),
        ),
        minimum: 0,
        interval: 10,
        maximum: 100,
        isInversed: true,
        majorGridLines: MajorGridLines(width: 1.5),
        labelFormat: '{value}',
        axisLine: AxisLine(width: 0.8, color: Colors.grey),
      ),
      trackballBehavior: TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(
          enable: true,
          format: 'Frequency: point.x Hz\nDecibel: point.y dB',
        ),
      ),
      tooltipBehavior: TooltipBehavior(
        enable: true,
        format: 'Frequency: point.x Hz\nDecibel: point.y dB',
      ),
      series: <CartesianSeries<TestData, int>>[
        if (leftEarData.isNotEmpty)
          LineSeries<TestData, int>(
            color: Colors.red,
            dataSource: leftEarData,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
            ),
            xValueMapper: (data, _) => data.frequency,
            yValueMapper: (data, _) => data.decibel,
          ),
        if (rightEarData.isNotEmpty)
          LineSeries<TestData, int>(
            color: Colors.blue,
            dataSource: rightEarData,
            markerSettings: const MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.triangle,
            ),
            xValueMapper: (data, _) => data.frequency,
            yValueMapper: (data, _) => data.decibel,
          ),
      ],
      borderWidth: 0,
    );
  }
}
