import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'combat_status.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityCombatStatusValue {
  static final none     = EntityCombatStatusValue(0);
  static final onGround = EntityCombatStatusValue(1 << 1);
  static final grappled = EntityCombatStatusValue(1 << 2);

  EntityCombatStatusValue.empty() : bitfield = 0;
  EntityCombatStatusValue(this.bitfield);

  int bitfield;

  EntityCombatStatusValue operator &(EntityCombatStatusValue other) =>
      EntityCombatStatusValue(other.bitfield & bitfield);

  EntityCombatStatusValue operator |(EntityCombatStatusValue other) =>
      EntityCombatStatusValue(other.bitfield | bitfield);

  EntityCombatStatusValue operator ~() =>
      EntityCombatStatusValue(~bitfield);

  @override
  bool operator ==(Object other) =>
      other is EntityCombatStatusValue && other.bitfield == bitfield;

  @override
  int get hashCode => bitfield;

  factory EntityCombatStatusValue.fromJson(Map<String, dynamic> json) =>
      _$EntityCombatStatusValueFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityCombatStatusValueToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityCombatStatus with ChangeNotifier {
  EntityCombatStatus({ required EntityCombatStatusValue value }) : _value = value;
  EntityCombatStatus.empty() : _value = EntityCombatStatusValue.none;

  @JsonKey(defaultValue: EntityCombatStatusValue.empty)
  EntityCombatStatusValue get value => _value;
  set value(EntityCombatStatusValue v) {
    _value = v;
    notifyListeners();
  }

  EntityCombatStatusValue _value;

  bool has(EntityCombatStatusValue status) =>
      value & status != EntityCombatStatusValue.none;

  void add(EntityCombatStatusValue status) =>
      value = _value | status;

  void clear(EntityCombatStatusValue status) =>
      value = _value & ~status;

  factory EntityCombatStatus.fromJson(Map<String, dynamic> json) =>
      _$EntityCombatStatusFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityCombatStatusToJson(this);
}