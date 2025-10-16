import 'dart:collection';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'injury.g.dart';

enum Injury {
  ignore(
    title: 'Ignoré',
    rank: -1,
    malus: 0,
  ),
  scratch(
    title: 'Égratignure',
    rank: 0,
    malus: 0,
  ),
  injured(
    title: 'Blessé',
    rank: 1,
    malus: 0,
  ),
  light(
    title: 'Légère',
    rank: 1,
    malus: 1,
  ),
  grave(
    title: 'Grave',
    rank: 2,
    malus: 3,
  ),
  fatal(
    title: 'Fatale',
    rank: 3,
    malus: 5,
  ),
  death(
    title: 'Mort',
    rank: 4,
    malus: 10,
    isFinal: true,
  ),
  ;

  final String title;
  final int rank;
  final int malus;
  final bool isFinal;

  const Injury({
    required this.title,
    required this.rank,
    required this.malus,
    this.isFinal = false,
  });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class InjuryLevel {
  InjuryLevel({
    required this.type,
    required this.start,
    required this.end,
    required this.capacity,
  });

  Injury type;
  int start;
  int end;
  int capacity;

  factory InjuryLevel.fromJson(Map<String, dynamic> json) =>
      _$InjuryLevelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$InjuryLevelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityInjuries {
  EntityInjuries({ required InjuryManager manager })
    : managerNotifier = ValueNotifier<InjuryManager>(manager);

  InjuryManager get manager => managerNotifier.value;
  set manager(InjuryManager m) => managerNotifier.value = m;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final ValueNotifier<InjuryManager> managerNotifier;

  factory EntityInjuries.fromJson(Map<String, dynamic> json) =>
      _$EntityInjuriesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityInjuriesToJson(this);
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
      _injuryLevels[range] = InjuryLevel(
        type: levels[i].type,
        start: levels[i].start,
        end: levels[i].end,
        capacity: levels[i].capacity,
      );
    }

    if(source != null) {
      for(var level in levels) {
        if(source._injuries.containsKey(level.type)) {
          _injuries[level.type] = source._injuries[level.type]!;
        }
      }
    }
  }

  final SplayTreeMap<_InjuryRange, InjuryLevel> _injuryLevels = SplayTreeMap<_InjuryRange, InjuryLevel>();
  Map<Injury, int> _injuries = <Injury, int>{};

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
          type: Injury.injured,
          start: 0,
          end: injuredCeiling,
          capacity: injuredCount,
        ),
        InjuryLevel(
          type: Injury.death,
          start: injuredCeiling,
          end: -1,
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
          type: Injury.scratch,
          start: 0,
          end: 10,
          capacity: scratchCount,
        ),
        InjuryLevel(
          type: Injury.light,
          start: 10,
          end: 20,
          capacity: lightCount,
        ),
        InjuryLevel(
          type: Injury.grave,
          start: 20,
          end: 30,
          capacity: graveCount,
        ),
        InjuryLevel(
          type: Injury.fatal,
          start: 30,
          end: 40,
          capacity: fatalCount,
        ),
        InjuryLevel(
          type: Injury.death,
          start: 40,
          end: -1,
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
  int count(InjuryLevel level) => _injuries.containsKey(level.type) ? _injuries[level.type]! : 0;

  InjuryLevel dealDamage(int amount) {
    var range = _injuryLevels.lastKeyBefore(_InjuryRange(min: amount, max: 99999));
    if(range == null) throw ArgumentError('Impossible de trouver le niveau de blessures pour $amount dégats');
    var level = _injuryLevels[range]!;

    if(level.type == Injury.ignore) return level;

    while(level.end != -1) {
      var targetLevelCount = _injuries[level.type] ?? 0;
      if(targetLevelCount >= level.capacity) {
        range = _injuryLevels.firstKeyAfter(range!);
        if(range == null) {
          throw ArgumentError('Pas de niveau de blessure trouvé après ${level.type.title} (rang ${level.type.rank})');
        }
        level = _injuryLevels[range]!;
      }
      else {
        break;
      }
    }

    var count = (_injuries[level.type] ?? 0) + 1;
    if(count <= level.capacity) _injuries[level.type] = count;
    return level;
  }

  void dealInjuries(Injury injury, int count) {
    if(injury == Injury.ignore) return;

    var capacity = 0;
    InjuryLevel? currentLevel;
    for(var level in _injuryLevels.values) {
      if (level.type == injury) {
        currentLevel = level;
        capacity = level.capacity;
      }
    }
    if(currentLevel == null || capacity == 0) {
      throw ArgumentError('Pas de niveau de blessure trouvé pour ${injury.name} (capacité $capacity)');
    }

    var toDeal = count;
    while(toDeal > 0 && currentLevel != null) {
      var currentLevelInjuries = _injuries[currentLevel.type] ?? 0;
      var dealt = min(count, currentLevel.capacity - currentLevelInjuries);
      _injuries[currentLevel.type] = currentLevelInjuries + dealt;
      toDeal -= dealt;

      if(currentLevel.type.isFinal) {
        break;
      }

      InjuryLevel? nextLevel;
      for(var level in _injuryLevels.values) {
        if(level.type.rank > currentLevel.type.rank) {
          nextLevel = level;
          break;
        }
      }
      if(nextLevel == null) {
        throw ArgumentError('Pas de niveau de blessure trouvé après ${currentLevel.type.name}');
      }
      currentLevel = nextLevel;
    }
  }

  void heal(InjuryLevel level) {
    if(!_injuries.containsKey(level.type)) return;
    if(_injuries[level.type]! == 0) return;
    _injuries[level.type] = _injuries[level.type]! - 1;
  }

  bool isDead() {
    var deathLevel = _injuryLevels[_injuryLevels.lastKey()!]!;
    var deathCount = _injuries[deathLevel.type] ?? 0;
    return deathCount >= deathLevel.capacity;
  }

  int getMalus() {
    var malus = 0;
    var currentInjuryRanks = _injuries.keys.toList()..sort(
        (Injury a, Injury b) => a.rank - b.rank
    );

    if(currentInjuryRanks.isNotEmpty) {
      var highestRank = currentInjuryRanks.last;
      InjuryLevel? highestLevel;
      for(var level in _injuryLevels.values) {
        if(level.type == highestRank) {
          highestLevel = level;
          break;
        }
      }
      if(highestLevel == null) {
        throw ArgumentError('Pas de niveau de blessure trouvé pour le rang infligé $highestRank');
      }
      malus = highestLevel.type.malus;
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
      var injuries = <Injury, int>{};
      for(var k in json['injuries'].keys) {
        injuries[Injury.values.byName(k)] = json['injuries']![k];
      }
      ret._injuries = injuries;
    }

    return ret;
  }
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