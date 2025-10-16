import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

part 'status.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityStatusValue {
  static final none        = EntityStatusValue(0);
  static final injured     = EntityStatusValue(1 <<  1);
  static final dead        = EntityStatusValue(1 <<  2);
  static final stunned     = EntityStatusValue(1 <<  3);
  static final unconscious = EntityStatusValue(1 <<  4);
  static final moving      = EntityStatusValue(1 << 10);
  static final running     = EntityStatusValue(1 << 11);
  static final sprinting   = EntityStatusValue(1 << 12);
  static final attacking   = EntityStatusValue(1 << 20);

  EntityStatusValue.empty() : bitfield = 0;
  EntityStatusValue(this.bitfield);

  EntityStatusValue operator &(EntityStatusValue other) =>
      EntityStatusValue(other.bitfield & bitfield);
  EntityStatusValue operator |(EntityStatusValue other) =>
      EntityStatusValue(other.bitfield | bitfield);
  EntityStatusValue operator ~() =>
      EntityStatusValue(~bitfield);
  @override
  bool operator ==(Object other) =>
      other is EntityStatusValue && other.bitfield == bitfield;
  @override
  int get hashCode => bitfield;

  int bitfield;

  factory EntityStatusValue.fromJson(Map<String, dynamic> json) =>
      _$EntityStatusValueFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityStatusValueToJson(this);
}

class EntityStatusStreamChange {
  EntityStatusStreamChange({ required this.value });
  EntityStatusValue value;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityStatus {
  EntityStatus({ required EntityStatusValue value }) : _value = value;
  EntityStatus.empty() : _value = EntityStatusValue.none;

  @JsonKey(includeFromJson: false, includeToJson: false)
  StreamController<EntityStatusStreamChange> streamController =
      StreamController<EntityStatusStreamChange>.broadcast();

  @JsonKey(defaultValue: EntityStatusValue.empty)
  EntityStatusValue get value => _value;
  set value(EntityStatusValue v) {
    _value = v;
    streamController.add(EntityStatusStreamChange(value: v));
  }

  EntityStatusValue _value;

  factory EntityStatus.fromJson(Map<String, dynamic> json) =>
      _$EntityStatusFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityStatusToJson(this);
}