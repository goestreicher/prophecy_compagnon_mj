import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'object_location.dart';
import 'player_character.dart';
import 'star.dart';
import 'storage/storable.dart';

part 'table.g.dart';

Future<void> importGameTable(Map<String, dynamic> json) async {
  for(var pcJson in json['players']) {
    var asMap = pcJson as Map<String, dynamic>;
    if(!asMap.containsKey('uuid')) continue;

    var pc = await PlayerCharacterSummaryStore().get(asMap['uuid']);
    if(pc != null) {
      throw(ArgumentError("Un PJ avec l'UUID ${asMap['uuid']} existe déjà"));
    }
  }

  // Just replace the UUID if it exists. If not, the Table constructor will add it
  if(json.containsKey('uuid')) {
    json['uuid'] = const Uuid().v4().toString();
  }

  // Re-create all characters
  var summaries = <Map<String, dynamic>>[];
  for(var pcJson in json['players']) {
    PlayerCharacter.preImportFilter(pcJson);
    pcJson['location'] = ObjectLocation.memory.toJson();
    var pc = PlayerCharacter.fromJson(pcJson);
    await PlayerCharacterStore().save(pc);
    summaries.add(pc.summary.toJson());
  }
  json['players'] = summaries;

  var table = GameTable.fromJson(json);
  await GameTableStore().save(table);
}

class GameTableSummaryStore extends JsonStoreAdapter<GameTableSummary> {
  GameTableSummaryStore();

  @override
  String storeCategory() => 'gameTableSummaries';

  @override
  String key(GameTableSummary object) => object.uuid;

  @override
  Future<GameTableSummary> fromJsonRepresentation(Map<String, dynamic> j) async => GameTableSummary.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(GameTableSummary object) async => object.toJson();
}

class GameTableStore extends JsonStoreAdapter<GameTable> {
  GameTableStore();

  @override
  String storeCategory() => 'gameTables';

  @override
  String key(GameTable object) => object.uuid;

  @override
  Future<GameTable> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(j.containsKey('star') && j['star'] != null && (j['star'] as String).isNotEmpty) {
      var star = await PlayersStarStore().get(j['star']);
      if(star != null) {
        j['star'] = star.toJson();
      }
    }

    return GameTable.fromJson(j);
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(GameTable object) async {
    var json = object.toJson();

    if(object.star != null) {
      json['star'] = object.star!.id;
    }

    return json;
  }

  @override
  Future<void> willSave(GameTable object) async {
    var summary = object.summary();

    // Player summaries can be out of sync, refresh them
    object.playerSummaries.clear();
    for(var uuid in summary.playersUuids) {
      var character = await PlayerCharacterStore().get(uuid);
      if(character != null) {
        object.playerSummaries.add(character.summary);
      }
    }

    if(object.star != null) {
      await PlayersStarStore().save(object.star!);
    }

    await GameTableSummaryStore().save(summary);
  }

  @override
  Future<void> willDelete(GameTable object) async {
    var summary = object.summary();

    for(var uuid in summary.playersUuids) {
      var character = await PlayerCharacterStore().get(uuid);
      if(character != null) {
        PlayerCharacterStore().delete(character);
      }
    }

    if(object.star != null) {
      await PlayersStarStore().delete(object.star!);
    }

    await GameTableSummaryStore().delete(summary);
  }

  Future<GameTable?> getWithPlayers(String key) async {
    var table = await get(key);
    if(table == null) {
      return null;
    }
    await table.loadPlayers();
    return table;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GameTableSummary {
  GameTableSummary({ required this.uuid, required this.name });

  final String uuid;
  final String name;
  @JsonKey(includeToJson: true, includeFromJson: true)
  final List<String> playersUuids = <String>[];

  Map<String, dynamic> toJson() => _$GameTableSummaryToJson(this);

  factory GameTableSummary.fromJson(Map<String, dynamic> json) {
    var ret = _$GameTableSummaryFromJson(json);
    for(var p in json["players_uuids"]) {
      ret.playersUuids.add(p);
    }
    return ret;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class GameTable {
  GameTable(
      {
        String? uuid,
        required this.name,
        List<PlayerCharacterSummary>? playerSummaries,
        this.star,
      })
    : uuid = uuid ?? const Uuid().v4().toString(),
      playerSummaries = playerSummaries ?? <PlayerCharacterSummary>[];

  GameTable.create({ required this.name })
    : uuid = const Uuid().v4().toString(),
      playerSummaries = <PlayerCharacterSummary>[];

  GameTableSummary summary() {
    var ret = GameTableSummary(uuid: uuid, name: name);
    for(var pc in playerSummaries) {
      ret.playersUuids.add(pc.id);
    }
    return ret;
  }

  final String uuid;
  final String name;
  @JsonKey(name: 'players', includeToJson: true, includeFromJson: true)
  final List<PlayerCharacterSummary> playerSummaries;
  @JsonKey(includeToJson: false, includeFromJson: false)
  final List<PlayerCharacter> players = <PlayerCharacter>[];
  PlayersStar? star;

  Future<void> loadPlayers() async {
    for(var pcSummary in playerSummaries) {
      var index = players.indexWhere((PlayerCharacter p) => p.id == pcSummary.id);
      if(index == -1) {
        var pcFull = await PlayerCharacterStore().get(pcSummary.id);
        if (pcFull != null) {
          players.add(pcFull);
        }
      }
    }
  }

  Map<String, dynamic> toJson() => _$GameTableToJson(this);
  factory GameTable.fromJson(Map<String, dynamic> json) => _$GameTableFromJson(json);

  Future<Map<String, dynamic>> toJsonFull() async {
    await loadPlayers();
    Map<String, dynamic> json = toJson();
    List<Map<String, dynamic>> playersFull = <Map<String, dynamic>>[];
    for(var pc in players) {
      playersFull.add(pc.toJson());
    }
    json['players'] = playersFull;
    return json;
  }
}