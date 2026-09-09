import 'package:prophecy_compagnon_shared/classes/player_character.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/classes/table.dart';

class PlayerCharactersResourceLinkProvider extends ResourceLinkProvider {
  const PlayerCharactersResourceLinkProvider({
    required this.tableUuid,
    required this.tableName,
  });

  final String tableUuid;
  final String tableName;

  @override
  List<String> sourceNames() => ['Table $tableName'];

  @override
  List<ResourceLinkType> availableTypes() => [
    ResourceLinkType.pc,
  ];

  @override
  Future<List<ResourceLink>> linksForType(ResourceLinkType type, { String? sourceName }) async {
    var ret = <ResourceLink>[];

    if(type == ResourceLinkType.pc) {
      var table = await GameTableStore().get(tableUuid);
      if(table != null) {
        ret.addAll(
          table.playerSummaries
            .map((PlayerCharacterSummary summ) =>
              ResourceLink.createLinkForResource(type, true, summ.name, summ.id)
            )
        );
      }
    }

    return ret;
  }
}