import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'caste/character_caste.dart';
import 'character/advantages.dart';
import 'character/base.dart';
import 'character/disadvantages.dart';
import 'entity/injury.dart';
import 'character/tendencies.dart';
import 'draconic_favor.dart';
import 'draconic_link.dart';
import 'entity/abilities.dart';
import 'entity/attributes.dart';
import 'entity/magic.dart';
import 'entity/skill.dart';
import 'entity/skills.dart';
import 'entity/specialized_skill.dart';
import 'entity/status.dart';
import 'entity_base.dart';
import 'combat.dart';
import 'equipment.dart';
import 'exportable_binary_data.dart';
import 'magic_user.dart';
import 'object_location.dart';
import 'object_source.dart';
import 'place.dart';
import 'weapon.dart';

part 'human_character.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterDisadvantage {
  CharacterDisadvantage({
    required this.disadvantage,
    required this.cost,
    required this.details,
  });

  final Disadvantage disadvantage;
  final int cost;
  final String details;

  factory CharacterDisadvantage.fromJson(Map<String, dynamic> json) => _$CharacterDisadvantageFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterDisadvantageToJson(this);
}

class CharacterDisadvantages with IterableMixin<CharacterDisadvantage>, ChangeNotifier {
  CharacterDisadvantages(List<CharacterDisadvantage>? d)
    : _all = d ?? <CharacterDisadvantage>[];

  @override
  Iterator<CharacterDisadvantage> get iterator => _all.iterator;

  void add(CharacterDisadvantage d) {
    _all.add(d);
    notifyListeners();
  }

  void remove(CharacterDisadvantage d) {
    if(_all.remove(d)) notifyListeners();
  }

  static CharacterDisadvantages fromJson(List<dynamic>? json) =>
      CharacterDisadvantages(
        json?.map<CharacterDisadvantage>(
          (d) => CharacterDisadvantage.fromJson(d as Map<String, dynamic>)
        ).toList()
      );

  static List<Map<String, dynamic>> toJson(CharacterDisadvantages all) =>
      all.map((CharacterDisadvantage d) => d.toJson()).toList();

  final List<CharacterDisadvantage> _all;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterAdvantage {
  CharacterAdvantage({
    required this.advantage,
    required this.cost,
    required this.details,
  });

  final Advantage advantage;
  final int cost;
  final String details;

  factory CharacterAdvantage.fromJson(Map<String, dynamic> json) => _$CharacterAdvantageFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterAdvantageToJson(this);
}

class CharacterAdvantages with IterableMixin<CharacterAdvantage>, ChangeNotifier {
  CharacterAdvantages(List<CharacterAdvantage>? a)
      : _all = a ?? <CharacterAdvantage>[];

  @override
  Iterator<CharacterAdvantage> get iterator => _all.iterator;

  void add(CharacterAdvantage a) {
    _all.add(a);
    notifyListeners();
  }

  void remove(CharacterAdvantage a) {
    if(_all.remove(a)) notifyListeners();
  }

  static CharacterAdvantages fromJson(List<dynamic>? json) =>
      CharacterAdvantages(
          json?.map<CharacterAdvantage>(
                  (a) => CharacterAdvantage.fromJson(a as Map<String, dynamic>)
          ).toList()
      );

  static List<Map<String, dynamic>> toJson(CharacterAdvantages all) =>
      all.map((CharacterAdvantage a) => a.toJson()).toList();

  final List<CharacterAdvantage> _all;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterOrigin {
  CharacterOrigin({ this.uuid, Place? place }) : _place = place;

  static CharacterOrigin unknown = CharacterOrigin(place: Place.unknown);

  String? uuid;

  @JsonKey(includeToJson: false)
  Future<Place?> get place async {
    if(_place != null) {
      return _place;
    }
    else if(uuid == null || uuid == Place.unknown.uuid) {
      return Place.unknown;
    }
    else {
      return await Place.byId(uuid!);
    }
  }
  Place? _place;

  factory CharacterOrigin.fromJson(Map<String, dynamic> json) =>
      _$CharacterOriginFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CharacterOriginToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class HumanCharacter extends EntityBase with MagicUser {
  HumanCharacter({
    super.uuid,
    required super.name,
    required super.source,
    super.location = ObjectLocation.memory,
    super.abilities,
    super.attributes,
    super.initiative,
    super.injuries,
    super.injuryProvider = humanCharacterDefaultInjuries,
    super.size,
    super.description,
    super.skills,
    super.status,
    super.equipment,
    super.magic,
    super.favors,
    super.image,
    super.icon,
    CharacterCaste? caste,
    this.luck = 0,
    this.proficiency = 0,
    this.renown = 0,
    this.age = 25,
    this.height = 1.7,
    this.weight = 60.0,
    CharacterOrigin? origin,
    CharacterDisadvantages? disadvantages,
    CharacterAdvantages? advantages,
    CharacterTendencies? tendencies,
    DraconicLink? draconicLink,
  })
    : caste = caste ?? CharacterCaste.empty(),
      origin = origin ?? CharacterOrigin.unknown,
      disadvantages = disadvantages ?? CharacterDisadvantages(null),
      advantages = advantages ?? CharacterAdvantages(null),
      tendencies = tendencies ?? CharacterTendencies.empty(),
      draconicLink = draconicLink ?? DraconicLink.empty()
  {
    _initialize();
  }

  CharacterCaste caste;
  int age;
  double height;
  double weight;
  CharacterOrigin origin;
  int luck;
  int proficiency;
  int renown;
  @JsonKey(fromJson: CharacterDisadvantages.fromJson, toJson: CharacterDisadvantages.toJson)
  CharacterDisadvantages disadvantages;
  @JsonKey(fromJson: CharacterAdvantages.fromJson, toJson: CharacterAdvantages.toJson)
  CharacterAdvantages advantages;
  CharacterTendencies tendencies;
  DraconicLink draconicLink;

  static bool _staticInitialized = false;
  static late final Weapon _naturalWeaponFists;
  static late final Weapon _naturalWeaponFeet;

  void _initialize() {
    _initializeStatic();

    addNaturalWeapon(WeaponRange.contact, _naturalWeaponFists);
    addNaturalWeapon(WeaponRange.contact, _naturalWeaponFeet);
  }

  static void _initializeStatic() {
    if(_staticInitialized) return;
    _staticInitialized = true;

    var contactRange = AttributeBasedCalculator(
        static: 0.4,
        multiply: 1,
        add: 0,
        dice: 0);

    var sk = SpecializedSkill.create(
      parent: Skill.corpsACorps,
      name: 'Coup de poing',
    );
    var wm = WeaponModel(
        name: 'Poings',
        id: 'poings',
        skill: sk,
        weight: 0.0,
        bodyPart: EquipableItemBodyPart.hand,
        hands: 0,
        requirements: [],
        initiative: {
          WeaponRange.contact: 2,
          WeaponRange.melee: 0,
        },
        damage: AttributeBasedCalculator(
          static: 0.0,
          multiply: 1,
          add: 0,
          dice: 1
        ),
        rangeEffective: contactRange,
        rangeMax: contactRange);
    _naturalWeaponFists = wm.instantiate();

    sk = SpecializedSkill.create(
      parent: Skill.corpsACorps,
      name: 'Coup de pied'
    );
    wm = WeaponModel(
        name: 'Pieds',
        id: 'pieds',
        skill: sk,
        weight: 0.0,
        bodyPart: EquipableItemBodyPart.feet,
        hands: 0,
        requirements: [],
        initiative: {
          WeaponRange.contact: 2,
          WeaponRange.melee: 0,
        },
        damage: AttributeBasedCalculator(
            static: 0.0,
            multiply: 1,
            add: 2,
            dice: 1
        ),
        rangeEffective: contactRange,
        rangeMax: contactRange);
    _naturalWeaponFeet = wm.instantiate();
  }

  @override
  Map<String, dynamic> toJson() {
    var j = _$HumanCharacterToJson(this);
    saveNonExportableJson(j);
    return j;
  }

  factory HumanCharacter.fromJson(Map<String, dynamic> json) {
    HumanCharacter c = _$HumanCharacterFromJson(json);
    c.loadNonRestorableJson(json);
    return c;
  }
}

InjuryManager humanCharacterDefaultInjuries(EntityBase? entity, InjuryManager? source) {
  if(source == null) {
    return InjuryManager.simple(
      injuredCeiling: 40,
      injuredCount: 3,
      deathCount: 1,
      source: source
    );
  }
  else {
    return InjuryManager(
      levels: source.levels(),
      source: source,
    );
  }
}

InjuryManager fullCharacterDefaultInjuries(EntityBase? entity, InjuryManager? source) {
  if(entity == null) return humanCharacterDefaultInjuries(entity, source);

  return InjuryManager.getInjuryManagerForAbilities(
    resistance: entity.abilities.resistance,
    volonte: entity.abilities.volonte,
    source: source,
  );
}
