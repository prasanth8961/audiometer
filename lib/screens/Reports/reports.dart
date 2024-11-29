import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../constant/color.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: kTextColor,
          ),
        ),
        backgroundColor: kSecondaryColor,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: const Row(
                children: [
                  Icon(Icons.analytics, color: kTextColor, size: 28.0),
                  SizedBox(width: 10),
                  Text(
                    "Audio Analysis Summary",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),

            // Charts Section
            Expanded(
              child: ListView(
                children: [
                  // Frequency Distribution Chart
                  _buildChartCard(
                    title: "Frequency Distribution",
                    chart: SizedBox(
                      height: 150.0,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                const FlSpot(0, 3),
                                const FlSpot(1, 1.5),
                                const FlSpot(2, 4),
                                const FlSpot(3, 2.5),
                                const FlSpot(4, 3.8),
                              ],
                              isCurved: true,
                              color: kPrimaryColor,
                              barWidth: 4,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    kPrimaryColor.withOpacity(0.3),
                                    Colors.transparent
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Volume Intensity Chart
                  _buildChartCard(
                    title: "Volume Intensity",
                    chart: SizedBox(
                      height: 150.0,
                      child: BarChart(
                        BarChartData(
                          barGroups: [
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: 3,
                                  color: kPrimaryColor,
                                  width: 16,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(
                                  toY: 4.5,
                                  color: kSecondaryColor,
                                  width: 16,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 3,
                              barRods: [
                                BarChartRodData(
                                  toY: 2.5,
                                  color: kPrimaryColor,
                                  width: 16,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ],
                            ),
                          ],
                          borderData: FlBorderData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          gridData: const FlGridData(show: false),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Session Insights
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    color: Colors.white,
                    shadowColor: Colors.black.withOpacity(0.1),
                    elevation: 4,
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Session Insights",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: kTextColor,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          ListTile(
                            leading: Icon(Icons.insights, color: kPrimaryColor),
                            title: Text(
                              "Max Volume Reached: 80 dB",
                              style: TextStyle(color: kTextColor),
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.timer, color: kPrimaryColor),
                            title: Text(
                              "Session Duration: 45 mins",
                              style: TextStyle(color: kTextColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget chart}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: Colors.white,
      shadowColor: Colors.black.withOpacity(0.1),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: kTextColor,
              ),
            ),
            const SizedBox(height: 10.0),
            chart,
          ],
        ),
      ),
    );
  }
}
