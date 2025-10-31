import 'package:json_annotation/json_annotation.dart';

part 'resource_link.g.dart';

enum ResourceLinkType {
  creature(title: 'Créature'),
  encounter(title: 'Rencontre'),
  map(title: 'Carte'),
  npc(title: 'PNJ'),
  place(title: 'Lieu'),
  ;

  const ResourceLinkType({ required this.title });

  final String title;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ResourceLink {
  ResourceLink({
    required this.name,
    required this.link,
  }) {
    if(!ResourceLink.isValidLink(link)) {
      throw(FormatException('Invalid link URI $link'));
    }

    var uri = Uri.parse(link);
    type = ResourceLinkType.values.asNameMap()[uri.pathSegments[0]]!;
    id = uri.pathSegments[1];
  }

  String name;
  String link;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late ResourceLinkType type;
  @JsonKey(includeFromJson: false, includeToJson: false)
  late String id;

  static bool isValidLink(String link) {
    var uri = Uri.tryParse(link);
    return uri != null
        && uri.scheme == 'resource'
        && ResourceLinkType.values.asNameMap().containsKey(uri.pathSegments[0]);
  }

  static ResourceLink createLinkForResource(ResourceLinkType type, bool local, String display, String id) {
    return ResourceLink(
      name: display,
      link: 'resource://${local ? "store" : "assets"}/${type.name}/${Uri.encodeComponent(id)}',
    );
  }

  factory ResourceLink.fromJson(Map<String, dynamic> json) =>
      _$ResourceLinkFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ResourceLinkToJson(this);
}

abstract class ResourceLinkProvider {
  const ResourceLinkProvider();

  List<String> sourceNames();
  List<ResourceLinkType> availableTypes();
  Future<List<ResourceLink>> linksForType(ResourceLinkType type, { String? sourceName });
}