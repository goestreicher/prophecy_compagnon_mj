import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:prophecy_compagnon_shared/classes/session/board/item.dart';

class SessionGameBoard with IterableMixin<SessionBoardItem>, ChangeNotifier {
  SessionGameBoard();

  @override
  Iterator<SessionBoardItem> get iterator =>
      _board.iterator;

  void push(SessionBoardItem item) =>
      insert(0, item);

  void insert(int index, SessionBoardItem item) {
    _board.insert(index, item);
    _selected = index;
    notifyListeners();
  }

  void removeAt(int index) {
    if(index == _selected) {
      if(_board.length == 1) {
        _selected = null;
      }
      else if(index == _board.length - 1) {
        _selected = index - 1;
      }
    }
    _board.removeAt(index);
    notifyListeners();
  }

  int? get selected => _selected;
  set selected(int? v) {
    _selected = v;
    notifyListeners();
  }
  int? _selected;

  final List<SessionBoardItem> _board = <SessionBoardItem>[];
}