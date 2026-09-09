import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'health_status.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityHealthStatusValue {
  static final none        = EntityHealthStatusValue(0);
  static final injured     = EntityHealthStatusValue(1 << 1);
  static final dead        = EntityHealthStatusValue(1 << 2);
  static final stunned     = EntityHealthStatusValue(1 << 3);
  static final unconscious = EntityHealthStatusValue(1 << 4);

  EntityHealthStatusValue.empty() : bitfield = 0;
  EntityHealthStatusValue(this.bitfield);

  int bitfield;

  EntityHealthStatusValue operator &(EntityHealthStatusValue other) =>
      EntityHealthStatusValue(other.bitfield & bitfield);

  EntityHealthStatusValue operator |(EntityHealthStatusValue other) =>
      EntityHealthStatusValue(other.bitfield | bitfield);

  EntityHealthStatusValue operator ~() =>
      EntityHealthStatusValue(~bitfield);

  @override
  bool operator ==(Object other) =>
      other is EntityHealthStatusValue && other.bitfield == bitfield;

  @override
  int get hashCode => bitfield;

  factory EntityHealthStatusValue.fromJson(Map<String, dynamic> json) =>
      _$EntityHealthStatusValueFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityHealthStatusValueToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityHealthStatus with ChangeNotifier {
  EntityHealthStatus({ required EntityHealthStatusValue value }) : _value = value;
  EntityHealthStatus.empty() : _value = EntityHealthStatusValue.none;

  @JsonKey(defaultValue: EntityHealthStatusValue.empty)
  EntityHealthStatusValue get value => _value;
  set value(EntityHealthStatusValue v) {
    _value = v;
    notifyListeners();
  }

  EntityHealthStatusValue _value;

  bool has(EntityHealthStatusValue status) =>
      value & status != EntityHealthStatusValue.none;

  void add(EntityHealthStatusValue status) =>
      value = _value | status;

  void clear(EntityHealthStatusValue status) =>
      value = _value & ~status;

  factory EntityHealthStatus.fromJson(Map<String, dynamic> json) =>
      _$EntityHealthStatusFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityHealthStatusToJson(this);
}