import 'dart:math';
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/offset_json_convert.dart';

part 'movement_path.g.dart';

@OffsetJsonConverter()
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovementPathSegment {
  MovementPathSegment({
    required this.start,
    required this.end,
  });

  MovementPathSegment.from(MovementPathSegment other)
    : start = Offset(other.start.dx, other.start.dy),
      end = Offset(other.end.dx, other.end.dy);

  final Offset start;
  Offset end;

  double get length => sqrt(
      pow(start.dx - end.dx, 2) + pow(start.dy - end.dy, 2)
  );

  factory MovementPathSegment.fromJson(Map<String, dynamic> json) =>
      _$MovementPathSegmentFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MovementPathSegmentToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MovementPath {
  MovementPath({ List<MovementPathSegment>? segments })
      : segments = segments ?? <MovementPathSegment>[];

  MovementPath.from(MovementPath other)
    : segments = <MovementPathSegment>[]
  {
    for(var s in other.segments) {
      segments.add(MovementPathSegment.from(s));
    }
  }

  final List<MovementPathSegment> segments;

  bool get isEmpty => segments.isEmpty;
  bool get isNotEmpty => segments.isNotEmpty;
  MovementPathSegment? get first => segments.isEmpty ? null : segments.first;
  MovementPathSegment? get last => segments.isEmpty ? null : segments.last;

  double get length => segments.isEmpty
      ? 0.0
      : segments
      .map((MovementPathSegment s) => s.length)
      .reduce((double v, double e) => v + e);

  factory MovementPath.fromJson(Map<String, dynamic> json) =>
      _$MovementPathFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MovementPathToJson(this);
}