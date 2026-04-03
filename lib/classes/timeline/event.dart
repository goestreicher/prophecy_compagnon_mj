import 'package:json_annotation/json_annotation.dart';

import '../calendar.dart';
import '../custom_properties.dart';
import '../object_source.dart';

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