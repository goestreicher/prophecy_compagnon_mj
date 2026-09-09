import 'package:prophecy_compagnon_shared/classes/character/tendencies.dart';

enum DiceThrowResultType {
  none(title: "Inconnu (pas de Difficulté)"),
  criticalFail(title: 'Échec critique'),
  fail(title: 'Échec'),
  success(title: 'Réussite'),
  criticalSuccess(title: 'Réussite critique');

  final String title;

  const DiceThrowResultType({ required this.title });
}

class DiceThrowResult {
  DiceThrowResult({
    this.throwImpossible = false,
    this.mainDie,
    this.neutralDice = const <int>[],
    this.usedTendencies = false,
    this.announcedTendency,
    this.keptTendency,
    this.dragonDie,
    this.fatalityDie,
    this.humanDie,
    this.proficiency,
    this.luck,
    this.criticalDie,
  })
  {
    if(!throwImpossible) {
      if (!usedTendencies) {
        if (mainDie == null) {
          throw(ArgumentError('Un jet sans Tendances doit avoir un résultat sur le dé principal'));
        }
      }
      else {
        if (announcedTendency == null || keptTendency == null) {
          throw(ArgumentError('Un jet de tendance doit déclarer les Tendances annoncée et retenue'));
        }
        if (dragonDie == null || fatalityDie == null || humanDie == null) {
          throw(ArgumentError('Les trois dés de Tendances doivent avoir un résultat'));
        }
      }
    }
  }

  final bool throwImpossible;
  final int? mainDie;
  final List<int> neutralDice;
  final bool usedTendencies;
  final Tendency? announcedTendency;
  final Tendency? keptTendency;
  final int? dragonDie;
  final int? fatalityDie;
  final int? humanDie;
  final int? proficiency;
  final int? luck;
  final int? criticalDie;

  int dieResult() {
    int die;

    if(usedTendencies) {
      switch(keptTendency!) {
        case Tendency.dragon:
          die = dragonDie!;
        case Tendency.fatality:
          die = fatalityDie!;
        case Tendency.human:
          die = humanDie!;
      }
    }
    else {
      die = mainDie!;
    }

    return die;
  }

  int total() => dieResult() + (proficiency ?? 0) + (luck ?? 0);

  DiceThrowResultType criticalType(int threshold) {
    if(dieResult() == 1 && criticalDie! > threshold) {
      return DiceThrowResultType.criticalFail;
    }
    else if(dieResult() == 10 && criticalDie! < threshold) {
      return DiceThrowResultType.criticalSuccess;
    }
    else {
      return DiceThrowResultType.none;
    }
  }
}