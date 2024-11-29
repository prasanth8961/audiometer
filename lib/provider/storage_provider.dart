import 'package:flutter/material.dart';
import '../model/data_model.dart';

class StorageProvider extends ChangeNotifier {
  final Map<String, Map<String, List<TestData>>> _storage = {};
  Map<String, Map<String, List<TestData>>> get storage => _storage;

  void storeData(String key, Map<String, List<TestData>> data) {
    _storage[key] = data;
    notifyListeners();
  }

  bool hasItem(String key) => _storage.containsKey(key);

  void deleteItem(String key) {
    if (hasItem(key)) {
      _storage.remove(key);
      notifyListeners();
    }
  }

  Map<String, List<TestData>>? getData(String key) => _storage[key];
}
