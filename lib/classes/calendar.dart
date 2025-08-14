import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'calendar.g.dart';

enum KorDuration {
  year(title: 'Année', daysLength: 324, article: "l'"),
  cycle(title: 'Cycle', daysLength: 81, article: "le "),
  augure(title: 'Augure', daysLength: 32, article: "l'"),
  week(title: 'Semaine', daysLength: 9, article: "la "),
  day(title: 'Jour', daysLength: 1, article: "le ");

  const KorDuration({required this.title, required this.daysLength, required this.article});

  static DayRange toDayRange(KorDuration duration, int count, {bool inThePast = false}) {
    int start;
    int end;

    if(inThePast) {
      start = -(duration.daysLength * count);
      end = -(duration.daysLength * (count - 1)) - 1;
    }
    else {
      start = duration.daysLength * count;
      end = duration.daysLength * (count + 1) - 1;
    }

    return DayRange(start: start, end: end);
  }

  static KorDuration bestFitForRange(DayRange range) {
    var alignedEnd = range.end;
    if(range.start != range.end) {
      alignedEnd += 1;
    }

    for(KorDuration d in KorDuration.values) {
      var alignmentStart = range.start % d.daysLength;
      var alignmentEnd = alignedEnd % d.daysLength;
      if(alignmentStart == 0 && alignmentEnd == 0) {
        return d;
      }
    }

    // Just to be safe, though the previous loop will always return 'day'
    return day;
  }

  final String title;
  final int daysLength;
  final String article;
}

enum KorAge {
  fondations(title: 'Âge des Fondations', shortTitle: 'AdF'),
  conquetes(title: 'Âge des Conquêtes', shortTitle: 'AdC'),
  empires(title: 'Âge des Empires', shortTitle: 'AdE');

  const KorAge({ required this.title, required this.shortTitle });
  final String title;
  final String shortTitle;
}

enum KorCycle {
  blanc(title: "Cycle blanc", shortTitle: "Blanc"),
  moryargon(title: "Cycle de Moryargon", shortTitle: "Moryargon"),
  soleil(title: "Cycle du soleil", shortTitle: "Soleil"),
  silence(title: "Cycle du silence", shortTitle: "Silence");

  const KorCycle({ required this.title, required this.shortTitle });
  final String title;
  final String shortTitle;
}

enum Augure {
  pierre(title: 'La pierre', color: Colors.grey),
  fataliste(title: 'Le fataliste', color: Colors.black),
  chimere(title: 'La chimère', color: Colors.purple),
  nature(title: 'La nature', color: Colors.green),
  ocean(title: "L'océan", color: Colors.indigo),
  metal(title: 'Le métal', color: Colors.blueGrey),
  volcan(title: 'Le volcan', color: Colors.red),
  vent(title: 'Le vent', color: Colors.tealAccent),
  homme(title: "L'homme", color: Colors.amber),
  cite(title: 'La cité', color: Colors.brown),
  none(title: 'Sans augure', color: Colors.white12);

  const Augure({
    required this.title,
    required this.color,
  });

  static Augure? byTitle(String descr) {
    Augure? ret;
    for(var augure in Augure.values) {
      if(augure.title == descr) ret = augure;
    }
    return ret;
  }

  final String title;
  final Color color;
}

enum WeekDay {
  roc(title: 'Jour du roc', shortTitle: 'Roc'),
  volcan(title: 'Jour du volcan', shortTitle: 'Volcan'),
  ecume(title: "Jour de l'écume", shortTitle: 'Écume'),
  metal(title: 'Jour du métal', shortTitle: 'Métal'),
  arbre(title: "Jour de l'arbre", shortTitle: 'Arbre'),
  songes(title: 'Jour des songes', shortTitle: 'Songes'),
  foyer(title: 'Jour du foyer', shortTitle: 'Foyer'),
  vents(title: 'Jour des vents', shortTitle: 'Vents'),
  serpent(title: 'Jour du serpent', shortTitle: 'Serpent');

  const WeekDay({ required this.title, required this.shortTitle });
  final String title;
  final String shortTitle;
}

class DayRange {
  DayRange({ required this.start, required this.end});

  final int start;
  final int end;

  @override
  String toString() => "$start,$end";

  factory DayRange.fromString(String s) {
    var regexp = RegExp(r'(-?\d+)');
    var values = regexp.allMatches(s).map((v) => int.parse(v[0]!)).toList();
    if(values.length < 2) {
      values[1] = values[0];
    }
    return DayRange(start: values[0], end: values[1]);
  }

  @override
  bool operator==(Object other) =>
      other is DayRange && start == other.start && end == other.end;

  @override
  int get hashCode => Object.hash(start, end);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class KorDate {
  KorDate({
    this.age = KorAge.empires,
    required this.year,
    required this.cycle,
    required this.week,
    required this.day,
  });

  KorAge age;
  int year;
  KorCycle cycle;
  int week;
  WeekDay day;

  int dayIndex() => (81 * cycle.index) + (9 * (week - 1)) + (day.index + 1);

  void addDays(int days) {
    var current = dayIndex();
    var target = current + days;
    var numYears = 0;

    if(target < current) {
      while (target < 1) {
        numYears -= 1;
        target += 324;
      }
    }
    else {
      numYears = target ~/ 324;
    }

    day = WeekDay.values[(target - 1) % 9];
    week = (((target - 1) % 81) ~/ 9) + 1;
    cycle = KorCycle.values[(target ~/ 81) % 4 ];
    year += numYears;
  }

  String toCompactString() => '${day.index+1}/$week/${cycle.shortTitle}, $year ${age.shortTitle}';

  String toFullString() {
    var weekOrdinal = week == 1
        ? 'ère'
        : 'e';
    return '${day.title}, $week$weekOrdinal semaine du ${cycle.title}, $year ${age.shortTitle}';
  }

  Map<String, dynamic> toJson() => _$KorDateToJson(this);
  factory KorDate.fromJson(Map<String, dynamic> json) => _$KorDateFromJson(json);
}

Augure getAugureForDate(KorDate date) {
  // Quick exit for the last day of each cycle
  if(date.week == 9 && date.day == WeekDay.serpent) {
    return Augure.none;
  }

  var dayIndex = date.dayIndex();
  var augureLessCount = dayIndex ~/ 81;
  var augureIndex = (dayIndex - 1 - augureLessCount) ~/ 32;

  return Augure.values[augureIndex];
}