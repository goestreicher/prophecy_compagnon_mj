import 'package:json_annotation/json_annotation.dart';

import 'caste/base.dart';
import 'caste/career.dart';
import 'caste/interdicts.dart';
import 'character/advantages.dart';
import 'character/base.dart';
import 'character/disadvantages.dart';
import 'character/injury.dart';
import 'character/skill.dart';
import 'draconic_link.dart';
import 'entity_base.dart';
import 'combat.dart';
import 'equipment.dart';
import 'exportable_binary_data.dart';
import 'magic.dart';
import 'magic_user.dart';
import 'object_location.dart';
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

enum Tendency {
  dragon,
  human,
  fatality,
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TendencyAttribute {
  TendencyAttribute({ required this.value, required this.circles });

  int value;
  int circles;

  factory TendencyAttribute.fromJson(Map<String, dynamic> json) => _$TendencyAttributeFromJson(json);
  Map<String, dynamic> toJson() => _$TendencyAttributeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterTendencies {
  CharacterTendencies.empty()
    : dragon = TendencyAttribute(value: 0, circles: 0),
      human = TendencyAttribute(value: 0, circles: 0),
      fatality = TendencyAttribute(value: 0, circles: 0);

  CharacterTendencies({
    required this.dragon,
    required this.human,
    required this.fatality,
  });

  TendencyAttribute dragon;
  TendencyAttribute human;
  TendencyAttribute fatality;

  factory CharacterTendencies.fromJson(Map<String, dynamic> json) => _$CharacterTendenciesFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterTendenciesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class HumanCharacter extends EntityBase with MagicUser {
  HumanCharacter(
      {
        super.uuid,
        super.location = ObjectLocation.memory,
        required super.name,
        super.initiative,
        super.injuryProvider = humanCharacterDefaultInjuries,
        super.size,
        super.description,
        super.image,
        super.icon,
        this.caste = Caste.sansCaste,
        this.casteStatus = CasteStatus.none,
        this.career,
        this.luck = 0,
        this.proficiency = 0,
        this.renown = 0,
        this.age = 25,
        this.height = 1.7,
        this.weight = 60.0,
        Place? origin,
        List<CasteInterdict>? interdicts,
        List<CharacterCastePrivilege>? castePrivileges,
        List<CharacterDisadvantage>? disadvantages,
        List<CharacterAdvantage>? advantages,
        CharacterTendencies? tendencies,
        this.draconicLink,
      })
    : origin = origin ?? Place.byId('empireDeSolyr')!,
      interdicts = interdicts ?? <CasteInterdict>[],
      castePrivileges = castePrivileges ?? <CharacterCastePrivilege>[],
      disadvantages = disadvantages ?? <CharacterDisadvantage>[],
      advantages = advantages ?? <CharacterAdvantage>[],
      tendencies = tendencies ?? CharacterTendencies.empty()
  {
    _initialize();
  }

  Caste caste;
  CasteStatus casteStatus;
  @JsonKey(defaultValue: null)
    Career? career;
  int age;
  double height;
  double weight;
  Place origin;
  int luck;
  int proficiency;
  int renown;
  @JsonKey(defaultValue: <CasteInterdict>[])
    List<CasteInterdict> interdicts;
  @JsonKey(defaultValue: <CharacterCastePrivilege>[])
    List<CharacterCastePrivilege> castePrivileges;
  List<CharacterDisadvantage> disadvantages;
  List<CharacterAdvantage> advantages;
  CharacterTendencies tendencies;
  DraconicLink? draconicLink;

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
        'corpsACorps:naturalWeaponFists',
        Skill.corpsACorps,
        title: 'Coup de poing');
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
        'corpsACorps:naturalWeaponFeet',
        Skill.corpsACorps,
        title: 'Coup de pied');
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
  void saveNonExportableJson(Map<String, dynamic> json) {
    super.saveNonExportableJson(json);

    json['magic_skills'] = Map<String, int>.fromEntries(
      MagicSkill.values.map(
        (MagicSkill s) => MapEntry<String, int>(s.name, magicSkill(s))
      )
    );

    json['magic_spheres'] = Map<String, int>.fromEntries(
      MagicSphere.values.map(
        (MagicSphere s) => MapEntry<String, int>(s.name, magicSphere(s))
      )
    );

    json['magic_sphere_pools'] = Map<String, int>.fromEntries(
        MagicSphere.values.map(
                (MagicSphere s) => MapEntry<String, int>(s.name, magicSpherePool(s))
        )
    );
  }

  @override
  void loadNonRestorableJson(Map<String, dynamic> json) {
    super.loadNonRestorableJson(json);

    if(json.containsKey('magic_skills') && json['magic_skills']! is Map) {
      for(var s in json['magic_skills']!.keys) {
        setMagicSkill(MagicSkill.values.byName(s), json['magic_skills']![s]!);
      }
    }

    if(json.containsKey('magic_spheres') && json['magic_spheres']! is Map) {
      for(var s in json['magic_spheres']!.keys) {
        setMagicSphere(MagicSphere.values.byName(s), json['magic_spheres']![s]!);
      }
    }

    if(json.containsKey('magic_sphere_pools') && json['magic_sphere_pools']! is Map) {
      for(var s in json['magic_sphere_pools']!.keys) {
        setMagicSpherePool(MagicSphere.values.byName(s), json['magic_sphere_pools']![s]!);
      }
    }
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
    resistance: entity.ability(Ability.resistance),
    volonte: entity.ability(Ability.volonte),
    source: source,
  );
}
