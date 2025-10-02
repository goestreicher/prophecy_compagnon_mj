enum WeaponRange {
  contact(title: 'Corps-à-corps'),
  melee(title: 'Mêlée'),
  distance(title: 'Éloigné'),
  ranged(title: 'À distance'),
  ;

  final String title;

  const WeaponRange({ required this.title });
}