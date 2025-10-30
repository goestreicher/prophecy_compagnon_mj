import '../creature.dart';
import '../non_player_character.dart';
import '../object_source.dart';
import '../place.dart';
import 'resource_link.dart';

class ScenarioResourceLinkProvider extends ResourceLinkProvider {
  const ScenarioResourceLinkProvider({ required this.source });

  final ObjectSource source;

  @override
  List<String> sourceNames() => ['Scénario: ${source.name}'];

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
        (await CreatureSummary.forSource(source, null))
        .map((CreatureSummary summ) =>
          ResourceLink.createLinkForResource(type, false, summ.name, summ.id))
      );
    }
    else if(type == ResourceLinkType.npc) {
      ret.addAll(
        (await NonPlayerCharacterSummary.forSource(source, null, null))
        .map((NonPlayerCharacterSummary summ) =>
          ResourceLink.createLinkForResource(type, false, summ.name, summ.id))
      );
    }
    else if(type == ResourceLinkType.place) {
      ret.addAll(
        (await PlaceSummary.forSource(source))
        .map((PlaceSummary summ) =>
          ResourceLink.createLinkForResource(type, false, summ.name, summ.id))
      );
    }

    return ret;
  }
}