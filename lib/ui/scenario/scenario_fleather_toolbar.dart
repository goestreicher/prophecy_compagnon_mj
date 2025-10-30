import '../../classes/creature.dart';
import '../../classes/non_player_character.dart';
import '../../classes/place.dart';
import '../../classes/resource_link/resource_link.dart';
import '../../classes/scenario.dart';

Future<List<ResourceLink>> generateScenarioResourceLinks(ResourceLinkType type, Scenario scenario) async {
  var ret = <ResourceLink>[];

  switch(type) {
    case ResourceLinkType.npc:
      for(var n in await NonPlayerCharacterSummary.forSource(scenario.source, null, null)) {
        ret.add(ResourceLink.createLinkForResource(type, true, n.name, n.id));
      }
    case ResourceLinkType.creature:
      for(var c in await CreatureSummary.forSource(scenario.source, null)) {
        ret.add(ResourceLink.createLinkForResource(type, true, c.name, c.id));
      }
    case ResourceLinkType.place:
      for(var p in await PlaceSummary.forSource(scenario.source)) {
        ret.add(ResourceLink.createLinkForResource(type, true, p.name, p.id));
      }
    case ResourceLinkType.encounter:
      for(var e in scenario.encounters) {
        ret.add(ResourceLink.createLinkForResource(type, true, e.name, e.name));
      }
    case ResourceLinkType.map:
      for(var m in scenario.maps) {
        ret.add(ResourceLink.createLinkForResource(type, true, m.name, m.uuid));
      }
  }

  return ret;
}