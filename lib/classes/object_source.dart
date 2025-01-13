import 'package:json_annotation/json_annotation.dart';

part 'object_source.g.dart';

enum ObjectSourceType {
  original(title: 'Original'),
  officiel(title: 'Officiel'),
  scenario(title: 'Scénario'),
  // communaute(title: 'Communauté'),
  ;

  final String title;

  const ObjectSourceType({ required this.title });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ObjectSource {
  factory ObjectSource({ required ObjectSourceType type, required String name }) {
    ObjectSource ret;

    if(!_instances.containsKey(type)) {
      _instances[type] = <String, ObjectSource>{};
    }

    if(!_instances[type]!.containsKey(name)) {
      ret = ObjectSource._create(type: type, name: name);
      _instances[type]![name] = ret;
    }
    else {
      ret = _instances[type]![name]!;
    }

    return ret;
  }

  static List<ObjectSource> forType(ObjectSourceType type) {
    return _instances[type]?.values.toList() ?? <ObjectSource>[];
  }

  static ObjectSource local = ObjectSource(
      type: ObjectSourceType.original,
      name: "LOCAL_CREATED"
  );

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

  const ObjectSource._create({ required this.type, required this.name });

  static final Map<ObjectSourceType, Map<String, ObjectSource>> _instances =
    <ObjectSourceType, Map<String, ObjectSource>>{};
}