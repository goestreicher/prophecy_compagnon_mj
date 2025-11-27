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

class MagicSpellFilter {
  MagicSpellFilter({
    this.sourceType,
    this.source,
    this.sphere,
    this.skill,
    this.level = -1,
    this.search,
  });

  ObjectSourceType? sourceType;
  ObjectSource? source;
  MagicSphere? sphere;
  MagicSkill? skill;
  int level;
  String? search;

  @override
  int get hashCode => Object.hash(sourceType, source, search);

  @override
  bool operator ==(Object other) =>
      other is MagicSpellFilter
          && other.sourceType == sourceType
          && other.source == source
          && other.sphere == sphere
          && other.skill == skill
          && other.level == level
          && other.search == search;
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
  String get id => _getId(name);

  static MagicSpell? get(String id) {
    for(var name in _spells.keys) {
      if(id == _getId(name)) {
        return _spells[name];
      }
    }
    return null;
  }

  static MagicSpell? byName(String name) => _spells[name];

  static Iterable<MagicSpell> filteredList(MagicSpellFilter filter) =>
    _spells.values
      .where((MagicSpell s) => filter.sourceType == null || s.source.type == filter.sourceType)
      .where((MagicSpell s) => filter.source == null || s.source == filter.source)
      .where((MagicSpell s) => filter.sphere == null || s.sphere == filter.sphere)
      .where((MagicSpell s) => filter.skill == null || s.skill == filter.skill)
      .where((MagicSpell s) => filter.level == -1 || s.level == filter.level)
      .where((MagicSpell s) =>
        filter.search == null
        || s.name.toLowerCase().contains(filter.search!.toLowerCase()));

  Iterable<MagicSpell> forSphere(MagicSphere sphere) =>
    filteredList(MagicSpellFilter(sphere: sphere));

  static Iterable<MagicSpell> forLocationType(
    ObjectLocationType type,
    {
      MagicSpellFilter? filter,
    }
  ) =>
    (filter == null ? _spells.values : filteredList(filter))
      .where((MagicSpell s) => s.location.type == type);

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
          _spells[spell.name] = spell;
        } catch (e, stacktrace) {
          print('Error loading spell ${model["name"]}: ${e.toString()}\n${stacktrace.toString()}');
        }
      }
    }
  }

  static String _getId(String name) =>
      sentenceToCamelCase(transliterateFrenchToAscii(name));

  static bool _defaultAssetsLoaded = false;
  static final Map<String, MagicSpell> _spells = <String, MagicSpell>{};

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