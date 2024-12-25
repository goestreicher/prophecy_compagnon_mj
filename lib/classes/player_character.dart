import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'calendar.dart';
import 'entity_base.dart';
import 'equipment.dart';
import 'exportable_binary_data.dart';
import 'human_character.dart';
import 'magic.dart';
import 'place.dart';
import 'character/base.dart';
import 'character/skill.dart';
import 'storage/storable.dart';

part 'player_character.g.dart';

class PlayerCharacterSummaryStore extends JsonStoreAdapter<PlayerCharacterSummary> {
  PlayerCharacterSummaryStore();

  @override
  String storeCategory() => 'playerCharacterSummaries';

  @override
  String key(PlayerCharacterSummary object) => object.uuid;

  @override
  Future<PlayerCharacterSummary> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(j.containsKey('icon') && j['icon'] is String) await restoreJsonBinaryData(j, 'icon');
    return PlayerCharacterSummary.fromJson(j);
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(PlayerCharacterSummary object) async {
    var j = object.toJson();
    if(object.icon != null) j['icon'] = object.icon!.hash;
    return j;
  }

  @override
  Future<void> willSave(PlayerCharacterSummary object) async {
    if(object.icon != null) await BinaryDataStore().save(object.icon!);
  }

  @override
  Future<void> willDelete(PlayerCharacterSummary object) async {
    if(object.icon != null) await BinaryDataStore().delete(object.icon!);
  }
}

class PlayerCharacterStore extends JsonStoreAdapter<PlayerCharacter> {
  PlayerCharacterStore();

  @override
  String storeCategory() => 'playerCharacters';

  @override
  String key(PlayerCharacter object) => object.uuid;

  @override
  Future<PlayerCharacter> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(j.containsKey('image') && j['image'] is String) await restoreJsonBinaryData(j, 'image');
    if(j.containsKey('icon') && j['icon'] is String) await restoreJsonBinaryData(j, 'icon');
    return PlayerCharacter.fromJson(j);
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(PlayerCharacter object) async {
    var j = object.toJson();
    if(object.image != null) j['image'] = object.image!.hash;
    if(object.icon != null) j['icon'] = object.icon!.hash;
    return j;
  }

  @override
  Future<void> willSave(PlayerCharacter object) async {
    if(object.image != null) await BinaryDataStore().save(object.image!);
    if(object.icon != null) await BinaryDataStore().save(object.icon!);

    var summary = await PlayerCharacterSummaryStore().get(object.uuid);
    if(summary != null) await PlayerCharacterSummaryStore().delete(summary);

    await PlayerCharacterSummaryStore().save(object.summary);
  }

  @override
  Future<void> willDelete(PlayerCharacter object) async {
    if(object.icon != null) await BinaryDataStore().delete(object.icon!);
    if(object.image != null) await BinaryDataStore().delete(object.image!);

    var summary = await PlayerCharacterSummaryStore().get(object.uuid);
    if(summary != null) await PlayerCharacterSummaryStore().delete(summary);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PlayerCharacterSummary {
  PlayerCharacterSummary(
      this.uuid,
      {
        required this.name,
        required this.player,
        required this.caste,
        required this.casteStatus,
        this.icon,
      });

  final String uuid;
  final String name;
  final String player;
  final Caste caste;
  final CasteStatus casteStatus;
  final ExportableBinaryData? icon;

  Map<String, dynamic> toJson() => _$PlayerCharacterSummaryToJson(this);
  factory PlayerCharacterSummary.fromJson(Map<String, dynamic> json) => _$PlayerCharacterSummaryFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PlayerCharacter extends HumanCharacter {
  PlayerCharacter(
      {
        super.uuid,
        required this.player,
        required this.augure,
        required super.name,
        super.caste,
        super.casteStatus,
        super.initiative,
        super.injuryProvider = fullCharacterDefaultInjuries,
        super.luck,
        super.proficiency,
        super.image,
        super.icon,
      });

  factory PlayerCharacter.import(Map<String, dynamic> json) {
    if(json.containsKey('uuid')) {
      // Just replace the existing UUID to prevent any conflicts
      json['uuid'] = const Uuid().v4().toString();
    }
    return PlayerCharacter.fromJson(json);
  }

  String player;
  final Augure augure;

  PlayerCharacterSummary get summary => PlayerCharacterSummary(
    uuid,
    name: name,
    player: player,
    caste: caste,
    casteStatus: casteStatus,
    icon: icon?.clone(),
  );

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