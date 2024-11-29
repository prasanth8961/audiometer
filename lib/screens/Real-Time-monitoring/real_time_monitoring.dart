import 'package:audiometer/provider/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:audiometer/constant/color.dart';
import 'package:audiometer/model/data_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../provider/realtime_monitoring_provider.dart';

class RealTimeMonitoringScreen extends StatefulWidget {
  const RealTimeMonitoringScreen({super.key});

  @override
  State<RealTimeMonitoringScreen> createState() =>
      _RealTimeMonitoringScreenState();
}

List<int> xAxisLabel = [125, 250, 500, 1000, 2000, 4000, 8000];

class _RealTimeMonitoringScreenState extends State<RealTimeMonitoringScreen> {
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
    return Consumer<RealTimeMonitoringProvider>(
      builder: (context, provider, child) {
        final leftEarData = provider.leftEarData
            .map((e) => TestData(e.frequency, e.decibel))
            .toList();
        final rightEarData = provider.rightEarData
            .map((e) => TestData(e.frequency, e.decibel))
            .toList();

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              "Audiogram [${provider.leftEarSelected == true ? "${provider.leftEarData[provider.leftIndex].frequency}Hz - ${provider.leftEarData[provider.leftIndex].decibel}dB" : "${provider.rightEarData[provider.rightIndex].frequency}Hz - ${provider.rightEarData[provider.rightIndex].decibel}dB"}]",
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: kPrimaryColor),
            ),
            actions: [
              TextButton.icon(
                onPressed: provider.resetTestData,
                icon: const Icon(
                  Icons.replay_outlined,
                ),
                label: const Text(
                  "Reset",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: kPrimaryColor,
                ),
              ),
              IconButton(
                  icon: const Icon(
                    Icons.save,
                    color: kPrimaryColor,
                  ),
                  onPressed: () {
                    try {
                      final fireStoreProvider =
                          Provider.of<FirebaseProvider>(context, listen: false);
                      SaveDataDialog.showSaveDialog(
                        context,
                        fireStoreProvider,
                        provider.leftEarData,
                        provider.rightEarData,
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  }),
            ],
          ),
          body: Row(
            children: [
              Expanded(
                flex: 7,
                child: SfCartesianChart(
                  // primaryXAxis: const NumericAxis(
                  //   title: AxisTitle(
                  //     text: 'Frequency (Hz)',
                  //     textStyle: TextStyle(
                  //       fontWeight: FontWeight.w800,
                  //       color: kTextColor,
                  //     ),
                  //   ),
                  //   minimum: 125,
                  //   maximum: 8000,
                  //   majorGridLines: MajorGridLines(width: 1),
                  //   edgeLabelPlacement: EdgeLabelPlacement.shift,
                  //   labelFormat: '{value}',
                  //   labelStyle: TextStyle(color: kTextColor),
                  // ),
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: NumericAxis(
                    title: const AxisTitle(
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
                    majorGridLines: const MajorGridLines(width: 1.5),
                    labelFormat: '{value}',
                    axisLine: AxisLine(
                        width: 0.8, color: Colors.grey.withOpacity(0.7)),
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
                    if (leftEarData.isNotEmpty == true &&
                        provider.leftEarSelected)
                      LineSeries<TestData, int>(
                        animationDuration: 500,
                        color: Colors.red,
                        dataSource: leftEarData,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                          shape: DataMarkerType.circle,
                        ),
                        xValueMapper: (data, _) => data.frequency,
                        yValueMapper: (data, _) => data.decibel,
                      ),
                    if (rightEarData.isNotEmpty == true &&
                        provider.rightEarSelected)
                      LineSeries<TestData, int>(
                        animationDuration: 500,
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
                ),
              ),
              Expanded(
                flex: 3,
                child: buildControlPanel(provider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildControlPanel(RealTimeMonitoringProvider provider) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: provider.leftEarSelected
                      ? kPrimaryColor
                      : kTransperentColor,
                  elevation: 4,
                ),
                onPressed: () {
                  provider.selectEar(true, false);
                  provider.playTone();
                },
                icon: Icon(
                  Icons.hearing,
                  size: 14,
                  color:
                      provider.leftEarSelected ? Colors.white : kPrimaryColor,
                ),
                label: Text("Left Ear",
                    style: TextStyle(
                        color: provider.leftEarSelected
                            ? Colors.white
                            : kPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  backgroundColor: provider.rightEarSelected
                      ? kPrimaryColor
                      : kTransperentColor,
                  elevation: 4,
                ),
                onPressed: () {
                  provider.selectEar(false, true);
                  provider.playTone();
                },
                icon: Icon(
                  Icons.hearing_disabled,
                  size: 14,
                  color:
                      provider.rightEarSelected ? Colors.white : kPrimaryColor,
                ),
                label: Text("Right Ear",
                    style: TextStyle(
                        color: provider.rightEarSelected
                            ? Colors.white
                            : kPrimaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          buildStyledButton(
            label: "Increase",
            icon: Icons.add,
            onPressed: provider.incrementDecibel,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildStyledButton(
                label: "Back",
                icon: Icons.arrow_back,
                onPressed: provider.navigateBackward,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  backgroundColor: kPrimaryColor,
                  elevation: 4,
                ),
                onPressed: provider.toggleVisibility,
                label: Text(
                  (provider.isVisible == true) ? "Hide" : "View",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              buildStyledButton(
                label: "Next",
                icon: Icons.arrow_forward,
                onPressed: provider.navigateForward,
              ),
            ],
          ),
          const SizedBox(height: 15),
          buildStyledButton(
            label: "Decrease",
            icon: Icons.remove,
            onPressed: provider.decrementDecibel,
          ),
        ],
      ),
    );
  }

  Widget buildStyledButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      iconAlignment:
          (label == 'Next' ? IconAlignment.end : IconAlignment.start),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: kTransperentColor,
        elevation: 2,
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 14),
      label: Text(
        label,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class SaveDataDialog {
  static void showSaveDialog(
    BuildContext context,
    FirebaseProvider fireStoreProvider,
    List<TestData> leftEarData,
    List<TestData> rightEarData,
  ) {
    final nameController = TextEditingController();
    final contactController = TextEditingController();
    final ageController = TextEditingController();
    Provider.of<RealTimeMonitoringProvider>(context, listen: false).stopTone();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Center(
                child: Text(
                  'Save Your Data',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              content: Padding(
                padding: EdgeInsets.only(bottom: keyboardHeight),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Name',
                                    hintText: 'Enter your name',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                TextField(
                                  controller: contactController,
                                  decoration: const InputDecoration(
                                    labelText: 'Contact',
                                    hintText: 'Enter your contact number',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              children: [
                                TextField(
                                  controller: ageController,
                                  decoration: const InputDecoration(
                                    labelText: 'Age',
                                    hintText: 'Enter your age',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final username = nameController.text.trim();
                    final contact = contactController.text.trim();
                    final age = ageController.text.trim();

                    if (username.isEmpty || contact.isEmpty || age.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('All fields are required!')),
                      );
                      return;
                    }

                    try {
                      String patientId = DateTime.now()
                          .millisecondsSinceEpoch
                          .toString()
                          .substring(9, 13);

                      await fireStoreProvider.storePatientData(
                          patientId,
                          username,
                          contact,
                          int.parse(age),
                          leftEarData,
                          rightEarData);
                      if (context.mounted) {
                        Provider.of<RealTimeMonitoringProvider>(context,
                                listen: false)
                            .resetTestData();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Data saved successfully!')),
                        );
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error saving data: $e')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
