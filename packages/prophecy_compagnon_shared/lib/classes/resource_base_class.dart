import 'package:json_annotation/json_annotation.dart';
import 'package:prophecy_compagnon_shared/classes/object_location.dart';
import 'package:prophecy_compagnon_shared/classes/object_source.dart';

abstract class ResourceBaseClass {
  ResourceBaseClass({
    required this.name,
    required this.source,
    this.location = ObjectLocation.memory,
  });

  String get id;
  @JsonKey(includeFromJson: true, includeToJson: false)
    ObjectLocation location;
  ObjectSource source;
  String name;
}