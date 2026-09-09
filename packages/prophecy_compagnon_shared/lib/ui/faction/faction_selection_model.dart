import 'package:flutter/foundation.dart';

class FactionSelectionModel extends ChangeNotifier {
  FactionSelectionModel({ String? id }) : _id = id;

  String? get id => _id;

  set id(String? newId) {
    _id = newId;
    notifyListeners();
  }

  String? _id;
}