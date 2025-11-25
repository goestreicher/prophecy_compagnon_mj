import 'entity/abilities.dart';

enum MagicSkill {
  instinctive(title: "Magie instinctive", ability: Ability.empathie),
  invocatoire(title: "Magie invocatoire", ability: Ability.perception),
  sorcellerie(title: "Sorcellerie", ability: Ability.intelligence);

  const MagicSkill({
    required this.title,
    required this.ability,
  });

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