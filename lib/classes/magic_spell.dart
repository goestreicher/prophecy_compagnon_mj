import 'package:json_annotation/json_annotation.dart';

import '../text_utils.dart';
import 'magic.dart';
import 'object_location.dart';
import 'object_source.dart';
import 'resource_base_class.dart';
import 'storage/default_assets_store.dart';

part 'magic_spell.g.dart';

enum CastingDurationUnit {
  action(title: 'action'),
  turn(title: 'tour'),
  minute(title: 'minute'),
  hour(title: 'heure');

  final String title;

  const CastingDurationUnit({ required this.title });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MagicSpell extends ResourceBaseClass {
  MagicSpell({
    required super.name,
    required super.source,
    super.location = ObjectLocation.memory,
    required this.sphere,
    required this.level,
    required this.skill,
    required this.complexity,
    required this.cost,
    required this.difficulty,
    required this.castingDuration,
    required this.castingDurationUnit,
    required this.keys,
    required this.description,
  });

  final MagicSphere sphere;
  final int level;
  final MagicSkill skill;
  final int complexity;
  final int cost;
  final int difficulty;
  final int castingDuration;
  final CastingDurationUnit castingDurationUnit;
  final List<String> keys;
  final String description;

  @override
  String get id => sentenceToCamelCase(transliterateFrenchToAscii(name));

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

    var assetFiles = [
      'spell-pierre.json',
      'spell-feu.json',
      'spell-oceans.json',
      'spell-metal.json',
      'spell-nature.json',
      'spell-reves.json',
      'spell-cite.json',
      'spell-vents.json',
      'spell-ombre.json',
    ];

    for(var f in assetFiles) {
      for(var model in await loadJSONAssetObjectList(f)) {
        if(model is! Map<String, dynamic>) continue;

        try {
          var spell = MagicSpell.fromJson(model);
          if (!_spells.containsKey(spell.sphere)) {
            _spells[spell.sphere] = <String, MagicSpell>{};
          }
          _spells[spell.sphere]![spell.name] = spell;
        } catch (e, stacktrace) {
          print('Error loading spell ${model["name"]}: ${e.toString()}\n${stacktrace.toString()}');
        }
      }
    }
  }

  static bool _defaultAssetsLoaded = false;
  static final Map<MagicSphere, Map<String, MagicSpell>> _spells =
  <MagicSphere, Map<String, MagicSpell>>{};

  factory MagicSpell.fromJson(Map<String, dynamic> json) =>
      _$MagicSpellFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MagicSpellToJson(this);
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