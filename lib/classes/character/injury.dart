import 'dart:collection';

import 'package:json_annotation/json_annotation.dart';

part 'injury.g.dart';

enum Injury {
  injured(title: 'Blessé'),
  scratch(title: 'Égratignure'),
  light(title: 'Légère'),
  grave(title: 'Grave'),
  fatal(title: 'Fatale'),
  death(title: 'Mort');

  final String title;

  const Injury({ required this.title });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class InjuryLevel {
  InjuryLevel({
    required this.rank,
    required this.title,
    required this.start,
    required this.end,
    required this.malus,
    required this.capacity,
  });

  final int rank;
  final String title;
  int start;
  int end;
  final int malus;
  int capacity;

  factory InjuryLevel.fromJson(Map<String, dynamic> json) => _$InjuryLevelFromJson(json);
  Map<String, dynamic> toJson() => _$InjuryLevelToJson(this);
}

class _InjuryRange implements Comparable<_InjuryRange> {
  _InjuryRange({required this.min, required this.max});

  int min;
  int max;

  @override
  bool operator==(Object other) =>
      other is _InjuryRange && other.min == min && other.max == max;

  @override
  int get hashCode => Object.hash(min, max);

  @override
  int compareTo(_InjuryRange other) => min - other.min;
}

class InjuryManager {
  InjuryManager({
      required List<InjuryLevel> levels,
      InjuryManager? source,
    })
  {
    if(levels.isEmpty) {
      throw ArgumentError('Pas de niveaux de blessure fournis');
    }

    levels.sort((InjuryLevel a, InjuryLevel b) => a.start - b.start);

    if(levels.first.start != 0) {
      throw ArgumentError('Le premier niveau de blessures doit commencer à zéro');
    }

    if(levels.last.end != -1) {
      throw ArgumentError('Le dernier niveau de blessure doit terminer à -1');
    }

    for(var i = 0; i < levels.length; ++i) {
      var range = _InjuryRange(min: levels[i].start, max: levels[i].end);
      _injuryLevels[range] = levels[i];
    }

    if(source != null) {
      _injuries = Map.from(source._injuries);
    }
  }

  final SplayTreeMap<_InjuryRange, InjuryLevel> _injuryLevels = SplayTreeMap<_InjuryRange, InjuryLevel>();
  Map<int, int> _injuries = <int, int>{};

  factory InjuryManager.simple({
      required int injuredCeiling,
      required int injuredCount,
      int deathCount = 1,
      InjuryManager? source,
    })
  {
    return InjuryManager(
      source: source,
      levels: [
        InjuryLevel(
          rank: 0,
          title: 'Blessé',
          start: 0,
          end: injuredCeiling,
          malus: 0,
          capacity: injuredCount,
        ),
        InjuryLevel(
          rank: 1,
          title: 'Mort',
          start: injuredCeiling,
          end: -1,
          malus: 0,
          capacity: deathCount,
        ),
      ],
    );
  }

  factory InjuryManager.full({
      required int scratchCount,
      required int lightCount,
      required int graveCount,
      required int fatalCount,
      int deathCount = 1,
      InjuryManager? source,
    })
  {
    return InjuryManager(
      source: source,
      levels: [
        InjuryLevel(
          rank: 0,
          title: 'Égratignure',
          start: 0,
          end: 10,
          malus: 0,
          capacity: scratchCount,
        ),
        InjuryLevel(
          rank: 1,
          title: 'Légère',
          start: 10,
          end: 20,
          malus: 1,
          capacity: lightCount,
        ),
        InjuryLevel(
          rank: 2,
          title: 'Grave',
          start: 20,
          end: 30,
          malus: 3,
          capacity: graveCount,
        ),
        InjuryLevel(
          rank: 3,
          title: 'Fatale',
          start: 30,
          end: 40,
          malus: 5,
          capacity: fatalCount,
        ),
        InjuryLevel(
          rank: 4,
          title: 'Mort',
          start: 40,
          end: -1,
          malus: 10,
          capacity: deathCount,
        ),
      ]
    );
  }

  static InjuryManager getInjuryManagerForAbilities({ required int resistance, required int volonte, InjuryManager? source }) {
    int scratchCount = 0;
    int lightCount = 0;
    int graveCount = 0;
    int fatalCount = 0;
    int sum = resistance + volonte;

    if(sum < 5) {
      scratchCount = 2;
      lightCount = 1;
      graveCount = 1;
      fatalCount = 1;
    }
    else if(sum < 10) {
      scratchCount = 3;
      lightCount = 2;
      graveCount = 1;
      fatalCount = 1;
    }
    else if(sum < 15) {
      scratchCount = 3;
      lightCount = 2;
      graveCount = 2;
      fatalCount = 1;
    }
    else if(sum < 20) {
      scratchCount = 3;
      lightCount = 3;
      graveCount = 2;
      fatalCount = 2;
    }
    else {
      scratchCount = 3;
      lightCount = 4;
      graveCount = 3;
      fatalCount = 2;
    }

    return InjuryManager.full(
      scratchCount: scratchCount,
      lightCount: lightCount,
      graveCount: graveCount,
      fatalCount: fatalCount,
      source: source,
    );
  }

  List<InjuryLevel> levels() => _injuryLevels.values.toList();
  int count(InjuryLevel level) => _injuries.containsKey(level.rank) ? _injuries[level.rank]! : 0;

  InjuryLevel setDamage(int amount) {
    var range = _injuryLevels.lastKeyBefore(_InjuryRange(min: amount, max: 99999));
    if(range == null) throw ArgumentError('Impossible de trouver le niveau de blessures pour $amount dégats');
    var level = _injuryLevels[range]!;

    while(level.end != -1) {
      var targetLevelCount = _injuries[level.rank] ?? 0;
      if(targetLevelCount >= level.capacity) {
        range = _injuryLevels.firstKeyAfter(range!);
        if(range == null) {
          throw ArgumentError('Pas de niveau de blessure trouvé après ${level.title} (rang ${level.rank})');
        }
        level = _injuryLevels[range]!;
      }
      else {
        break;
      }
    }

    var count = (_injuries[level.rank] ?? 0) + 1;
    if(count <= level.capacity) _injuries[level.rank] = count;
    return level;
  }

  void heal(InjuryLevel level) {
    if(!_injuries.containsKey(level.rank)) return;
    if(_injuries[level.rank]! == 0) return;
    _injuries[level.rank] = _injuries[level.rank]! - 1;
  }

  bool isDead() {
    var deathLevel = _injuryLevels[_injuryLevels.lastKey()!]!;
    var deathCount = _injuries[deathLevel.rank] ?? 0;
    return deathCount >= deathLevel.capacity;
  }

  int getMalus() {
    var malus = 0;
    var currentInjuryRanks = _injuries.keys.toList()..sort();

    if(currentInjuryRanks.isNotEmpty) {
      var highestRank = currentInjuryRanks.last;
      InjuryLevel? highestLevel;
      for(var level in _injuryLevels.values) {
        if(level.rank == highestRank) {
          highestLevel = level;
          break;
        }
      }
      if(highestLevel == null) {
        throw ArgumentError('Pas de niveau de blessure trouvé pour le rang infligé $highestRank');
      }
      malus = highestLevel.malus;
    }

    return malus;
  }

  Map<String, dynamic> toJson() {
    var levels = <Map<String, dynamic>>[];
    var injuries = <String, int>{};

    for(var level in _injuryLevels.values) {
      levels.add(level.toJson());
    }

    for(var injury in _injuries.entries) {
      injuries[injury.key.toString()] = injury.value;
    }

    return <String, dynamic>{
      'levels': levels,
      'injuries': injuries,
    };
  }

  factory InjuryManager.fromJson(Map<String, dynamic> json) {
    if(!json.containsKey('levels')) {
      throw ArgumentError("Pas d'entrée 'levels' dans le JSON fourni");
    }
    if(json['levels']! is! List) {
      throw ArgumentError("L'entrée 'levels' dans le JSON n'est pas une liste");
    }

    var levels = <InjuryLevel>[];
    for(Map<String, dynamic> l in json['levels']) {
      var level = InjuryLevel.fromJson(l);
      levels.add(level);
    }

    var ret = InjuryManager(levels: levels);
    if(json.containsKey('injuries') && json['injuries']! is Map) {
      var injuries = <int, int>{};
      for(var k in json['injuries'].keys) {
        injuries[int.parse(k)] = json['injuries']![k];
      }
      ret._injuries = injuries;
    }

    return ret;
  }
}