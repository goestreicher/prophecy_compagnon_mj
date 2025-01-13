import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

import 'character/base.dart';

part 'magic.g.dart';

enum MagicSkill {
  instinctive(title: "Magie instinctive", ability: Ability.empathie),
  invocatoire(title: "Magie invocatoire", ability: Ability.perception),
  sorcellerie(title: "Sorcellerie", ability: Ability.intelligence);

  const MagicSkill({
    required this.title,
    required this.ability,
  });

  static MagicSkill? byTitle(String descr) {
    MagicSkill? ret;
    for(var s in MagicSkill.values) {
      if(s.title == descr) {
        ret = s;
      }
    }
    return ret;
  }

  final String title;
  final Ability ability;
}

enum MagicSphere {
  pierre(title: "La Pierre"),
  feu(title: "Le Feu"),
  oceans(title: "Les Océans"),
  metal(title: "Le Métal"),
  nature(title: "La Nature"),
  reves(title: "Les Rêves"),
  cite(title: "La Cité"),
  vents(title: "Les Vents"),
  ombre(title: "L'Ombre");

  const MagicSphere({
    required this.title,
  });

  final String title;
}

enum CastingDurationUnit {
  action(title: 'action'),
  turn(title: 'tour'),
  minute(title: 'minute'),
  hour(title: 'heure');

  final String title;

  const CastingDurationUnit({ required this.title });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MagicSpell {
  MagicSpell({
    required this.name,
    required this.sphere,
    required this.level,
    required this.skill,
    required this.complexity,
    required this.cost,
    required this.difficulty,
    required this.castingDuration,
    required this.castingDurationUnit,
    required this.keys,
    required this.source,
    required this.description,
  });

  final String name;
  final MagicSphere sphere;
  final int level;
  final MagicSkill skill;
  final int complexity;
  final int cost;
  final int difficulty;
  final int castingDuration;
  final CastingDurationUnit castingDurationUnit;
  final List<String> keys;
  final String source;
  final String description;

  static MagicSpell? byName(String name) {
    MagicSpell? ret;
    for(var spells in _spells.values) {
      if(spells.containsKey(name)) {
        ret = spells[name]!;
        break;
      }
    }
    return ret;
  }

  static List<MagicSpell> spells({ required MagicSphere sphere, int level = -1 }) {
    if(level == -1) {
      return _spells[sphere]?.values.toList() ?? <MagicSpell>[];
    }
    else {
      return _spells[sphere]?.values.where((MagicSpell s) => s.level == level).toList() ?? <MagicSpell>[];
    }
  }

  static Future<void> loadDefaultAssets() async {
    if(_defaultAssetsLoaded) return;
    _defaultAssetsLoaded = true;

    await _loadSpellJsonAsset('assets/spell-pierre.json');
    await _loadSpellJsonAsset('assets/spell-feu.json');
    await _loadSpellJsonAsset('assets/spell-oceans.json');
    await _loadSpellJsonAsset('assets/spell-metal.json');
    await _loadSpellJsonAsset('assets/spell-nature.json');
    await _loadSpellJsonAsset('assets/spell-reves.json');
    await _loadSpellJsonAsset('assets/spell-cite.json');
    await _loadSpellJsonAsset('assets/spell-vents.json');
    await _loadSpellJsonAsset('assets/spell-ombre.json');
  }

  static Future<void> _loadSpellJsonAsset(String asset) async {
    var jsonStr = await rootBundle.loadString(asset);
    var assets = json.decode(jsonStr);

    for(var model in assets) {
      if(model is! Map<String, dynamic>) continue;

      var spell = MagicSpell.fromJson(model);
      if(!_spells.containsKey(spell.sphere)) {
        _spells[spell.sphere] = <String, MagicSpell>{};
      }
      _spells[spell.sphere]![spell.name] = spell;
    }
  }

  static bool _defaultAssetsLoaded = false;
  static final Map<MagicSphere, Map<String, MagicSpell>> _spells =
    <MagicSphere, Map<String, MagicSpell>>{};

  factory MagicSpell.fromJson(Map<String, dynamic> json) => _$MagicSpellFromJson(json);
  Map<String, dynamic> toJson() => _$MagicSpellToJson(this);
}

/*
  Spell JSON
  {
    "name": "",
    "sphere": "",
    "level": 1,
    "skill": "",
    "complexity": 0,
    "cost": 0,
    "difficulty": 0,
    "casting_duration": 0,
    "casting_duration_unit": "",
    "keys": [
      ""
    ],
    "source": "",
    "description": ""
  }
 */