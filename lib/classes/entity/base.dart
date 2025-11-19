import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import 'abilities.dart';

part 'base.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AttributeBasedCalculator {
  AttributeBasedCalculator({
    this.static,
    this.ability,
    this.multiply = 1,
    this.add = 0,
    this.dice = 0,
  }) {
    if(static == null && ability == null) {
      throw ArgumentError('Either "static" or "ability" must be set');
    }
  }

  final double? static;
  final Ability? ability;
  final int multiply;
  final int add;
  final int dice;

  double calculate(int abilityValue, { List<int>? throws }) {
    var base = 0.0;
    var rnd = 0;

    if(static != null) {
      base = static!;
    }
    else if(ability != null) {
      base = ((abilityValue * multiply) + add).toDouble();
    }

    if(throws == null) {
      for (var i = 0; i < dice; ++i) {
        rnd += (Random().nextInt(10) + 1);
      }
    }
    else {
      rnd += throws.reduce((value, element) => value + element);
    }

    return (base + rnd).toDouble();
  }

  factory AttributeBasedCalculator.fromJson(Map<String, dynamic> json) =>
      _$AttributeBasedCalculatorFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AttributeBasedCalculatorToJson(this);
}
