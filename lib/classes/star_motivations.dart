import 'package:json_annotation/json_annotation.dart';

part 'star_motivations.g.dart';

enum MotivationType {
  vertu(title: 'Vertu'),
  penchant(title: 'Penchant'),
  ideal(title: 'Idéal'),
  interdit(title: 'Interdit'),
  epreuve(title: 'Épreuve'),
  destinee(title: 'Destinée'),
  ;

  final String title;

  const MotivationType({ required this.title });
}

enum MotivationVertu {
  loyaute(title: 'Loyauté'),
  tolerance(title: 'Tolérance'),
  pardon(title: 'Pardon'),
  courage(title: 'Courage'),
  devouement(title: 'Dévouement'),
  sagesse(title: 'Sagesse'),
  diplomatie(title: 'Diplomatie'),
  prudence(title: 'Prudence'),
  engagement(title: 'Engagement'),
  imagination(title: 'Imagination'),
  ;

  final String title;

  const MotivationVertu({ required this.title });
}

enum MotivationPenchant {
  violence(title: 'Violence'),
  haine(title: 'Haine'),
  luxure(title: 'Luxure'),
  tentation(title: 'Tentation'),
  colere(title: 'Colère'),
  fanatisme(title: 'Fanatisme'),
  discorde(title: 'Discorde'),
  fatalisme(title: 'Fatalisme'),
  precipitation(title: 'Précipitation'),
  lachete(title: 'Lâcheté'),
  ;

  final String title;

  const MotivationPenchant({ required this.title });
}

enum MotivationIdeal {
  decouvrir(title: 'Découvrir'),
  construire(title: 'Construire'),
  partager(title: 'Partager'),
  survivre(title: 'Survivre'),
  creer(title: 'Créer'),
  evoluer(title: 'Évoluer'),
  modifier(title: 'Modifier'),
  apprendre(title: 'Apprendre'),
  provoquer(title: 'Provoquer'),
  harmoniser(title: 'Harmoniser'),
  ;

  final String title;

  const MotivationIdeal({ required this.title });
}

enum MotivationInterdit {
  tuer(title: 'Tuer'),
  trahir(title: 'Trahir'),
  abandonner(title: 'Abandonner'),
  mentir(title: 'Mentir'),
  detruire(title: 'Détruire'),
  corrompre(title: 'Corrompre'),
  voler(title: 'Voler'),
  fuir(title: 'Fuir'),
  renier(title: 'Renier'),
  faillir(title: 'Faillir'),
  ;

  final String title;

  const MotivationInterdit({ required this.title });
}

enum MotivationEpreuve {
  dilemme(title: 'Dilemme'),
  quete(title: 'Quête'),
  solitude(title: 'Solitude'),
  trahison(title: 'Trahison'),
  corruption(title: 'Corruption'),
  doute(title: 'Doute'),
  perte(title: 'Perte'),
  duel(title: 'Duel'),
  errance(title: 'Errance'),
  vengeance(title: 'Vengeance'),
  ;

  final String title;

  const MotivationEpreuve({ required this.title });
}

enum MotivationDestinee {
  triomphe(title: 'Triomphe'),
  sacrifice(title: 'Sacrifice'),
  rebellion(title: 'Rebellion'),
  illumination(title: 'Illumination'),
  obeissance(title: 'Obéissance'),
  echec(title: 'Échec'),
  malediction(title: 'Malédiction'),
  desillusion(title: 'Désillusion'),
  puissance(title: 'Puissance'),
  accomplissement(title: 'Accomplissement'),
  ;

  final String title;

  const MotivationDestinee({ required this.title });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class StarMotivations {
  StarMotivations({
    required this.vertu,
    required this.vertuValue,
    required this.penchant,
    required this.penchantValue,
    required this.ideal,
    required this.idealValue,
    required this.interdit,
    required this.interditValue,
    required this.epreuve,
    required this.epreuveValue,
    required this.destinee,
    required this.destineeValue,
  });

  StarMotivations.empty({
    this.vertu = MotivationVertu.loyaute,
    this.vertuValue = 0,
    this.penchant = MotivationPenchant.violence,
    this.penchantValue = 0,
    this.ideal = MotivationIdeal.decouvrir,
    this.idealValue = 0,
    this.interdit = MotivationInterdit.tuer,
    this.interditValue = 0,
    this.epreuve = MotivationEpreuve.dilemme,
    this.epreuveValue = 0,
    this.destinee = MotivationDestinee.triomphe,
    this.destineeValue = 0,
  });

  MotivationVertu vertu;
  int vertuValue;

  MotivationPenchant penchant;
  int penchantValue;

  MotivationIdeal ideal;
  int idealValue;

  MotivationInterdit interdit;
  int interditValue;

  MotivationEpreuve epreuve;
  int epreuveValue;

  MotivationDestinee destinee;
  int destineeValue;

  StarMotivations clone() => StarMotivations(
      vertu: vertu,
      vertuValue: vertuValue,
      penchant: penchant,
      penchantValue: penchantValue,
      ideal: ideal,
      idealValue: idealValue,
      interdit: interdit,
      interditValue: interditValue,
      epreuve: epreuve,
      epreuveValue: epreuveValue,
      destinee: destinee,
      destineeValue: destineeValue
    );

  factory StarMotivations.fromJson(Map<String, dynamic> json) =>
      _$StarMotivationsFromJson(json);

  Map<String, dynamic> toJson() =>
      _$StarMotivationsToJson(this);
}