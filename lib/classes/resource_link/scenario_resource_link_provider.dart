import '../creature.dart';
import '../non_player_character.dart';
import '../object_source.dart';
import '../place.dart';
import '../scenario.dart';
import '../scenario_encounter.dart';
import '../scenario_map.dart';
import 'resource_link.dart';

class ScenarioResourceLinkProvider extends ResourceLinkProvider {
  const ScenarioResourceLinkProvider({ required this.source });

  final ObjectSource source;

  @override
  List<String> sourceNames() => ['Scénario: ${source.name}'];

  @override
  List<ResourceLinkType> availableTypes() => [
    ResourceLinkType.creature,
    ResourceLinkType.encounter,
    ResourceLinkType.map,
    ResourceLinkType.npc,
    ResourceLinkType.place,
  ];

  @override
  Future<List<ResourceLink>> linksForType(ResourceLinkType type, { String? sourceName }) async {
    var ret = <ResourceLink>[];

    if(type == ResourceLinkType.creature) {
      ret.addAll(
        (await CreatureSummary.forSource(source, null))
        .map((CreatureSummary summ) =>
          ResourceLink.createLinkForResource(type, true, summ.name, summ.id))
      );
    }
    else if(type == ResourceLinkType.encounter) {
      var scenario = await _getScenario();
      if(scenario != null) {
        ret.addAll(
          scenario.encounters
            .map((ScenarioEncounter e) =>
              ResourceLink.createLinkForResource(
                type,
                true,
                e.name,
                '${scenario.uuid}/${e.uuid}'
              )
            )
        );
      }
    }
    else if(type == ResourceLinkType.map) {
      var scenario = await _getScenario();
      if(scenario != null) {
        ret.addAll(
          scenario.maps
            .map((ScenarioMap m) =>
              ResourceLink.createLinkForResource(
                type,
                true,
                m.name,
                m.placeMap.uuid
              )
            )
        );
      }
    }
    else if(type == ResourceLinkType.npc) {
      ret.addAll(
        (await NonPlayerCharacterSummary.forSource(source, null, null))
        .map((NonPlayerCharacterSummary summ) =>
          ResourceLink.createLinkForResource(type, true, summ.name, summ.id))
      );
    }
    else if(type == ResourceLinkType.place) {
      ret.addAll(
        (await PlaceSummary.forSource(source))
        .map((PlaceSummary summ) =>
          ResourceLink.createLinkForResource(type, true, summ.name, summ.id))
      );
    }

    return ret;
  }

  Future<Scenario?> _getScenario() async {
    Scenario? ret;
    var summs = await ScenarioSummaryStore().getAll();
    for(var summ in summs) {
      if(summ.source == source) {
        ret = await ScenarioStore().get(summ.uuid);
        break;
      }
    }
    return ret;
  }
}