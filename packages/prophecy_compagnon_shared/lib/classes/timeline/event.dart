import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/calendar.dart';
import 'package:prophecy_compagnon_shared/classes/custom_properties.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';

part 'event.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TimelineEvent with CustomProperties {
  TimelineEvent({
    required this.uuid,
    required this.source,
    required this.range,
    required this.title,
    this.content,
  });

  String uuid;
  ObjectSource source;
  KorDateRange range;
  String title;
  String? content;

  static TimelineEvent fromJson(Map<String, dynamic> json) =>
      _$TimelineEventFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TimelineEventToJson(this);
}