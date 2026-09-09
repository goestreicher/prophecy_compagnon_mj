import 'package:json_annotation/json_annotation.dart';

part 'object_location.g.dart';

enum ObjectLocationType {
  assets(canWrite: false),
  memory(canWrite: true),
  store(canWrite: true);

  final bool canWrite;

  const ObjectLocationType({ required this.canWrite });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ObjectLocation {
  const ObjectLocation({
    required this.type,
    required this.collectionUri,
  });

  final ObjectLocationType type;
  final String collectionUri;

  static const ObjectLocation memory = ObjectLocation(
    type: ObjectLocationType.memory,
    collectionUri: 'memory://',
  );

  factory ObjectLocation.fromJson(Map<String, dynamic> j) => _$ObjectLocationFromJson(j);
  Map<String, dynamic> toJson() => _$ObjectLocationToJson(this);
}