import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

import '../model/data_model.dart';

class RealTimeMonitoringProvider extends ChangeNotifier {
  // Audio Player
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  // Frequencies and Initial Data
  final List<int> frequencies = [125, 500, 1000, 2000, 4000, 8000];
  List<TestData> leftEarData = [
    TestData(125, 0),
    TestData(500, 0),
    TestData(1000, 0),
    TestData(2000, 0),
    TestData(4000, 0),
    TestData(8000, 0),
  ];

  List<TestData> rightEarData = [
    TestData(125, 0),
    TestData(500, 0),
    TestData(1000, 0),
    TestData(2000, 0),
    TestData(4000, 0),
    TestData(8000, 0),
  ];
  // State Variables
  bool leftEarSelected = false;
  bool rightEarSelected = false;
  bool isVisible = false;
  int leftIndex = 0;
  int rightIndex = 0;

  // Constructor
  RealTimeMonitoringProvider() {
    _player.openPlayer();
  }

  @override
  void dispose() {
    _player.closePlayer();
    super.dispose();
  }

  // Select Left or Right Ear
  void selectEar(bool isLeft, bool isRight) {
    leftEarSelected = isLeft;
    rightEarSelected = isRight;
    notifyListeners();
  }

  // Toggle Ear Selection Visibility
  void toggleVisibility() {
    if (isVisible) {
      leftEarSelected = false;
      rightEarSelected = false;
      stopTone();
    } else {
      leftEarSelected = true;
      rightEarSelected = true;
    }
    isVisible = !isVisible;
    notifyListeners();
  }

  // Generate Sine Wave Data
  Uint8List generateSineWave(double frequency, double volume, int durationMs) {
    const sampleRate = 44100;
    int sampleCount = (durationMs / 1000 * sampleRate).toInt();
    double amplitude = pow(10, (volume - 100) / 20) * 32767;
    return Int16List.fromList(List.generate(sampleCount, (i) {
      return (amplitude * sin(2 * pi * frequency * i / sampleRate)).toInt();
    })).buffer.asUint8List();
  }

  // Play Tone
  Future<void> playTone() async {
    try {
      double volume = getCurrentDecibel() / 100.0;
      double frequency = frequencies[getCurrentIndex()].toDouble();
      Uint8List waveData = generateSineWave(frequency, volume * 100, 10000);
      await _player.startPlayer(
        fromDataBuffer: waveData,
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 44100,
      );
    } catch (e) {
      debugPrint("Error playing tone: $e");
    }
    notifyListeners();
  }

  // Stop Tone
  Future<void> stopTone() async {
    await _player.stopPlayer();
  }

  // Get Current Index and Decibel
  int getCurrentIndex() => leftEarSelected ? leftIndex : rightIndex;
  int getCurrentDecibel() => leftEarSelected
      ? leftEarData[leftIndex].decibel
      : rightEarData[rightIndex].decibel;

  // Increment and Decrement Decibels
  void incrementDecibel() {
    if (getCurrentDecibel() < 100) {
      if (leftEarSelected) leftEarData[leftIndex].decibel += 10;
      if (rightEarSelected) rightEarData[rightIndex].decibel += 10;
      playTone();
      notifyListeners();
    }
  }

  void decrementDecibel() {
    if (getCurrentDecibel() > 0) {
      if (leftEarSelected) leftEarData[leftIndex].decibel -= 10;
      if (rightEarSelected) rightEarData[rightIndex].decibel -= 10;
      playTone();
      notifyListeners();
    }
  }

  // Navigation Functions
  void navigateBackward() {
    if (leftEarSelected && leftIndex > 0) leftIndex--;
    if (rightEarSelected && rightIndex > 0) rightIndex--;
    playTone();
    notifyListeners();
  }

  void navigateForward() {
    if (leftEarSelected && leftIndex < frequencies.length - 1) leftIndex++;
    if (rightEarSelected && rightIndex < frequencies.length - 1) rightIndex++;
    playTone();
    notifyListeners();
  }

  // Reset Test Data
  void resetTestData() {
    for (var data in leftEarData) {
      data.decibel = 0;
    }
    for (var data in rightEarData) {
      data.decibel = 0;
    }
    leftIndex = 0;
    rightIndex = 0;
    notifyListeners();
  }
}
