import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../constant/color.dart';

class AudioAnalysisScreen extends StatefulWidget {
  const AudioAnalysisScreen({super.key});

  @override
  State<AudioAnalysisScreen> createState() => _AudioAnalysisScreenState();
}

class _AudioAnalysisScreenState extends State<AudioAnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Audio Analysis Overview',
          style: TextStyle(
            color: kTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kTertiaryColor,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('patients').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No data available.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }

          List<Map<String, dynamic>> data = _processData(snapshot);

          final averageDecibels = _calculateAverageDecibels(data);
          final ageDistribution = _calculateAgeDistribution(snapshot);
          final hearingStatus = _calculateHearingStatus(data);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Average Decibels by Frequency"),
                  _buildDecibelChart(averageDecibels),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Age Group by Percentage"),
                  _buildPieChart(ageDistribution),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Hearing Status Distribution"),
                  _buildHearingStatusChart(hearingStatus),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: kTextColor,
      ),
    );
  }

  // Process snapshot data
  List<Map<String, dynamic>> _processData(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.expand((doc) {
      final leftEarData = List<Map<String, dynamic>>.from(doc['leftEarData']);
      final rightEarData = List<Map<String, dynamic>>.from(doc['rightEarData']);
      return [
        ..._mapEarData(leftEarData, doc['name']),
        ..._mapEarData(rightEarData, doc['name']),
      ];
    }).toList();
  }

  List<Map<String, dynamic>> _mapEarData(
      List<Map<String, dynamic>> earData, String name) {
    return earData
        .map((data) => {
              'name': name,
              'frequency': data['frequency'],
              'decibel': data['decibel'],
            })
        .toList();
  }

  // Average decibel calculation
  List<Map<String, dynamic>> _calculateAverageDecibels(
      List<Map<String, dynamic>> data) {
    final frequencyGroups = <int, List<int>>{};
    for (var item in data) {
      final frequency = item['frequency'];
      final decibel = item['decibel'];
      frequencyGroups.putIfAbsent(frequency, () => []).add(decibel);
    }

    return frequencyGroups.entries
        .map((entry) => {
              'frequency': entry.key.toString(),
              'decibel':
                  entry.value.reduce((a, b) => a + b) / entry.value.length,
            })
        .toList();
  }

  // Age distribution calculation
  List<ChartData> _calculateAgeDistribution(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    final ranges = [
      ChartData('1-10', 0, Colors.blue[100]),
      ChartData('11-20', 0, Colors.blue[200]),
      ChartData('21-30', 0, Colors.blue[300]),
      ChartData('31-40', 0, Colors.blue[400]),
      ChartData('41-50', 0, Colors.blue[500]),
      ChartData('51+', 0, Colors.blue[600]),
    ];

    final totalDocs = snapshot.data!.docs.length;

    for (var doc in snapshot.data!.docs) {
      final age = doc['age'] ?? 0;
      if (age <= 10) {
        ranges[0].y++;
      } else if (age <= 20) {
        ranges[1].y++;
      } else if (age <= 30) {
        ranges[2].y++;
      } else if (age <= 40) {
        ranges[3].y++;
      } else if (age <= 50) {
        ranges[4].y++;
      } else {
        ranges[5].y++;
      }
    }

    for (var range in ranges) {
      range.y = (range.y / totalDocs) * 100;
    }

    return ranges;
  }

  // Hearing status calculation
  List<HearingStatus> _calculateHearingStatus(List<Map<String, dynamic>> data) {
    int normal = 0, abnormal = 0;
    for (var item in data) {
      (item['decibel'] <= 50 ? normal++ : abnormal++);
    }
    return [
      HearingStatus('Normal', normal),
      HearingStatus('Abnormal', abnormal),
    ];
  }

  // Charts
  Widget _buildDecibelChart(List<Map<String, dynamic>> data) {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        title: AxisTitle(
          text: 'Frequency (Hz)',
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      primaryYAxis: const NumericAxis(
        title: AxisTitle(
          text: 'Average Decibels (dB)',
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
      series: <LineSeries<Map<String, dynamic>, String>>[
        LineSeries<Map<String, dynamic>, String>(
          dataSource: data,
          xValueMapper: (datum, _) => datum['frequency'],
          yValueMapper: (datum, _) => datum['decibel'],
          color: Colors.blue,
          markerSettings: const MarkerSettings(isVisible: true),
        )
      ],
    );
  }

  Widget _buildPieChart(List<ChartData> data) {
    return SfCircularChart(
      centerX: '50%',
      centerY: '50%',
      series: <CircularSeries>[
        PieSeries<ChartData, String>(
          dataSource: data,
          pointColorMapper: (ChartData data, _) => data.color,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.inside,
            textStyle: TextStyle(
              fontSize: 14, // Larger font size
              fontWeight: FontWeight.bold, // Bold text
              color: kTextColor, // White for better contrast
            ),
          ),
          dataLabelMapper: (ChartData data, _) =>
              '${data.x}\n${data.y.toStringAsFixed(1)}%', // Show percentage inside
        )
      ],
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.bottom,
        textStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHearingStatusChart(List<HearingStatus> data) {
    return SfCircularChart(series: <PieSeries<HearingStatus, String>>[
      PieSeries<HearingStatus, String>(
        dataSource: data,
        xValueMapper: (datum, _) => datum.status,
        yValueMapper: (datum, _) => datum.count,
        pointColorMapper: (datum, _) =>
            datum.status == 'Normal' ? Colors.blue[300] : Colors.blue[700],
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    ], legend: const Legend(isVisible: true, position: LegendPosition.bottom));
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x;
  double y;
  final Color? color;
}

class HearingStatus {
  HearingStatus(this.status, this.count);
  final String status;
  final int count;
}
