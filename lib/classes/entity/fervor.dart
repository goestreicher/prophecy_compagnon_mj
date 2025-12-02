import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'spirit_powers.dart';

part 'fervor.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityFervor {
  EntityFervor({
    this.value = 0,
    List<SpiritPower>? powers,
  })
    : powers = EntitySpiritPowers(powers: powers);

  int value;
  EntitySpiritPowers powers;

  factory EntityFervor.fromJson(Map<String, dynamic> json) =>
      _$EntityFervorFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityFervorToJson(this);
}

class EntitySpiritPowers with IterableMixin<SpiritPower>, ChangeNotifier {
  EntitySpiritPowers({ List<SpiritPower>? powers })
    : _all = powers ?? <SpiritPower>[];

  @override
  Iterator<SpiritPower> get iterator => _all.iterator;

  void add(SpiritPower s) {
    _all.add(s);
    notifyListeners();
  }

  void remove(SpiritPower s) {
    _all.remove(s);
    notifyListeners();
  }

  final List<SpiritPower> _all;
}