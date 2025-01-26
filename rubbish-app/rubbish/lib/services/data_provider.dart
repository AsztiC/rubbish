import 'package:flutter/material.dart';
import 'preferences_service.dart';

class DataProvider with ChangeNotifier {
  final PreferencesService _preferencesService = PreferencesService();
  
  List<bool> _booleans = List.generate(8, (index) => false);
  List<int> _integers = List.generate(8, (index) => 0);

  List<bool> get booleans => _booleans;
  List<int> get integers => _integers;

  Future<void> loadBooleans() async {
    _booleans = await _preferencesService.loadBooleans();
    notifyListeners();
  }

  Future<void> loadIntegers() async {
    _integers = await _preferencesService.loadIntegers();
    notifyListeners();
  }

  Future<void> updateBooleans(List<bool> newBooleans) async {
    _booleans = newBooleans;
    await _preferencesService.saveBooleans(_booleans);
    notifyListeners();
  }

  Future<void> updateIntegers(List<int> newIntegers) async {
    _integers = newIntegers;
    await _preferencesService.saveIntegers(_integers);
    notifyListeners();
  }
}
