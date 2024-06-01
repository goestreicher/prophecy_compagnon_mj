import 'package:json_annotation/json_annotation.dart';

import 'base.dart';

part 'skill.g.dart';

enum SkillFamily {
  combat(title: "Combat",
      defaultAttribute: Attribute.physique),
  mouvement(title: "Mouvement",
      defaultAttribute: Attribute.physique),
  theorie(title: "Théorie",
      defaultAttribute: Attribute.mental),
  pratique(title: "Pratique",
      defaultAttribute: Attribute.mental),
  technique(title: "Technique",
      defaultAttribute: Attribute.manuel),
  manipulation(title: "Manipulation",
      defaultAttribute: Attribute.manuel),
  communication(title: "Communication",
      defaultAttribute: Attribute.social),
  influence(title: "Influence",
      defaultAttribute: Attribute.social);

  const SkillFamily({
    required this.title,
    required this.defaultAttribute,
  });

  final String title;
  final Attribute defaultAttribute;
}

enum Skill {
  // Combat
  armesArticulees(title: "Armes articulées", family: SkillFamily.combat),
  armesContondantes(title: "Armes contondantes", family: SkillFamily.combat),
  armesDeChoc(title: "Armes de choc", family: SkillFamily.combat),
  armesDeJet(title: "Armes de jet", family: SkillFamily.combat),
  armesDoubles(title: "Armes doubles", family: SkillFamily.combat),
  armesDHast(title: "Armes d'hast", family: SkillFamily.combat),
  armesTranchantes(title: "Armes tranchantes", family: SkillFamily.combat),
  bouclier(title: "Bouclier", family: SkillFamily.combat),
  corpsACorps(title: "Corps à corps", family: SkillFamily.combat),
  creatureNaturalWeapon(title: "Arme naturelle pour les créatures", family: SkillFamily.combat, canInstantiate: false),

  // Mouvement
  acrobatie(title: "Acrobatie", family: SkillFamily.mouvement),
  athletisme(title: "Athlétisme", family: SkillFamily.mouvement),
  equitation(title: "Équitation", family: SkillFamily.mouvement),
  escalade(title: "Escalade", family: SkillFamily.mouvement),
  esquive(title: "Esquive", family: SkillFamily.mouvement),
  natation(title: "Natation", family: SkillFamily.mouvement),

  // Theorie
  castes(title: "Castes", family: SkillFamily.theorie),
  connaissanceDeLaMagie(title: "Connaissance de la magie", family: SkillFamily.theorie),
  connaissanceDesAnimaux(title: "Connaissance des animaux", family: SkillFamily.theorie),
  connaissanceDesDragons(title: "Connaissance des dragons", family: SkillFamily.theorie),
  geographie(title: "Géographie", family: SkillFamily.theorie),
  histoire(title: "Histoire", family: SkillFamily.theorie),
  lois(title: "Lois", family: SkillFamily.theorie),
  orientation(title: "Orientation", family: SkillFamily.theorie),
  strategie(title: "Stratégie", family: SkillFamily.theorie),

  // Pratique
  alchimie(title: "Alchimie", family: SkillFamily.pratique),
  astrologie(title: "Astrologie", family: SkillFamily.pratique),
  cartographie(title: "Cartographie", family: SkillFamily.pratique),
  estimation(title: "Estimation", family: SkillFamily.pratique),
  herboristerie(title: "Herboristerie", family: SkillFamily.pratique),
  lireEtEcrire(title: "Lire et écrire", family: SkillFamily.pratique),
  matieresPremieres(title: "Matières premières", family: SkillFamily.pratique),
  medecine(title: "Médecine", family: SkillFamily.pratique),
  premiersSoins(title: "Premiers soins", family: SkillFamily.pratique),
  survie(title: "Survie", family: SkillFamily.pratique, requireSpecialization: true),
  vieEnCite(title: "Vie en cité", family: SkillFamily.pratique),

  // Technique
  armesDeSiege(title: "Armes de siège", family: SkillFamily.technique),
  artisanat(title: "Artisanat", family: SkillFamily.technique, requireSpecialization: true),
  contrefacon(title: "Contrefaçon", family: SkillFamily.technique),
  discretion(title: "Discrétion", family: SkillFamily.technique),
  pieges(title: "Pièges", family: SkillFamily.technique),
  pister(title: "Pister", family: SkillFamily.technique),

  // Manipulation
  armesAProjectiles(title: "Armes à projectiles", family: SkillFamily.manipulation),
  attelages(title: "Attelages", family: SkillFamily.manipulation),
  deguisement(title: "Déguisement", family: SkillFamily.manipulation),
  deverrouillage(title: "Déverrouillage", family: SkillFamily.manipulation),
  donArtistique(title: "Don artistique", family: SkillFamily.manipulation, requireSpecialization: true),
  faireLesPoches(title: "Faire les poches", family: SkillFamily.manipulation),
  jeu(title: "Jeu", family: SkillFamily.manipulation),
  jongler(title: "Jongler", family: SkillFamily.manipulation),

  // Communication
  baratin(title: "Baratin", family: SkillFamily.communication),
  conte(title: "Conte", family: SkillFamily.communication),
  eloquence(title: "Éloquence", family: SkillFamily.communication),
  marchandage(title: "Marchandage", family: SkillFamily.communication),
  psychologie(title: "Psychologie", family: SkillFamily.communication),

  // Influence
  artDeLaScene(title: "Art de la scène", family: SkillFamily.influence, requireSpecialization: true),
  commandement(title: "Commandement", family: SkillFamily.influence),
  diplomatie(title: "Diplomatie", family: SkillFamily.influence),
  dressage(title: "Dressage", family: SkillFamily.influence),
  intimidation(title: "Intimidation", family: SkillFamily.influence),
  seduction(title: "Séduction", family: SkillFamily.influence),
  ;

  const Skill({
    required this.title,
    required this.family,
    this.requireSpecialization = false,
    this.canInstantiate = true,
  });

  static List<Skill> fromFamily(SkillFamily family) {
    List<Skill> ret = <Skill>[];
    for(var s in Skill.values) {
      if(s.family == family) ret.add(s);
    }
    return ret;
  }

  static Skill? byTitle(String descr) {
    Skill? ret;
    for(var s in Skill.values) {
      if(s.title == descr) ret = s;
    }
    return ret;
  }

  final String title;
  final SkillFamily family;
  final bool requireSpecialization;
  final bool canInstantiate;
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SpecializedSkill {
  factory SpecializedSkill(String name) {
    _initializeGlobalSpecializedSkills();
    if(_instances.containsKey(name)) {
      return _instances[name]!;
    }
    throw UnsupportedError('No such skill $name');
  }

  factory SpecializedSkill.create(String name, Skill parent, { required String title, bool reserved = false }) {
    _initializeGlobalSpecializedSkills();
    if(_instances.containsKey(name)) {
      return _instances[name]!;
    }
    SpecializedSkill s = SpecializedSkill._internal(name, parent, title: title, reserved: reserved);
    _instances[name] = s;
    return s;
  }

  static List<SpecializedSkill> withParent(Skill parent, { includeReserved = false }) {
    _initializeGlobalSpecializedSkills();
    return _instances.values
      .where((SpecializedSkill s) => (!s.reserved || includeReserved) && s.parent == parent)
      .toList();
  }

  static bool exists(String name) => _instances.containsKey(name);

  static SpecializedSkill? byName(String name) => _instances[name];

  static SpecializedSkill? byTitle(Skill parent, String description, { includeReserved = false }) {
    SpecializedSkill? ret;
    for(SpecializedSkill sp in _instances.values) {
      if((!sp.reserved || includeReserved) && sp.parent == parent && sp.title == description) {
        ret = sp;
      }
    }
    return ret;
  }

  SpecializedSkill._internal(this.name, this.parent, { required this.title, this.reserved = false });

  Map<String, dynamic> toJson() => _$SpecializedSkillToJson(this);
  factory SpecializedSkill.fromJson(Map<String, dynamic> json) => _$SpecializedSkillFromJson(json);

  @override
  bool operator==(Object other) =>
      other is SpecializedSkill && name == other.name;

  @override
  int get hashCode => name.hashCode;

  final String name;
  final String title;
  final Skill parent;
  bool reserved;

  static final Map<String, SpecializedSkill> _instances = <String, SpecializedSkill>{};
  static bool _globalSpecializedSkillsInitialized = false;

  static void _initializeGlobalSpecializedSkills() {
    if(SpecializedSkill._globalSpecializedSkillsInitialized) return;
    SpecializedSkill._globalSpecializedSkillsInitialized = true;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class SkillInstance {
  SkillInstance({
    required this.skill,
    required this.value,
    Map<SpecializedSkill, int>? specializations,
  })
    : specializations = specializations ?? <SpecializedSkill, int>{};

  final Skill skill;
  int value;
  @JsonKey(includeToJson: false, includeFromJson: false)
    final Map<SpecializedSkill, int> specializations;

  factory SkillInstance.fromJson(Map<String, dynamic> json) {
    var instance = _$SkillInstanceFromJson(json);
    if(json.containsKey('specializations') && json['specializations'] is List) {
      for(Map<String, dynamic> spec in json['specializations']) {
        var sp = SpecializedSkill.create(
          spec['name'],
          instance.skill,
          title: spec['title'],
          reserved: spec['reserved'],
        );

        instance.specializations[sp] = spec['value'];
      }
    }
    return instance;
  }

  Map<String, dynamic> toJson() {
    var ret = _$SkillInstanceToJson(this);
    if(specializations.isNotEmpty) {
      ret['specializations'] = <Map<String, dynamic>>[];
      for(var sp in specializations.keys) {
        ret['specializations'].add(<String, dynamic>{
          'name': sp.name,
          'title': sp.title,
          'value': specializations[sp]!,
          'reserved': sp.reserved,
        });
      }
    }
    return ret;
  }
}
