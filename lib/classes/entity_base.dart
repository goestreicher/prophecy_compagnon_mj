import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'combat.dart';
import 'equipment.dart';
import 'exportable_binary_data.dart';
import 'object_location.dart';
import 'character/base.dart';
import 'character/injury.dart';
import 'character/skill.dart';
import '../text_utils.dart';

part 'entity_base.g.dart';

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
class EntityStatus {
  static final none        = EntityStatus(0);
  static final injured     = EntityStatus(1 <<  1);
  static final dead        = EntityStatus(1 <<  2);
  static final stunned     = EntityStatus(1 <<  3);
  static final unconscious = EntityStatus(1 <<  4);
  static final moving      = EntityStatus(1 << 10);
  static final running     = EntityStatus(1 << 11);
  static final sprinting   = EntityStatus(1 << 12);
  static final attacking   = EntityStatus(1 << 20);

  EntityStatus.empty() : bitfield = 0;
  EntityStatus(this.bitfield);

  EntityStatus operator &(EntityStatus other) =>
      EntityStatus(other.bitfield & bitfield);
  EntityStatus operator |(EntityStatus other) =>
      EntityStatus(other.bitfield | bitfield);
  EntityStatus operator ~() =>
      EntityStatus(~bitfield);
  @override
  bool operator ==(Object other) =>
      other is EntityStatus && other.bitfield == bitfield;
  @override
  int get hashCode => bitfield;

  int bitfield;

  factory EntityStatus.fromJson(Map<String, dynamic> json) => _$EntityStatusFromJson(json);
  Map<String, dynamic> toJson() => _$EntityStatusToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityBase extends ChangeNotifier with SupportsEquipableItem {
  EntityBase(
      {
        String? uuid,
        this.location = ObjectLocation.memory,
        required this.name,
        this.initiative = 1,
        InjuryManager Function(EntityBase?, InjuryManager?) injuryProvider = _entityBaseDefaultInjuries,
        double? size,
        double? weight,
        String? description,
        List<SkillInstance>? skills,
        ExportableBinaryData? image,
        ExportableBinaryData? icon,
      }
    )
    : uuid = uuid ?? (!location.type.canWrite ? null : Uuid().v4().toString()),
      _injuryProvider = injuryProvider,
      size = size ?? 0.8,
      weight = weight ?? 15.0,
      description = description ?? '',
      skills = skills ?? <SkillInstance>[],
      _image = image,
      _icon = icon
  {
    injuries = injuryProvider(this, null);
  }

  String get id => uuid ?? sentenceToCamelCase(transliterateFrenchToAscii(name));
  @JsonKey(includeIfNull: false)
    final String? uuid;
  @JsonKey(includeFromJson: true, includeToJson: false)
    ObjectLocation location;
  String name;
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


  @JsonKey(defaultValue: EntityStatus.empty)
  EntityStatus get status => _status;
  set status(EntityStatus s) {
    _status = s;
  }

  EntityStatus _status = EntityStatus.none;

  bool canAct() {
    return _status & EntityStatus.dead == EntityStatus.none &&
           _status & EntityStatus.unconscious == EntityStatus.none;
  }

  double size;
  double weight;
  double get attackMovementDistance => size * 1.2;
  double get contactCombatRange => size / 2;

  int initiative;

  @JsonKey(includeToJson: false, includeFromJson: false)
    late InjuryManager injuries;
  @JsonKey(includeToJson: false, includeFromJson: false)
    InjuryManager Function(EntityBase?, InjuryManager?) _injuryProvider;

  @JsonKey(includeToJson: true, toJson: enumKeyedMapToJson)
    final Map<Ability, int> abilities = <Ability, int>{for(var a in Ability.values) a: 0};

  @JsonKey(includeToJson: true, toJson: enumKeyedMapToJson)
    final Map<Attribute, int> attributes = <Attribute, int>{for(var a in Attribute.values) a: 0};

  List<SkillInstance> skills;

  @JsonKey(includeToJson: true, toJson: equipmentToJson)
    final List<Equipment> equipment = <Equipment>[];

  int ability(Ability a) {
    return abilities[a] ?? 0;
  }
  void setAbility(Ability a, int v) {
    abilities[a] = v;
    injuries = _injuryProvider(this, injuries);
    notifyListeners();
  }

  int attribute(Attribute a) {
    return attributes[a] ?? 0;
  }
  void setAttribute(Attribute a, int v) {
    attributes[a] = v;
    notifyListeners();
  }

  int takeDamage(int amount, { int armorDivider = 1 }) {
    var finalDamage = amount;
    // TODO: manage shields when used to block an attack (in which case their protection don't apply
    for(var pp in _protectionProviders) {
      int reduction = pp.protection() ~/ armorDivider;
      finalDamage -= reduction;
    }

    if(finalDamage > 0) {
      injuries.setDamage(finalDamage);
      if(injuries.isDead()) {
        status |= EntityStatus.dead;
      }
    }

    return finalDamage > 0 ? finalDamage : 0;
  }

  int damageMalus() => injuries.getMalus();

  int actionMalus() {
    var malus = damageMalus();
    if(status & EntityStatus.stunned != EntityStatus.none) {
      malus += 10;
    }
    return malus;
  }

  List<SkillInstance> skillsForFamily(SkillFamily f) {
    return skills.where((SkillInstance s) => s.skill.family == f).toList();
  }
  int skill(Skill s) {
    var idx = skills.indexWhere((element) => element.skill == s);
    return idx == -1 ? 0 : skills[idx].value;
  }
  void setSkill(Skill s, int v) {
    if(v == -1) {
      deleteSkill(s);
    }
    else {
      var idx = skills.indexWhere((element) => element.skill == s);
      if(idx == -1) {
        skills.add(SkillInstance(skill: s, value: v));
      }
      else {
        skills[idx].value = v;
      }
    }
  }
  void deleteSkill(Skill s) {
    skills.removeWhere((element) => element.skill == s);
  }

  List<SpecializedSkill> allSpecializedSkills(Skill s) {
    var idx = skills.indexWhere((element) => element.skill == s);
    if(idx == -1) {
      return <SpecializedSkill>[];
    }
    else {
      return skills[idx].specializations.keys.toList();
    }
  }
  int specializedSkill(SpecializedSkill s, { bool defaultToParent = true }) {
    var idx = skills.indexWhere((element) => element.skill == s.parent);
    if(idx == -1) {
      return 0;
    }

    if(skills[idx].specializations.containsKey(s)) {
      return skills[idx].specializations[s]!;
    }
    else if(defaultToParent) {
      return skills[idx].value;
    }
    else {
      return 0;
    }
  }
  void setSpecializedSkill(SpecializedSkill s, int v) {
    var idx = skills.indexWhere((element) => element.skill == s.parent);
    if(idx == -1) {
      return;
    }

    if(v == -1 && skills[idx].specializations.containsKey(s)) {
      skills[idx].specializations.remove(s);
    }
    else {
      skills[idx].specializations[s] = v;
    }
  }
  void deleteSpecializedSkill(SpecializedSkill s) {
    var idx = skills.indexWhere((element) => element.skill == s.parent);
    if(idx == -1) {
      return;
    }
    skills[idx].specializations.remove(s);
  }

  @override
  bool meetsEquipableRequirements(EquipableItem item) {
    bool meets = true;
    for(var (a, v) in item.equipRequirements()) {
      meets = ability(a) >= v;
      if(!meets) break;
    }
    return meets;
  }

  @override
  String unmetEquipableRequirementsDescription(EquipableItem item) {
    var ret = <String>[];
    for(var (a, v) in item.equipRequirements()) {
      if(ability(a) < v) {
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

  void saveNonExportableJson(Map<String, dynamic> json) {
    json['injuries'] = injuries.toJson();
  }

  void loadNonRestorableJson(Map<String, dynamic> json) {
    for(var a in json['abilities'].keys) {
      setAbility(Ability.values.byName(a), json['abilities'][a] as int);
    }

    for(var a in json['attributes'].keys) {
      setAttribute(Attribute.values.byName(a), json['attributes'][a] as int);
    }

    if(json.containsKey('equipment')) {
      Set<String> currentUuids = equipment.map((Equipment e) => e.uuid()).toSet();

      for (Map<String, dynamic> e in json['equipment']) {
        if(!e.containsKey('uuid')) {
          e['uuid'] = const Uuid().v4().toString();
        }
        else if(currentUuids.contains(e['uuid'] as String)) {
          continue;
        }

        var eq = EquipmentFactory.instance.forgeEquipment(e['type'], uuid: e['uuid']);
        if (eq != null) {
          addEquipment(eq);
        }
      }
    }

    if(json.containsKey('equiped')) {
      for(Map<String, dynamic> e in json['equiped']) {
        var uuid = e['uuid'];
        for(var eq in equipment) {
          if(eq.uuid() == uuid) {
            var item = eq as EquipableItem;
            var target = EquipableItemTarget.none;
            if(e.containsKey('equiped_on')) {
              target = EquipableItemTarget.values.byName(e['equiped_on']);
            }
            equip(item, target: target);
          }
        }
      }
    }

    if(json.containsKey('injuries') && json['injuries'] is Map) {
      injuries = InjuryManager.fromJson(json['injuries']);
    }
  }
}

InjuryManager _entityBaseDefaultInjuries(EntityBase? entity, InjuryManager? source) =>
    InjuryManager.simple(injuredCeiling: 30, injuredCount: 3, deathCount: 1, source: source);

Map<String, dynamic> enumKeyedMapToJson(Map<Enum, dynamic> m) {
  return <String, dynamic>{for(var k in m.keys) k.name: m[k]};
}

Map<String, dynamic> specializedSkillsToJson(Map<SpecializedSkill, dynamic> m) {
  return <String, dynamic>{for(var k in m.keys) k.name: m[k]};
}

List<Map<String, dynamic>> equipmentToJson(List<Equipment> e) {
  List<Map<String, dynamic>> ret = [];

  for(var eq in e) {
    ret.add({
      'type': eq.type(),
      'uuid': eq.uuid(),
    });
  }

  return ret;
}