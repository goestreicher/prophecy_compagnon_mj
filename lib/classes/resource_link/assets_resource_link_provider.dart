import 'package:prophecy_compagnon_mj/classes/non_player_character.dart';
import 'package:prophecy_compagnon_mj/classes/object_location.dart';

import '../creature.dart';
import '../place.dart';
import 'resource_link.dart';

class AssetsResourceLinkProvider extends ResourceLinkProvider {
  const AssetsResourceLinkProvider();

  @override
  List<String> sourceNames() => ['Ressources par défaut'];

  @override
  List<ResourceLinkType> availableTypes() => [
    ResourceLinkType.creature,
    ResourceLinkType.npc,
    ResourceLinkType.place,
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
      ret.addAll(
        (await PlaceSummary.forLocationType(ObjectLocationType.assets))
        .map((PlaceSummary summ) =>
          ResourceLink.createLinkForResource(type, false, summ.name, summ.id))
      );
    }

    return ret;
  }
}