import 'package:json_annotation/json_annotation.dart';
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

import 'combat.dart';
import 'entity/abilities.dart';
import 'entity/skill.dart';
import 'entity/skill_family.dart';
import 'entity/specialized_skill.dart';
import 'equipment.dart';
import 'entity_base.dart';
import 'entity/base.dart';
import 'object_location.dart';
import 'object_source.dart';
import 'storage/default_assets_store.dart';
import 'storage/storable.dart';

part 'weapon.g.dart';

class WeaponStore extends JsonStoreAdapter<WeaponModel> {
  @override
  String storeCategory() => 'weapons';

  @override
  String key(WeaponModel object) => object.id;

  @override
  Future<WeaponModel> fromJsonRepresentation(Map<String, dynamic> j) async =>
      WeaponModel.fromJson(j);

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(WeaponModel object) async =>
      object.toJson();
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class WeaponModel extends EquipmentModel {
  factory WeaponModel({
    required String uuid,
    required String name,
    required ObjectSource source,
    ObjectLocation location = ObjectLocation.memory,
    required double weight,
    required int creationDifficulty,
    required int creationTime,
    required EquipmentAvailability villageAvailability,
    required EquipmentAvailability cityAvailability,
    required SpecializedSkill skill,
    required EquipableItemBodyPart bodyPart,
    required int hands,
    required Map<Ability, int> requirements,
    required Map<WeaponRange, int> initiative,
    required AttributeBasedCalculator damage,
    required AttributeBasedCalculator rangeEffective,
    required AttributeBasedCalculator rangeMax,
    List<EquipmentSpecialCapability>? special,
  })
  {
    var wm = _cache[uuid]
        ?? WeaponModel._create(
            uuid: uuid,
            name: name,
            source: source,
            location: location,
            weight: weight,
            creationDifficulty: creationDifficulty,
            creationTime: creationTime,
            villageAvailability: villageAvailability,
            cityAvailability: cityAvailability,
            skill: skill,
            bodyPart: bodyPart,
            hands: hands,
            requirements: requirements,
            initiative: initiative,
            damage: damage,
            rangeEffective: rangeEffective,
            rangeMax: rangeMax,
            special: special,
        );
    _cache[wm.id] = wm;
    return wm;
  }

  WeaponModel._create({
    required super.uuid,
    required super.name,
    required super.source,
    super.location,
    required super.weight,
    required super.creationDifficulty,
    required super.creationTime,
    required super.villageAvailability,
    required super.cityAvailability,
    required this.skill,
    required this.bodyPart,
    required this.hands,
    required this.requirements,
    required this.initiative,
    required this.damage,
    required this.rangeEffective,
    required this.rangeMax,
    super.special,
  });

  @JsonKey(readValue: _getSkillFromJson, toJson: _setSkillToJson)
  SpecializedSkill skill;
  EquipableItemBodyPart bodyPart;
  int hands;
  Map<Ability,int> requirements;
  Map<WeaponRange, int> initiative;
  AttributeBasedCalculator damage;
  AttributeBasedCalculator rangeEffective;
  AttributeBasedCalculator rangeMax;

  WeaponRange get range {
    return initiative.keys.reduce((value, element) => element.index > value.index ? element : value);
  }

  Weapon instantiate() {
    return Weapon.create(model: this);
  }

  static Iterable<String> ids() => _cache.keys;

  static Iterable<String> idsBySkill(Skill skill) =>
    _cache.values
      .where(
          (WeaponModel wm) => wm.skill.parent == skill
      )
      .map(
          (WeaponModel wm) => wm.id
      );

  static WeaponModel? get(String id) => _cache[id];

  static List<Skill> weaponSkills() =>
    [...Skill.fromFamily(SkillFamily.combat), Skill.armesAProjectiles, Skill.armesAPoudreNoire, Skill.armesMecaniques]
      .where((Skill s) => !([Skill.criDeLaPierre, Skill.creatureNaturalWeapon, Skill.bouclier].contains(s)))
      .toList();

  static List<Skill> skillsForWeaponRange(WeaponRange range) =>
    _rangeToSkill[range] ?? <Skill>[];

  static List<WeaponRange> weaponRangesForSkill(Skill skill) {
    var ret = <WeaponRange>[];
    for(var r in _rangeToSkill.keys) {
      if(_rangeToSkill[r]!.contains(skill)) {
        ret.add(r);
      }
    }
    return ret;
  }

  static Future<void> init() async {
    // ignore:unused_local_variable
    var c = _cache;
    await loadAll();
  }

  static Future<void> loadAll() async {
    EquipmentFactory.instance.registerFactory('weapon', _weaponFactory);

    await _loadLock.synchronized(() async {
      var assetFiles = [
        'weapon.json',
      ];

      for (var f in assetFiles) {
        for (var model in await loadJSONAssetObjectList(f)) {
          try {
            // ignore:unused_local_variable
            var instance = WeaponModel.fromJson(model);
            _cache[instance.id] = instance;
          } catch (e, stacktrace) {
            print('Error loading weapon ${model["name"]}: ${e.toString()}\n${stacktrace.toString()}');
          }
        }
      }

      for(var instance in (await WeaponStore().getAll())) {
        _cache[instance.id] = instance;
      }
    });
  }

  static Future<void> saveLocalModel(WeaponModel weapon) async {
    await WeaponStore().save(weapon);
    _cache[weapon.id] = weapon;
  }

  static Future<void> deleteLocalModel(String id) async {
    var weapon = await WeaponStore().get(id);
    if(weapon != null) await WeaponStore().delete(weapon);
    _cache.remove(id);
  }

  static final Map<WeaponRange, List<Skill>> _rangeToSkill = {
      WeaponRange.contact: [
        Skill.armesTranchantes,
        Skill.armesDeChoc,
        Skill.armesContondantes,
        Skill.armesDoubles,
        Skill.corpsACorps,
      ],
      WeaponRange.melee: [
        Skill.armesTranchantes,
        Skill.armesDeChoc,
        Skill.armesContondantes,
        Skill.armesArticulees,
        Skill.armesDoubles,
        Skill.corpsACorps,
      ],
      WeaponRange.distance: [
        Skill.armesDHast
      ],
      WeaponRange.ranged: [
        Skill.armesDeJet,
        Skill.armesAProjectiles,
        Skill.armesMecaniques,
        Skill.armesAPoudreNoire,
      ],
    };

  static Weapon? _weaponFactory(String id, String uuid) {
    var model = get(id);
    if(model == null) return null;
    return Weapon(uuid, model: model);
  }

  static Object? _getSkillFromJson(Map<dynamic, dynamic> json, _) {
    var skill = Skill.values.byName(json['skill']);
    var sp = SpecializedSkill.create(parent: skill, name: json['name']);
    return sp.toJson();
  }

  static String _setSkillToJson(SpecializedSkill skill) => skill.parent.name;

  static final Map<String, WeaponModel> _cache = <String, WeaponModel>{};
  static final _loadLock = Lock();

  factory WeaponModel.fromJson(Map<String, dynamic> json) =>
      _$WeaponModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$WeaponModelToJson(this);
}

class Weapon extends EquipableItem implements DamageProvider, InitiativeProvider {
  Weapon(this._uuid, { required this.model })
    : super(
        name: model.name,
        weight: model.weight,
        bodyPart: model.bodyPart,
        handiness: model.hands
      );

  Weapon.create({ required this.model })
    : _uuid = const Uuid().v4().toString(),
      super(
        name: model.name,
        weight: model.weight,
        bodyPart: EquipableItemBodyPart.hand,
        handiness: model.hands
      );

  final String _uuid;
  final WeaponModel model;

  @override
  String type() => 'weapon:${model.id}';

  @override
  String uuid() => _uuid;

  @override
  Map<Ability, int> equipRequirements() => model.requirements;

  @override
  void equiped(SupportsEquipableItem owner, EquipableItemTarget target) {
    super.equiped(owner, target);

    if(owner is EntityBase) {
      for (var range in model.initiative.keys) {
        owner.addDamageProvider(range, this);
      }
    }
  }

  @override
  void unequiped(SupportsEquipableItem owner) {
    super.unequiped(owner);

    if(owner is EntityBase) {
      owner.removeDamageProvider(this);
    }
  }

  @override
  int damage(EntityBase owner, {List<int>? throws }) =>
      model.damage.calculate(
          model.damage.ability != null
              ? owner.abilities.ability(model.damage.ability!)
              : 0,
          throws: throws
      ).toInt();

  @override
  int initiativeForRange(WeaponRange range) {
    int ret = 0;
    WeaponRange selected = WeaponRange.contact;
    for(var r in model.initiative.keys) {
      if(r.index >= selected.index && r.index <= range.index) {
        selected = r;
        ret = model.initiative[r]!;
      }
    }
    return ret;
  }
}