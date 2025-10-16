import 'package:json_annotation/json_annotation.dart';

import 'entity_base.dart';

mixin MagicUser on EntityBase {
  @JsonKey(includeFromJson: false, includeToJson: false)
  int get magicPool => super.abilities.volonte + super.magic.pool;
  set magicPool(int value) {
    super.magic.pool = (value < super.abilities.volonte) ? 0 : value - super.abilities.volonte;
  }
}