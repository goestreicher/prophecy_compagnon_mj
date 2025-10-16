import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'base.dart';
import 'career.dart';
import 'interdicts.dart';
import 'privileges.dart';

part 'character_caste.g.dart';

enum CharacterCasteStreamChangeType {
  caste,
  status,
  career,
}

class CharacterCasteStreamChange {
  const CharacterCasteStreamChange({ required this.type, required this.value });

  final CharacterCasteStreamChangeType type;
  final dynamic value;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterCastePrivilege {
  CharacterCastePrivilege({ required this.privilege, this.description });

  CastePrivilege privilege;
  String? description;

  factory CharacterCastePrivilege.fromJson(Map<String, dynamic> j) =>
      _$CharacterCastePrivilegeFromJson(j);

  Map<String, dynamic> toJson() =>
      _$CharacterCastePrivilegeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterCaste {
  CharacterCaste({
    required Caste caste,
    required CasteStatus status,
    Career? career,
    List<CasteInterdict>? interdicts,
    List<CharacterCastePrivilege>? privileges,
  })
    : casteNotifier = ValueNotifier<Caste>(caste),
      statusNotifier = ValueNotifier<CasteStatus>(status),
      careerNotifier = ValueNotifier<Career?>(career),
      interdicts = CharacterCasteInterdicts(interdicts: interdicts ?? <CasteInterdict>[]),
      privileges = CharacterCastePrivileges(privileges: privileges ?? <CharacterCastePrivilege>[]);
  
  CharacterCaste.empty()
    : casteNotifier = ValueNotifier(Caste.sansCaste),
      statusNotifier = ValueNotifier<CasteStatus>(CasteStatus.none),
      careerNotifier = ValueNotifier<Career?>(null),
      interdicts = CharacterCasteInterdicts(interdicts: <CasteInterdict>[]),
      privileges = CharacterCastePrivileges(privileges: <CharacterCastePrivilege>[]);

  Caste get caste => casteNotifier.value;
  set caste(Caste c) => casteNotifier.value = c;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ValueNotifier<Caste> casteNotifier;

  CasteStatus get status => statusNotifier.value;
  set status(CasteStatus s) => statusNotifier.value = s;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ValueNotifier<CasteStatus> statusNotifier;

  Career? get career => careerNotifier.value;
  set career(Career? c) => careerNotifier.value = c;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ValueNotifier<Career?> careerNotifier;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final CharacterCasteInterdicts interdicts;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final CharacterCastePrivileges privileges;

  @JsonKey(includeFromJson: false, includeToJson: false)
  StreamController<CharacterCasteStreamChange> streamController =
      StreamController<CharacterCasteStreamChange>.broadcast();
  
  factory CharacterCaste.fromJson(Map<String, dynamic> json){
    var c = _$CharacterCasteFromJson(json);
    for(var i in (json['interdicts'] ?? <String>[]) as List<dynamic>) {
      c.interdicts.add(CasteInterdict.values.byName(i as String));
    }
    for(var p in (json['privileges'] ?? <dynamic>[]) as List<dynamic>) {
      c.privileges.add(CharacterCastePrivilege.fromJson(p as Map<String, dynamic>));
    }
    return c;
  }
  
  Map<String, dynamic> toJson() {
    var j = _$CharacterCasteToJson(this);
    j['interdicts'] = interdicts.map((CasteInterdict i) => i.name).toList();
    j['privileges'] = privileges.map((CharacterCastePrivilege p) => p.toJson()).toList();
    return j;
  }
}

class CharacterCasteInterdicts with IterableMixin<CasteInterdict>, ChangeNotifier {
  CharacterCasteInterdicts({ List<CasteInterdict>? interdicts })
    : _all = interdicts ?? <CasteInterdict>[];

  @override
  Iterator<CasteInterdict> get iterator => _all.iterator;

  void add(CasteInterdict i) {
    _all.add(i);
    notifyListeners();
  }

  void remove(CasteInterdict i) {
    if(_all.remove(i)) notifyListeners();
  }

  final List<CasteInterdict> _all;
}

class CharacterCastePrivileges with IterableMixin<CharacterCastePrivilege>, ChangeNotifier {
  CharacterCastePrivileges({ List<CharacterCastePrivilege>? privileges })
    : _all = privileges ?? <CharacterCastePrivilege>[];

  @override
  Iterator<CharacterCastePrivilege> get iterator => _all.iterator;

  void add(CharacterCastePrivilege p) {
    _all.add(p);
    notifyListeners();
  }

  void remove(CharacterCastePrivilege p) {
    if(_all.remove(p)) notifyListeners();
  }

  final List<CharacterCastePrivilege> _all;
}