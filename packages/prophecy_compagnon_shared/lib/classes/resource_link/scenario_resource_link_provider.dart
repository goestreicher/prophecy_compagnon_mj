import 'package:prophecy_compagnon_shared/classes/object_source.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/sourced_resource_link_provider.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario_encounter.dart';
import 'package:prophecy_compagnon_shared/classes/scenario/scenario_map.dart';

class ScenarioResourceLinkProvider extends ResourceLinkProvider {
  ScenarioResourceLinkProvider({ required this.source })
    : _sourcedProvider = SourcedResourceLinkProvider(source: source);

  final ObjectSource source;
  final SourcedResourceLinkProvider _sourcedProvider;

  @override
  List<String> sourceNames() => ['Scénario: ${source.name}'];

  @override
  List<ResourceLinkType> availableTypes() => [
    ResourceLinkType.encounter,
    ResourceLinkType.map,
    ..._sourcedProvider.availableTypes()
  ];

  @override
  Future<List<ResourceLink>> linksForType(ResourceLinkType type, { String? sourceName }) async {
    var ret = <ResourceLink>[];

    if(type == ResourceLinkType.encounter) {
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
    else if(_sourcedProvider.availableTypes().contains(type)) {
      ret.addAll(
        (await _sourcedProvider.linksForType(type, sourceName: sourceName))
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