import 'package:json_annotation/json_annotation.dart';

part 'object_source.g.dart';

enum ObjectSourceType {
  original,
  officiel,
  scenario,
  communaute,
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ObjectSource {
  const ObjectSource({ required this.type, required this.name });

  final ObjectSourceType type;
  final String name;

  @override
  int get hashCode => Object.hash(type, name);

  @override
  bool operator==(Object other) {
    return other is ObjectSource
        && other.type == type
        && other.name == name;
  }

  factory ObjectSource.fromJson(Map<String, dynamic> j) => _$ObjectSourceFromJson(j);
  Map<String, dynamic> toJson() => _$ObjectSourceToJson(this);
}