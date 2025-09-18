import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import '../caste/privileges.dart';

part 'base.g.dart';

enum Ability {
  force(title: "Force"),
  intelligence(title: "Intelligence"),
  coordination(title: "Coordination"),
  presence(title: "Présence"),
  resistance(title: "Résistance"),
  volonte(title: "Volonté"),
  perception(title: "Perception"),
  empathie(title: "Empathie");

  const Ability({
    required this.title,
  });

  final String title;
}

enum Attribute {
  physique(title: "Physique"),
  mental(title: "Mental"),
  manuel(title: "Manuel"),
  social(title: "Social");

  const Attribute({
    required this.title,
  });

  final String title;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterCastePrivilege {
  CharacterCastePrivilege({ required this.privilege, this.description });

  CastePrivilege privilege;
  String? description;

  factory CharacterCastePrivilege.fromJson(Map<String, dynamic> j) => _$CharacterCastePrivilegeFromJson(j);
  Map<String, dynamic> toJson() => _$CharacterCastePrivilegeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AttributeBasedCalculator {
  AttributeBasedCalculator({
    required this.static,
    required this.multiply,
    required this.add,
    required this.dice,
  });

  double calculate(int ability, { List<int>? throws }) {
    var rnd = 0;
    if(throws == null) {
      for (var i = 0; i < dice; ++i) {
        rnd += (Random().nextInt(10) + 1);
      }
    }
    else {
      rnd += throws.reduce((value, element) => value + element);
    }

    if(static > 0) {
      return (static + rnd).toDouble();
    }
    else {
      return ((ability * multiply) + add + rnd).toDouble();
    }
  }

  final double static;
  final int multiply;
  final int add;
  final int dice;

  Map<String, dynamic> toJson() => _$AttributeBasedCalculatorToJson(this);
  factory AttributeBasedCalculator.fromJson(Map<String, dynamic> json) => _$AttributeBasedCalculatorFromJson(json);
}
