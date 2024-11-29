import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/data_model.dart';

class FirebaseProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, int>> _testDataToFirestore(List<TestData> data) {
    return data
        .map((test) => {"frequency": test.frequency, "decibel": test.decibel})
        .toList();
  }

  List<TestData> _firestoreToTestData(List<dynamic> data) {
    return data
        .map((item) => TestData(item['frequency'], item['decibel']))
        .toList();
  }

  List<TestData> firestoreToTestData(data) => _firestoreToTestData(data);

  Future<void> storePatientData(String patientId, String name, String contact,
      int age, List<TestData> leftEarData, List<TestData> rightEarData) async {
    try {
      await _firestore.collection('patients').doc(patientId).set({
        "name": name,
        "contact": contact,
        "age": age,
        "leftEarData": _testDataToFirestore(leftEarData),
        "rightEarData": _testDataToFirestore(rightEarData),
      });
      notifyListeners();
      print("Patient data stored successfully!");
    } catch (e) {
      print("Error storing patient data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getAllPatientData() async {
    try {
      final querySnapshot = await _firestore.collection('patients').get();
      return querySnapshot.docs
          .map((doc) => {"id": doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      print("Error retrieving patient data: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getPatientData(String patientId) async {
    try {
      final doc = await _firestore.collection('patients').doc(patientId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;

        List<TestData> leftEarData = _firestoreToTestData(data['leftEarData']);
        List<TestData> rightEarData =
            _firestoreToTestData(data['rightEarData']);

        List<Map<String, dynamic>> averageData =
            _calculateAverageDecibels(leftEarData, rightEarData);

        return {
          "name": data['name'],
          "contact": data['contact'],
          "age": data['age'],
          "averageData": averageData,
        };
      }
      print("Patient not found.");
      return null;
    } catch (e) {
      print("Error retrieving patient data: $e");
      return null;
    }
  }

  Future<void> deletePatientData(String patientId) async {
    try {
      await _firestore.collection('patients').doc(patientId).delete();
      notifyListeners();
      print("Patient data deleted successfully!");
    } catch (e) {
      print("Error deleting patient data: $e");
    }
  }

  List<Map<String, dynamic>> _calculateAverageDecibels(
      List<TestData> leftEarData, List<TestData> rightEarData) {
    Map<int, List<int>> frequencyData = {};

    for (var data in leftEarData) {
      if (!frequencyData.containsKey(data.frequency)) {
        frequencyData[data.frequency] = [];
      }
      frequencyData[data.frequency]!.add(data.decibel);
    }

    for (var data in rightEarData) {
      if (!frequencyData.containsKey(data.frequency)) {
        frequencyData[data.frequency] = [];
      }
      frequencyData[data.frequency]!.add(data.decibel);
    }

    List<Map<String, dynamic>> averageData = frequencyData.entries.map((entry) {
      int frequency = entry.key;
      List<int> decibels = entry.value;
      int averageDecibel = decibels.reduce((a, b) => a + b) ~/ decibels.length;
      return {'frequency': frequency, 'averageDecibel': averageDecibel};
    }).toList();

    return averageData;
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('patients').get();
    List<Map<String, dynamic>> data = [];
    for (var doc in snapshot.docs) {
      List<Map<String, dynamic>> leftEarData =
          List<Map<String, dynamic>>.from(doc['leftEarData']);
      List<Map<String, dynamic>> rightEarData =
          List<Map<String, dynamic>>.from(doc['rightEarData']);

      for (var earData in leftEarData) {
        data.add({
          'name': doc['name'],
          'frequency': earData['frequency'],
          'decibel': earData['decibel'],
        });
      }
      for (var earData in rightEarData) {
        data.add({
          'name': doc['name'],
          'frequency': earData['frequency'],
          'decibel': earData['decibel'],
        });
      }
    }
    return data;
  }
}
