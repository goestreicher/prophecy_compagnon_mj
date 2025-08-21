import 'package:json_annotation/json_annotation.dart';

import 'object_location.dart';
import 'object_source.dart';

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