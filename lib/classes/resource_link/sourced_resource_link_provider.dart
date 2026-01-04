import '../creature.dart';
import '../non_player_character.dart';
import '../object_location.dart';
import '../object_source.dart';
import '../place.dart';
import '../star.dart';
import 'resource_link.dart';

class SourcedResourceLinkProvider extends ResourceLinkProvider {
  const SourcedResourceLinkProvider({ required this.source });

  final ObjectSource source;

  @override
  List<String> sourceNames() => ['${source.type.title} > ${source.name}'];

  @override
  List<ResourceLinkType> availableTypes() => [
    ResourceLinkType.creature,
    ResourceLinkType.npc,
    ResourceLinkType.place,
    ResourceLinkType.star,
  ];

  @override
  Future<List<ResourceLink>> linksForType(ResourceLinkType type, { String? sourceName }) async {
    var ret = <ResourceLink>[];

    if(type == ResourceLinkType.creature) {
      ret.addAll(
          (await CreatureSummary.forSource(source, null))
            .map((CreatureSummary summ) =>
              ResourceLink.createLinkForResource(
                type,
                !(summ.location.type == ObjectLocationType.assets),
                summ.name,
                summ.id
              )
            )
      );
    }
    else if(type == ResourceLinkType.npc) {
      ret.addAll(
          (await NonPlayerCharacterSummary.forSource(source, null, null))
            .map((NonPlayerCharacterSummary summ) =>
              ResourceLink.createLinkForResource(
                  type,
                  !(summ.location.type == ObjectLocationType.assets),
                  summ.name,
                  summ.id
              )
            )
      );
    }
    else if(type == ResourceLinkType.place) {
      await _createPlaceLinkTree('monde', ret, '');
    }
    else if(type == ResourceLinkType.star) {
      ret.addAll(
          (await Star.forSource(source))
            .map((Star star) =>
              ResourceLink.createLinkForResource(
                type,
                !(star.location.type == ObjectLocationType.assets),
                star.name,
                star.id
              )
            )
      );
    }

    return ret;
  }

  Future<void> _createPlaceLinkTree(String parent, List<ResourceLink> links, String prefix) async {
    for(PlaceSummary summ in (await PlaceSummary.withParent(parent))) {
      String display = '$prefix${summ.name}';
      var link = ResourceLink.createLinkForResource(
        ResourceLinkType.place,
        !(summ.location.type == ObjectLocationType.assets),
        summ.name,
        summ.id,
        label: display
      );
      if(summ.source != source) {
        link.clickable = false;
      }
      links.add(link);
      await _createPlaceLinkTree(summ.id, links, '$prefix${summ.name} > ');
    }
  }
}