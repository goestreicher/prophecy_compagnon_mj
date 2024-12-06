import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

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
  ScenarioEncounter(
      {
        required this.name,
        List<EncounterEntity>? entities,
      })
    : entities = entities ?? <EncounterEntity>[];

  final String name;
  @JsonKey(includeFromJson: false, includeToJson: false)
    int day = 0;
  final List<EncounterEntity> entities;

  Encounter instantiate(List<PlayerCharacter> characters) {
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
      npcs.addAll(factory(split[1], count));
    }

    return Encounter(name: name, characters: characters, npcs: npcs);
  }

  Map<String, dynamic> toJson() => _$ScenarioEncounterToJson(this);
  factory ScenarioEncounter.fromJson(Map<String, dynamic> json) => _$ScenarioEncounterFromJson(json);
}