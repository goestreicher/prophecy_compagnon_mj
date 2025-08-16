enum ResourceLinkType {
  npc(title: 'PNJ'),
  creature(title: 'Créature'),
  place(title: 'Lieu'),
  encounter(title: 'Rencontre'),
  map(title: 'Carte'),
  ;

  const ResourceLinkType({ required this.title });

  final String title;
}

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
  }

  String name;
  String link;
  late ResourceLinkType type;

  static bool isValidLink(String link) {
    var uri = Uri.tryParse(link);
    return uri != null
        && uri.scheme == 'resource'
        && ResourceLinkType.values.asNameMap().containsKey(uri.pathSegments[0]);
  }

  static ResourceLink createLinkForResource(ResourceLinkType type, bool store, String display, String id) {
    return ResourceLink(
      name: display,
      link: 'resource://${store ? "store" : "assets"}/${type.name}/${Uri.encodeComponent(id)}',
    );
  }
}