import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'encounter.dart';
import 'encounter_entity_factory.dart';
import 'entity_base.dart';
import 'player_character.dart';

part 'scenario_encounter.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EncounterEntity {
  EncounterEntity({ required this.id, this.min = 1, this.max = 1 });

  final String id;
  int min;
  int max;

  Map<String, dynamic> toJson() => _$EncounterEntityToJson(this);
  factory EncounterEntity.fromJson(Map<String, dynamic> json) => _$EncounterEntityFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class ScenarioEncounter {
  ScenarioEncounter({
    String? uuid,
    required this.name,
    List<EncounterEntity>? entities,
  })
    : uuid = uuid ?? const Uuid().v4().toString(),
      entities = entities ?? <EncounterEntity>[];

  final String uuid;
  final String name;
  final List<EncounterEntity> entities;

  Future<Encounter> instantiate(List<PlayerCharacter> characters) async {
    var npcs = <EntityBase>[];

    for(var entity in entities) {
      var count = entity.min;
      if(entity.max > count) {
        count = Random().nextInt(entity.max - entity.min + 1) + entity.min;
      }

      var split = entity.id.split(':');
      if(split.length < 2) continue;
      if(!EncounterEntityFactory.instance.hasFactory(split[0])) continue;

      var factory = EncounterEntityFactory.instance.getInstanceFactory(split[0])!;
      npcs.addAll(await factory(split[1], count));
    }

    return Encounter(name: name, characters: characters, npcs: npcs);
  }

  Map<String, dynamic> toJson() => _$ScenarioEncounterToJson(this);
  factory ScenarioEncounter.fromJson(Map<String, dynamic> json) => _$ScenarioEncounterFromJson(json);
}