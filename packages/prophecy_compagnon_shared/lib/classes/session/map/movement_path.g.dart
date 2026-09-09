// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movement_path.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovementPathSegment _$MovementPathSegmentFromJson(Map<String, dynamic> json) =>
    MovementPathSegment(
      start: const OffsetJsonConverter().fromJson(
        json['start'] as Map<String, dynamic>,
      ),
      end: const OffsetJsonConverter().fromJson(
        json['end'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$MovementPathSegmentToJson(
  MovementPathSegment instance,
) => <String, dynamic>{
  'start': const OffsetJsonConverter().toJson(instance.start),
  'end': const OffsetJsonConverter().toJson(instance.end),
};

MovementPath _$MovementPathFromJson(Map<String, dynamic> json) => MovementPath(
  segments: (json['segments'] as List<dynamic>?)
      ?.map((e) => MovementPathSegment.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MovementPathToJson(MovementPath instance) =>
    <String, dynamic>{
      'segments': instance.segments.map((e) => e.toJson()).toList(),
    };
