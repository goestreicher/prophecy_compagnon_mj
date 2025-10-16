import 'package:flutter/foundation.dart';

class PlaceSelectionModel extends ChangeNotifier {
  PlaceSelectionModel({ String? id }) : _id = id;

  String? get id => _id;

  set id(String? newId) {
    _id = newId;
    notifyListeners();
  }

  String? _id;
}