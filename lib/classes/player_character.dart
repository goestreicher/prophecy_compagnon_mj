import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'calendar.dart';
import 'entity_base.dart';
import 'equipment.dart';
import 'exportable_binary_data.dart';
import 'human_character.dart';
import 'magic.dart';
import 'object_location.dart';
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
  String key(PlayerCharacterSummary object) => object.id;

  @override
  Future<PlayerCharacterSummary> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(j.containsKey('icon') && j['icon'] is String) await restoreJsonBinaryData(j, 'icon');
    var summary = PlayerCharacterSummary.fromJson(j);
    summary.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
    return summary;
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

    // Force-set the location here in case the object is used after being saved,
    // even if the location is not saved in the store (excluded from the
    // JSON representation).
    object.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
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
  String key(PlayerCharacter object) => object.id;

  @override
  Future<PlayerCharacter> fromJsonRepresentation(Map<String, dynamic> j) async {
    if(j.containsKey('image') && j['image'] is String) await restoreJsonBinaryData(j, 'image');
    if(j.containsKey('icon') && j['icon'] is String) await restoreJsonBinaryData(j, 'icon');
    var pc = PlayerCharacter.fromJson(j);
    pc.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
    return pc;
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

    var summary = await PlayerCharacterSummaryStore().get(object.id);
    if(summary != null) await PlayerCharacterSummaryStore().delete(summary);

    // Force-set the location here in case the object is used after being saved,
    // even if the location is not saved in the store (excluded from the
    // JSON representation).
    object.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );

    await PlayerCharacterSummaryStore().save(object.summary);
  }

  @override
  Future<void> willDelete(PlayerCharacter object) async {
    if(object.icon != null) await BinaryDataStore().delete(object.icon!);
    if(object.image != null) await BinaryDataStore().delete(object.image!);

    var summary = await PlayerCharacterSummaryStore().get(object.id);
    if(summary != null) await PlayerCharacterSummaryStore().delete(summary);
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PlayerCharacterSummary {
  PlayerCharacterSummary({
    required this.id,
    required this.name,
    required this.player,
    required this.caste,
    required this.casteStatus,
    this.icon,
    this.location = ObjectLocation.memory,
  });

  final String id;
  final String name;
  final String player;
  final Caste caste;
  final CasteStatus casteStatus;
  final ExportableBinaryData? icon;
  @JsonKey(includeFromJson: true, includeToJson: false)
    ObjectLocation location;

  Map<String, dynamic> toJson() => _$PlayerCharacterSummaryToJson(this);
  factory PlayerCharacterSummary.fromJson(Map<String, dynamic> json) => _$PlayerCharacterSummaryFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PlayerCharacter extends HumanCharacter {
  PlayerCharacter(
      {
        super.uuid,
        super.location = ObjectLocation.memory,
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
    preImportFilter(json);
    if(json.containsKey('uuid')) {
      // Just replace the existing UUID to prevent any conflicts
      json['uuid'] = const Uuid().v4().toString();
    }
    return PlayerCharacter.fromJson(json);
  }

  String player;
  final Augure augure;

  PlayerCharacterSummary get summary => PlayerCharacterSummary(
    id: id,
    name: name,
    player: player,
    caste: caste,
    casteStatus: casteStatus,
    icon: icon?.clone(),
    location: location,
  );

  static void preImportFilter(Map<String, dynamic> json) {
    EntityBase.preImportFilter(json);
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