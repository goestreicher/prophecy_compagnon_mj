import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../magic.dart';

part 'magic.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@EntityMagicSkillsJsonConverter()
@EntityMagicSpheresJsonConverter()
class EntityMagic {
  EntityMagic({
    Map<MagicSkill, int>? skills,
    Map<MagicSphere, int>? spheres,
    this.pool = 0,
    Map<MagicSphere, int>? pools,
    Iterable<MagicSpell>? spells
  })
    : skills = EntityMagicSkills(skills: skills),
      spheres = EntityMagicSpheres(values: spheres),
      pools = EntityMagicSpheres(values: pools),
      spells = EntityMagicSpells(spells: spells?.toList());

  final EntityMagicSkills skills;
  final EntityMagicSpheres spheres;
  int pool;
  final EntityMagicSpheres pools;
  @JsonKey(fromJson: EntityMagicSpells.fromJson, toJson: EntityMagicSpells.toJson)
  final EntityMagicSpells spells;

  factory EntityMagic.fromJson(Map<String, dynamic> json) =>
      _$EntityMagicFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityMagicToJson(this);
}

class EntityMagicSkills {
  EntityMagicSkills({ Map<MagicSkill, int>? skills })
    : _skills = skills?.map(
          (MagicSkill s, int v) => MapEntry(s, ValueNotifier<int>(v))
        ) ?? <MagicSkill, ValueNotifier<int>>{}
  {
    for(var s in MagicSkill.values) {
      _skills.putIfAbsent(s, () => ValueNotifier<int>(0));
    }
  }

  ValueNotifier<int> notifier(MagicSkill s) => _skills[s]!;
  int get(MagicSkill s) => _skills[s]!.value;
  void set(MagicSkill s, int v) => _skills[s]!.value = v;

  int get instinctive => _skills[MagicSkill.instinctive]!.value;
  set instinctive(int v) => _skills[MagicSkill.instinctive]!.value = v;

  int get invocatoire => _skills[MagicSkill.invocatoire]!.value;
  set invocatoire(int v) => _skills[MagicSkill.invocatoire]!.value = v;

  int get sorcellerie => _skills[MagicSkill.sorcellerie]!.value;
  set sorcellerie(int v) => _skills[MagicSkill.sorcellerie]!.value = v;

  final Map<MagicSkill, ValueNotifier<int>> _skills;
}

class EntityMagicSkillsJsonConverter extends JsonConverter<EntityMagicSkills, Map<String, dynamic>> {
  const EntityMagicSkillsJsonConverter();

  @override
  EntityMagicSkills fromJson(Map<String, dynamic> json) {
    return EntityMagicSkills(
      skills: <MagicSkill, int>{
        for (var k in json.keys) MagicSkill.values.byName(k): (json[k] as int)
      }
    );
  }

  @override
  Map<String, dynamic> toJson(EntityMagicSkills skills) {
    return <String, dynamic>{for (var s in MagicSkill.values) s.name: skills.get(s)};
  }
}

class EntityMagicSpheres {
  EntityMagicSpheres({ Map<MagicSphere, int>? values })
    : _all = values ?? <MagicSphere, int>{}
  {
    for(var s in MagicSphere.values) {
      _all.putIfAbsent(s, () => 0);
    }
  }

  int get(MagicSphere s) => _all[s]!;
  void set(MagicSphere s, int v) => _all[s] = v;

  final Map<MagicSphere, int> _all;
}

class EntityMagicSpheresJsonConverter extends JsonConverter<EntityMagicSpheres, Map<String, dynamic>> {
  const EntityMagicSpheresJsonConverter();

  @override
  EntityMagicSpheres fromJson(Map<String, dynamic> json) {
    return EntityMagicSpheres(
      values: <MagicSphere, int>{
        for (var k in json.keys) MagicSphere.values.byName(k): (json[k] as int)
      }
    );
  }

  @override
  Map<String, dynamic> toJson(EntityMagicSpheres spheres) {
    return <String, dynamic>{for (var s in MagicSphere.values) s.name: spheres.get(s)};
  }
}

class EntityMagicSpells with IterableMixin<MagicSpell>, ChangeNotifier {
  EntityMagicSpells({ List<MagicSpell>? spells })
    : _all = spells ?? <MagicSpell>[];

  @override
  Iterator<MagicSpell> get iterator => _all.iterator;

  Iterable<MagicSpell> forSphere(MagicSphere sphere) =>
      _all.where((MagicSpell s) => s.sphere == sphere);

  void add(MagicSpell s) {
    _all.add(s);
    notifyListeners();
  }

  void remove(MagicSpell s) {
    if(_all.remove(s)) notifyListeners();
  }

  void removeByName(String name) {
    var idx = _all.indexWhere((MagicSpell s) => s.name == name);
    if(idx != -1) remove(_all[idx]);
  }

  static EntityMagicSpells fromJson(List<dynamic> json) {
    var spells = <MagicSpell>[];
    for(var n in json) {
      var spell = MagicSpell.byName(n as String);
      if(spell != null) spells.add(spell);
    }
    return EntityMagicSpells(spells: spells);
  }

  static List<String> toJson(EntityMagicSpells spells) {
    return spells.map((MagicSpell s) => s.name).toList();
  }

  final List<MagicSpell> _all;
}