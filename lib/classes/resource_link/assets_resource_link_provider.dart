import '../creature.dart';
import '../faction.dart';
import '../non_player_character.dart';
import '../object_location.dart';
import '../place.dart';
import '../star.dart';
import 'resource_link.dart';

class AssetsResourceLinkProvider extends ResourceLinkProvider {
  const AssetsResourceLinkProvider();

  @override
  List<String> sourceNames() => ['Ressources par défaut'];

  @override
  List<ResourceLinkType> availableTypes() => [
    ResourceLinkType.creature,
    ResourceLinkType.faction,
    ResourceLinkType.npc,
    ResourceLinkType.place,
    ResourceLinkType.star,
  ];

  @override
  Future<List<ResourceLink>> linksForType(ResourceLinkType type, { String? sourceName }) async {
    var ret = <ResourceLink>[];

    if(type == ResourceLinkType.creature) {
      ret.addAll(
        (await CreatureSummary.forLocationType(ObjectLocationType.assets, null))
        .map((CreatureSummary summ) =>
          ResourceLink.createLinkForResource(type, false, summ.name, summ.id))
      );
    }
    else if(type == ResourceLinkType.faction) {
      await _createFactionLinkTree(null, ret, '');
    }
    else if(type == ResourceLinkType.npc) {
      ret.addAll(
        (await NonPlayerCharacterSummary.forLocationType(
          ObjectLocationType.assets,
          null,
          null
        ))
        .map((NonPlayerCharacterSummary summ) =>
          ResourceLink.createLinkForResource(type, false, summ.name, summ.id))
      );
    }
    else if(type == ResourceLinkType.place) {
      await _createPlaceLinkTree('monde', ret, '');
    }
    else if(type == ResourceLinkType.star) {
      ret.addAll(
        (await Star.forLocationType(ObjectLocationType.assets))
        .map((Star star) =>
          ResourceLink.createLinkForResource(type, false, star.name, star.id))
      );
    }

    return ret;
  }

  Future<void> _createFactionLinkTree(String? parent, List<ResourceLink> links, String prefix) async {
    for(FactionSummary summ in (await FactionSummary.withParent(parent))) {
      if(summ.location.type != ObjectLocationType.assets) continue;

      String display = '$prefix${summ.name}';
      if(!summ.displayOnly) {
        links.add(
          ResourceLink.createLinkForResource(
            ResourceLinkType.faction,
            false,
            summ.name,
            summ.id,
            label: display
          )
        );
      }
      await _createFactionLinkTree(summ.id, links, '$prefix${summ.name} > ');
    }
  }

  Future<void> _createPlaceLinkTree(String parent, List<ResourceLink> links, String prefix) async {
    for(PlaceSummary summ in (await PlaceSummary.withParent(parent))) {
      if(summ.location.type != ObjectLocationType.assets) continue;

      String display = '$prefix${summ.name}';
      links.add(
        ResourceLink.createLinkForResource(
          ResourceLinkType.place,
          false,
          summ.name,
          summ.id,
          label: display
        )
      );
      await _createPlaceLinkTree(summ.id, links, '$prefix${summ.name} > ');
    }
  }
}