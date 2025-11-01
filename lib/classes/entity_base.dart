import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'combat.dart';
import 'entity/injury.dart';
import 'entity/abilities.dart';
import 'entity/attributes.dart';
import 'entity/magic.dart';
import 'entity/skills.dart';
import 'entity/status.dart';
import 'equipment.dart';
import 'exportable_binary_data.dart';
import 'object_location.dart';
import 'object_source.dart';
import 'resource_base_class.dart';
import '../text_utils.dart';

part 'entity_base.g.dart';

typedef InjuryProvider = InjuryManager Function(EntityBase?, InjuryManager?);

abstract interface class ProtectionProvider {
  int protection();
}

abstract interface class DamageProvider {
  int damage(EntityBase owner, { List<int>? throws });
}

abstract interface class InitiativeProvider {
  int initiativeForRange(WeaponRange range);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityBase extends ResourceBaseClass with SupportsEquipableItem {
  EntityBase({
    String? uuid,
    required super.name,
    required super.source,
    super.location = ObjectLocation.memory,
    EntityAbilities? abilities,
    EntityAttributes? attributes,
    this.initiative = 1,
    EntityInjuries? injuries,
    InjuryProvider injuryProvider = entityBaseDefaultInjuries,
    double? size,
    String? description,
    EntitySkills? skills,
    EntityStatus? status,
    EntityEquipment? equipment,
    EntityMagic? magic,
    ExportableBinaryData? image,
    ExportableBinaryData? icon,
  })
    : uuid = uuid ?? (!location.type.canWrite ? null : Uuid().v4().toString()),
      abilities = abilities ?? EntityAbilities.empty(),
      attributes = attributes ?? EntityAttributes.empty(),
      size = size ?? 0.8,
      description = description ?? '',
      skills = skills ?? EntitySkills.empty(),
      status = status ?? EntityStatus.empty(),
      equipment = equipment ?? EntityEquipment(null),
      magic = magic ?? EntityMagic(),
      _image = image,
      _icon = icon
  {
    this.injuries = injuries ?? EntityInjuries(manager: injuryProvider(this, null));
  }

  @override
  String get id => uuid ?? sentenceToCamelCase(transliterateFrenchToAscii(name));
  @JsonKey(includeIfNull: false)
    final String? uuid;
  String description;

  ExportableBinaryData? get image => _image;

  set image(ExportableBinaryData? i) {
    if(_image != null && (i == null || _image!.hash != i.hash)) BinaryDataStore().delete(_image!);
    _image = i;
  }

  ExportableBinaryData? _image;

  ExportableBinaryData? get icon => _icon;

  set icon(ExportableBinaryData? i) {
    if(_icon != null && (i == null || _icon!.hash != i.hash)) BinaryDataStore().delete(_icon!);
    _icon = i;
  }

  ExportableBinaryData? _icon;

  bool canAct() {
    return status.value & EntityStatusValue.dead == EntityStatusValue.none &&
           status.value & EntityStatusValue.unconscious == EntityStatusValue.none;
  }

  EntityAbilities abilities;
  EntityAttributes attributes;

  int initiative;

  late EntityInjuries injuries;

  int takeDamage(int amount, { int armorDivider = 1 }) {
    var finalDamage = amount;
    // TODO: manage shields when used to block an attack (in which case their protection don't apply
    for(var pp in _protectionProviders) {
      int reduction = pp.protection() ~/ armorDivider;
      finalDamage -= reduction;
    }

    if(finalDamage > 0) {
      injuries.manager.dealDamage(finalDamage);
      if(injuries.manager.isDead()) {
        status.value |= EntityStatusValue.dead;
      }
    }

    return finalDamage > 0 ? finalDamage : 0;
  }

  int damageMalus() => injuries.manager.getMalus();

  int actionMalus() {
    var malus = damageMalus();
    if(status.value & EntityStatusValue.stunned != EntityStatusValue.none) {
      malus += 10;
    }
    return malus;
  }

  double size;
  double get attackMovementDistance => size * 1.2;
  double get contactCombatRange => size / 2;

  EntitySkills skills;
  EntityStatus status;
  @JsonKey(fromJson: EntityEquipment.fromJson, toJson: EntityEquipment.toJson)
  final EntityEquipment equipment;
  final EntityMagic magic;

  @override
  bool meetsEquipableRequirements(EquipableItem item) {
    bool meets = true;
    for(var (a, v) in item.equipRequirements()) {
      meets = abilities.ability(a) >= v;
      if(!meets) break;
    }
    return meets;
  }

  @override
  String unmetEquipableRequirementsDescription(EquipableItem item) {
    var ret = <String>[];
    for(var (a, v) in item.equipRequirements()) {
      if(abilities.ability(a) < v) {
        ret.add('${a.name} ($v)');
      }
    }
    return ret.join(', ');
  }

  void addEquipment(Equipment eq) {
    equipment.add(eq);
  }
  void removeEquipment(Equipment eq) {
    if(!equipment.contains(eq)) return;

    if(eq is EquipableItem) unequip(eq);
    equipment.remove(eq);
  }

  final List<DamageProvider> _naturalWeapons = <DamageProvider>[];

  void addNaturalWeapon(WeaponRange range, DamageProvider nw) {
    if(!_naturalWeapons.contains(nw)) _naturalWeapons.add(nw);
    addDamageProvider(range, nw);
  }

  final List<ProtectionProvider> _protectionProviders = <ProtectionProvider>[];

  void addProtectionProvider(ProtectionProvider pp) {
    _protectionProviders.add(pp);
  }
  void removeProtectionProvider(ProtectionProvider pp) {
    _protectionProviders.remove(pp);
  }

  final Map<WeaponRange, List<DamageProvider>> _damageProviders = <WeaponRange, List<DamageProvider>>{};

  void addDamageProvider(WeaponRange range, DamageProvider dp) {
    if(!_damageProviders.containsKey(range)) _damageProviders[range] = <DamageProvider>[];
    if(!_damageProviders[range]!.contains(dp)) _damageProviders[range]!.add(dp);
  }
  void removeDamageProvider(DamageProvider dp) {
    for(var range in _damageProviders.keys) {
      _damageProviders[range]!.remove(dp);
    }
  }
  List<DamageProvider> damageProvidersForRange(WeaponRange range) {
    return _damageProviders[range] ?? <DamageProvider>[];
  }
  List<DamageProvider> damageProviderForHand(EquipableItemTarget hand) {
    var ret = <DamageProvider>[];

    if(hand == EquipableItemTarget.dominantHand) {
      if(dominantHandEquiped is DamageProvider) {
        ret.add(dominantHandEquiped! as DamageProvider);
      }
    }
    else if(hand == EquipableItemTarget.weakHand) {
      if(weakHandEquiped is DamageProvider) {
        ret.add(weakHandEquiped! as DamageProvider);
      }
    }

    // Add the natural weapons
    // Only select hand-based natural weapons if hands are free
    if(ret.isEmpty) {
      for (var nw in _naturalWeapons) {
        if (nw is EquipableItem) {
          ret.add(nw);
        }
      }
    }

    return ret;
  }

  (List<int>, int?) rollInitiatives({
    int additionalDices = 0,
  }) {
    var dominantHandInitiatives = List.generate(initiative + additionalDices, (index) => Random().nextInt(10) + 1);
    dominantHandInitiatives.sort((a, b) => b - a);
    if(additionalDices > 0) {
      dominantHandInitiatives = dominantHandInitiatives.sublist(0, initiative);
    }

    int? weakHandInitiative;
    if(weakHandEquiped != null && weakHandEquiped != dominantHandEquiped) {
      weakHandInitiative = Random().nextInt(10) + 1;
    }

    return (dominantHandInitiatives, weakHandInitiative);
  }

  static void preImportFilter(Map<String, dynamic> json) {
    if(json.containsKey('image') && json['image'] != null) {
      json['image'].remove('is_new');
    }

    if(json.containsKey('icon') && json['icon'] != null) {
      json['icon'].remove('is_new');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    var j = _$EntityBaseToJson(this);
    saveNonExportableJson(j);
    return j;
  }

  factory EntityBase.fromJson(Map<String, dynamic> json) {
    EntityBase c = _$EntityBaseFromJson(json);
    c.loadNonRestorableJson(json);
    return c;
  }

  @mustCallSuper
  void saveNonExportableJson(Map<String, dynamic> json) {
  }

  @mustCallSuper
  void loadNonRestorableJson(Map<String, dynamic> json) {
    for(var eq in equipment) {
      if(eq is EquipableItem && eq.equipedOn != EquipableItemTarget.none) {
        equip(eq, target: eq.equipedOn);
      }
    }
  }
}

InjuryManager entityBaseDefaultInjuries(EntityBase? entity, InjuryManager? source) {
  if(source == null) {
    return InjuryManager.simple(
      injuredCeiling: 30,
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

Map<String, dynamic> enumKeyedMapToJson(Map<Enum, dynamic> m) {
  return <String, dynamic>{for(var k in m.keys) k.name: m[k]};
}