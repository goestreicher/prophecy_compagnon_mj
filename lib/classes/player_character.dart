import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'calendar.dart';
import 'entity_base.dart';
import 'equipment.dart';
import 'human_character.dart';
import 'magic.dart';
import 'character/base.dart';
import 'character/skill.dart';

part 'player_character.g.dart';

Future<PlayerCharacter> getPlayerCharacter(String uuid) async {
  var pcBox = await Hive.openLazyBox('playerCharactersBox');
  var jsonStr = await pcBox.get(uuid);
  return PlayerCharacter.fromJson(json.decode(jsonStr));
}

Future<void> savePlayerCharacter(PlayerCharacter character) async {
  // Save the PC summary
  var pcSummaryBox = await Hive.openBox('playerCharacterSummariesBox');
  var summary = character.summary();
  await pcSummaryBox.put(summary.uuid, json.encode(summary.toJson()));

  // Save the PC itself
  var pcBox = await Hive.openLazyBox('playerCharactersBox');
  await pcBox.put(character.uuid, json.encode(character.toJson()));
}

Future<void> deletePlayerCharacter(String uuid) async {
  var pcSummaryBox = await Hive.openBox('playerCharacterSummariesBox');
  await pcSummaryBox.delete(uuid);
  var pcBox = await Hive.openLazyBox('playerCharactersBox');
  await pcBox.delete(uuid);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PlayerCharacterSummary {
  PlayerCharacterSummary(
      this.uuid,
      {
        required this.name,
        required this.player,
        required this.caste,
        required this.casteStatus,
      });

  final String uuid;
  final String name;
  final String player;
  final Caste caste;
  final CasteStatus casteStatus;

  Map<String, dynamic> toJson() => _$PlayerCharacterSummaryToJson(this);
  factory PlayerCharacterSummary.fromJson(Map<String, dynamic> json) => _$PlayerCharacterSummaryFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PlayerCharacter extends HumanCharacter {
  PlayerCharacter(
      super.uuid,
      {
        required this.player,
        required this.augure,
        required super.name,
        super.caste,
        super.casteStatus,
        super.initiative,
        super.injuryProvider = fullCharacterDefaultInjuries,
        super.luck,
        super.proficiency,
      });

  PlayerCharacter.create({
      required this.player,
      required this.augure,
      required super.name,
      super.caste,
      super.casteStatus,
      super.initiative,
      super.injuryProvider = fullCharacterDefaultInjuries,
      super.luck,
      super.proficiency,
    }) : super.create();

  factory PlayerCharacter.import(Map<String, dynamic> json) {
    if(json.containsKey('uuid')) {
      // Just replace the existing UUID to prevent any conflicts
      json['uuid'] = const Uuid().v4().toString();
    }
    return PlayerCharacter.fromJson(json);
  }

  String player;
  final Augure augure;

  PlayerCharacterSummary summary() {
    return PlayerCharacterSummary(uuid, name: name, player: player, caste: caste, casteStatus: casteStatus);
  }

  @override
  Map<String, dynamic> toJson() {
    var j = _$PlayerCharacterToJson(this);
    saveNonExportableJson(j);
    return j;
  }

  factory PlayerCharacter.fromJson(Map<String, dynamic> json) {
    PlayerCharacter c = _$PlayerCharacterFromJson(json);
    c.loadNonRestorableJson(json);
    return c;
  }
}