import 'package:flutter/material.dart';
import 'package:audiometer/components/chart_widget.dart';
import 'package:audiometer/constant/color.dart';
import 'package:flutter/services.dart';
import '../../model/data_model.dart';

class DetailScreen extends StatefulWidget {
  final String title;
  final List<TestData> leftEarData;
  final List<TestData> rightEarData;

  const DetailScreen({
    super.key,
    required this.title,
    required this.leftEarData,
    required this.rightEarData,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Audiogram detail',
          style: TextStyle(color: kTextColor, fontWeight: FontWeight.w600),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kPrimaryColor, kTertiaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ChartWidget(
            leftEarData: widget.leftEarData,
            rightEarData: widget.rightEarData,
          ),
        ),
      ),
    );
  }
}
