import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'base.g.dart';

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
