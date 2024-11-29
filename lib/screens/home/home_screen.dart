// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/services.dart';
// import 'package:sound_meter/components/chart_widget.dart';
// import 'package:sound_meter/model/data_model.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// //<--------------- counter Variable ---------------------->
// double count = 0.0;
// int index = 0;
// //<------------------------------------------------------->

// // <----------------- Initial frequency ------------------>
// final List<int> frequencies = [125, 500, 1000, 2000, 4000, 6000, 8000];
// //<------------------------------------------------------->

// final AudioPlayer player = AudioPlayer();

// //<----------------- Play  Tone Method -------------------->
// Future<void> playTone(double count) async {
//   player.setVolume(count);

//   try {
//     await player.play(AssetSource('tone${frequencies[index]}.mp3'));
//   } catch (e) {
//     throw Exception(e);
//   }
// }

// //<----------------------------------------------------->

// //<------------------- Play Different Audio Frequency ----------------------->

// class _HomeScreenState extends State<HomeScreen> {
//   //<---------------------------------------------------->
//   _increamentFrequency() {
//     if (count == 1.0) {
//       count = count;
//     } else if (count >= 0.0 && count <= 0.9) {
//       count += 0.1;
//       String formattedCount = count.toStringAsFixed(1);
//       count = double.parse(formattedCount);
//     }

//     playTone(count);
//   }

//   _decreamentFrequency() {
//     if (count == 0.1) {
//       count = 0.0;
//     } else if (count > 0.1 && count <= 1.0) {
//       count -= 0.1;
//       String formattedCount = count.toStringAsFixed(1);
//       count = double.parse(formattedCount);

//       playTone(count);
//     }
//   }

//   //<------------------ Update Data into  Chart  ----------------------->

//   _donebtn() {
//     if (index >= 0 && index < 6) {
//       setState(() {
//         final decibel = count * 100;
//         chartData[index] = TestData(frequencies[index], decibel.toInt());
//         count = 0.0;
//         playTone(count);
//       });
//       index++;
//     } else if (index == 6) {
//       setState(() {
//         final decibel = count * 100;
//         chartData[index] = TestData(frequencies[index], decibel.toInt());
//         count = 0.0;
//         playTone(count);
//       });
//     }
//   }

//   _backward() {
//     if (index <= 6 && index > 0) {
//       setState(() {
//         final decibel = count * 100;
//         chartData[index] = TestData(frequencies[index], decibel.toInt());
//         count = 0.0;
//         playTone(count);
//       });

//       index--;
//     } else if (index == 0) {
//       setState(() {
//         final decibel = count * 100;
//         chartData[index] = TestData(frequencies[index], decibel.toInt());
//         count = 0.0;
//         playTone(count);
//       });
//     }
//   }

//   _forward() {
//     if (index >= 0 && index < 6) {
//       setState(() {
//         final decibel = count * 100;
//         chartData[index] = TestData(frequencies[index], decibel.toInt());
//         count = 0.0;
//         playTone(count);
//       });

//       index++;
//     } else if (index == 6) {
//       setState(() {
//         final decibel = count * 100;
//         chartData[index] = TestData(frequencies[index], decibel.toInt());
//         count = 0.0;
//         playTone(count);
//       });
//     }
//   }

//   _alertBox() {
//     showDialog(
//         context: context,
//         builder: (builder) => AlertDialog(
//               elevation: 0,
//               alignment: const Alignment(1, -1),
//               content: TextButton(
//                 onPressed: () {},
//                 child: const Text('share'),
//               ),
//             ));
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Set orientation to landscape only
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }

//   @override
//   void dispose() {
//     // Reset to default (both portrait and landscape allowed)
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     int test = index + 1;
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color(0xFF89A8B2),
//           elevation: 0,
//           title: Row(
//             children: [
//               const Text(
//                 'Hearing Test',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 80),
//                 child: Text('TEST $test',
//                     style: const TextStyle(fontWeight: FontWeight.bold)),
//               )
//             ],
//           ),
//           actions: [
//             IconButton(onPressed: _alertBox, icon: const Icon(Icons.more_vert))
//           ],
//         ),
//         body: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Row(
//             children: [
//               SizedBox(
//                   height: MediaQuery.of(context).size.height,
//                   width: MediaQuery.of(context).size.width * 0.7,

//                   //<---------  Chart Widget -------------------->

//                   child: const ChartWidget()),
//               //<--------------------------------->
//               SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.3,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     MaterialButton(
//                       color: Colors.blue,
//                       onPressed: _increamentFrequency,
//                       child: const Text('Increase'),
//                     ),
//                     MaterialButton(
//                       color: Colors.blue,
//                       onPressed: _decreamentFrequency,
//                       child: const Text('Decrease'),
//                     ),
//                     MaterialButton(
//                       color: Colors.blue,
//                       onPressed: _donebtn,
//                       child: const Text('Done'),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         ElevatedButton(
//                           onPressed: _backward,
//                           child: const Text('<<'),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         ElevatedButton(
//                           onPressed: _forward,
//                           child: const Text('>>'),
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ));
//   }
// }
