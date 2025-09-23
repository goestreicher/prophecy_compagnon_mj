import 'package:json_annotation/json_annotation.dart';

import '../caste/base.dart';
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
  criDeLaPierre(title: "Cri de la Pierre (Mage de la Pierre)", family: SkillFamily.combat, reservedCastes: [Caste.mage]),
  creatureNaturalWeapon(title: "Arme naturelle pour les créatures", family: SkillFamily.combat, canInstantiate: false),

  // Mouvement
  acrobatie(title: "Acrobatie", family: SkillFamily.mouvement),
  athletisme(title: "Athlétisme", family: SkillFamily.mouvement),
  combatMonte(title: "Combat monté", family: SkillFamily.mouvement, reservedCastes: [Caste.combattant]),
  endurance(title: "Endurance", family: SkillFamily.mouvement, reservedCastes: [Caste.combattant]),
  equitation(title: "Équitation", family: SkillFamily.mouvement),
  escalade(title: "Escalade", family: SkillFamily.mouvement),
  esquive(title: "Esquive", family: SkillFamily.mouvement),
  natation(title: "Natation", family: SkillFamily.mouvement),
  torture(title: "Torture", family: SkillFamily.mouvement, reservedCastes: [Caste.combattant]),

  // Theorie
  anticipationDesOrages(title: "Anticipation des orages (Mage du Feu)", family: SkillFamily.theorie, reservedCastes: [Caste.mage]),
  castes(title: "Castes", family: SkillFamily.theorie),
  conception(title: "Conception", family: SkillFamily.theorie, reservedCastes: [Caste.artisan]),
  connaissanceDeLaMagie(title: "Connaissance de la magie", family: SkillFamily.theorie),
  connaissanceDesAnimaux(title: "Connaissance des animaux", family: SkillFamily.theorie),
  connaissanceDesDragons(title: "Connaissance des dragons", family: SkillFamily.theorie),
  connaissanceDeLaPierre(title: "Connaissance de la pierre (Mage de la Pierre)", family: SkillFamily.theorie, reservedCastes: [Caste.mage]),
  facture(title: "Facture (Mage du Métal)", family: SkillFamily.theorie, reservedCastes: [Caste.mage]),
  fauneEtFlore(title: "Faune et flore", family: SkillFamily.theorie, reservedCastes: [Caste.prodige]),
  geographie(title: "Géographie", family: SkillFamily.theorie),
  histoire(title: "Histoire", family: SkillFamily.theorie),
  interpretationDesReves(title: "Interprétation des rêves (Mage des Rêves)", family: SkillFamily.theorie, reservedCastes: [Caste.mage]),
  lois(title: "Lois", family: SkillFamily.theorie),
  necromancie(title: "Nécromancie (Mage de l'Ombre)", family: SkillFamily.theorie, reservedCastes: [Caste.mage]),
  orientation(title: "Orientation", family: SkillFamily.theorie),
  perceptionClimatique(title: "Perception climatique (Mage des Vents)", family: SkillFamily.theorie, reservedCastes: [Caste.mage]),
  strategie(title: "Stratégie", family: SkillFamily.theorie),

  // Pratique
  alchimie(title: "Alchimie", family: SkillFamily.pratique),
  analyse(title: "Analyse", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  astrologie(title: "Astrologie", family: SkillFamily.pratique),
  cartographie(title: "Cartographie", family: SkillFamily.pratique),
  cartographierLesReves(title: "Cartographier les rêves (Mage des Rêves ou de l'Ombre)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  chirurgie(title: "Chirurgie", family: SkillFamily.pratique),
  estimation(title: "Estimation", family: SkillFamily.pratique),
  explosifs(title: "Explosifs", family: SkillFamily.pratique),
  explosifsDeBrorne(title: "Explosifs de Brorne (Mage de la Pierre)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  herboristerie(title: "Herboristerie", family: SkillFamily.pratique),
  investigation(title: "Investigation", family: SkillFamily.pratique, reservedCastes: [Caste.protecteur]),
  jardinage(title: "Jardinage (Mage de la Nature)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  langageDesAnimaux(title: "Langage des animaux (Mage de la Nature)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  langageDesPlantes(title: "Langage des plantes (Mage de la Nature)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  lireEtEcrire(title: "Lire et écrire", family: SkillFamily.pratique),
  matieresPremieres(title: "Matières premières", family: SkillFamily.pratique),
  medecine(title: "Médecine", family: SkillFamily.pratique),
  meditation(title: "Méditation", family: SkillFamily.pratique, reservedCastes: [Caste.mage, Caste.prodige]),
  premiersSoins(title: "Premiers soins", family: SkillFamily.pratique),
  psychometrie(title: "Psychométrie", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  soinsOniriques(title: "Soins oniriques (Mage des Rêves)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  survie(title: "Survie", family: SkillFamily.pratique, requireSpecialization: true),
  toucheDePerfection(title: "Touche de perfection (Mage du Métal ou des Rêves)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  vieEnCite(title: "Vie en cité", family: SkillFamily.pratique),
  vieEnForet(title: "Vie en forêt", family: SkillFamily.pratique, reservedCastes: [Caste.prodige]),

  // Technique
  armesDeSiege(title: "Armes de siège", family: SkillFamily.technique),
  armesMecaniques(title: "Armes mécaniques", family: SkillFamily.technique),
  armure(title: "Armure", family: SkillFamily.technique, reservedCastes: [Caste.protecteur]),
  artisanat(title: "Artisanat", family: SkillFamily.technique, requireSpecialization: true),
  contrefacon(title: "Contrefaçon", family: SkillFamily.technique),
  discretion(title: "Discrétion", family: SkillFamily.technique),
  enchantement(title: "Enchantement", family: SkillFamily.technique, reservedCastes: [Caste.mage]),
  mecanismes(title: "Mécanismes", family: SkillFamily.technique),
  pieges(title: "Pièges", family: SkillFamily.technique),
  pister(title: "Pister", family: SkillFamily.technique),
  pyrotechnie(title: "Pyrotechnie (Mage du Feu)", family: SkillFamily.technique, reservedCastes: [Caste.mage]),
  reparation(title: "Réparation", family: SkillFamily.technique, reservedCastes: [Caste.combattant]),
  sabotage(title: "Sabotage", family: SkillFamily.technique, reservedCastes: [Caste.artisan]),

  // Manipulation
  armesAProjectiles(title: "Armes à projectiles", family: SkillFamily.manipulation),
  attelages(title: "Attelages", family: SkillFamily.manipulation),
  deguisement(title: "Déguisement", family: SkillFamily.manipulation),
  deverrouillage(title: "Déverrouillage", family: SkillFamily.manipulation),
  donArtistique(title: "Don artistique", family: SkillFamily.manipulation, requireSpecialization: true),
  faireLesPoches(title: "Faire les poches", family: SkillFamily.manipulation),
  imitation(title: "Imitation (Mage des Cités)", family: SkillFamily.manipulation, reservedCastes: [Caste.mage]),
  jeu(title: "Jeu", family: SkillFamily.manipulation),
  jongler(title: "Jongler", family: SkillFamily.manipulation),
  magnetisme(title: "Magnétisme (Mage du Métal)", family: SkillFamily.manipulation, reservedCastes: [Caste.mage]),
  manipulationDesPierresIrradiantes(title: "Manipulation des pierres irradiantes (Mage de la Pierre)", family: SkillFamily.manipulation, reservedCastes: [Caste.mage]),
  maitriseDesIncendies(title: "Maîtrise des incendies", family: SkillFamily.manipulation, reservedCastes: [Caste.mage]),

  // Communication
  baratin(title: "Baratin", family: SkillFamily.communication),
  ceremonie(title: "Cérémonie (Mage des Océans)", family: SkillFamily.communication, reservedCastes: [Caste.mage]),
  conte(title: "Conte", family: SkillFamily.communication),
  eloquence(title: "Éloquence", family: SkillFamily.communication),
  marchandage(title: "Marchandage", family: SkillFamily.communication),
  psychologie(title: "Psychologie", family: SkillFamily.communication),

  // Influence
  artDeLaScene(title: "Art de la scène", family: SkillFamily.influence, requireSpecialization: true),
  chantsOniriques(title: "Chants oniriques (Mage des Rêves)", family: SkillFamily.influence, reservedCastes: [Caste.mage]),
  commandement(title: "Commandement", family: SkillFamily.influence),
  diplomatie(title: "Diplomatie", family: SkillFamily.influence),
  domination(title: "Domination (Mage de l'Ombre)", family: SkillFamily.influence, reservedCastes: [Caste.mage]),
  dressage(title: "Dressage", family: SkillFamily.influence),
  interrogatoire(title: "Interrogatoire", family: SkillFamily.influence, reservedCastes: [Caste.protecteur]),
  intimidation(title: "Intimidation", family: SkillFamily.influence),
  seduction(title: "Séduction", family: SkillFamily.influence),
  ;

  const Skill({
    required this.title,
    required this.family,
    this.requireSpecialization = false,
    this.canInstantiate = true,
    this.reservedCastes = const <Caste>[],
  });

  static List<Skill> fromFamily(SkillFamily family, {Caste? forCaste}) {
    List<Skill> ret = <Skill>[];
    for(var s in Skill.values) {
      if(
          s.family == family
          && (
              forCaste == null
              || s.reservedCastes.isEmpty
              || s.reservedCastes.contains(forCaste)
          )
      ) {
        ret.add(s);
      }
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
  final List<Caste> reservedCastes;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class SpecializedSkill {
  factory SpecializedSkill(String name) {
    _initializeGlobalSpecializedSkills();
    if(_instances.containsKey(name)) {
      return _instances[name]!;
    }
    throw UnsupportedError('No such skill $name');
  }

  factory SpecializedSkill.create(
      String name,
      Skill parent,
      {
        required String title,
        bool reserved = false,
        List<Caste> reservedCastes = const <Caste>[],
      }
    ) {
    _initializeGlobalSpecializedSkills();

    if(_instances.containsKey(name)) {
      return _instances[name]!;
    }

    SpecializedSkill s = SpecializedSkill._internal(
      name,
      parent,
      title: title,
      reserved: reserved,
      reservedCastes: reservedCastes,
    );

    _instances[name] = s;
    return s;
  }

  static List<SpecializedSkill> withParent(
      Skill parent,
      {
        includeReserved = false,
        Caste? includeForCaste
      }
    ) {
    _initializeGlobalSpecializedSkills();
    return _instances.values
      .where(
        (SpecializedSkill s) => (
            (!s.reserved || includeReserved) && s.parent == parent)
            && (includeForCaste == null || s.reservedCastes.contains(includeForCaste))
      )
      .toList();
  }

  static bool exists(String name) {
    _initializeGlobalSpecializedSkills();
    return _instances.containsKey(name);
  }

  static SpecializedSkill? byName(String name) {
    _initializeGlobalSpecializedSkills();
    return _instances[name];
  }

  static SpecializedSkill? byTitle(Skill parent, String description, { includeReserved = false }) {
    _initializeGlobalSpecializedSkills();
    SpecializedSkill? ret;
    for(SpecializedSkill sp in _instances.values) {
      if((!sp.reserved || includeReserved) && sp.parent == parent && sp.title == description) {
        ret = sp;
      }
    }
    return ret;
  }

  SpecializedSkill._internal(
    this.name,
    this.parent,
    {
      required this.title,
      this.reserved = false,
      this.reservedCastes = const <Caste>[],
    }
  );

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
  List<Caste> reservedCastes;

  static final Map<String, SpecializedSkill> _instances = <String, SpecializedSkill>{};
  static bool _globalSpecializedSkillsInitialized = false;

  static void _initializeGlobalSpecializedSkills() {
    if(SpecializedSkill._globalSpecializedSkillsInitialized) return;
    SpecializedSkill._globalSpecializedSkillsInitialized = true;

    // TODO: add useful and known specializations here
    // ignore:unused_local_variable
    var s = SpecializedSkill.create(
      'artisanat:artisanatElementaire',
      Skill.artisanat,
      title: "Artisanat élémentaire",
      reservedCastes: [Caste.artisan],
    );

    s = SpecializedSkill.create(
      'vieEnCite:marcheNoir',
      Skill.vieEnCite,
      title: "Marché noir",
      reservedCastes: [Caste.commercant],
    );

    s = SpecializedSkill.create(
      'esquive:repli',
      Skill.esquive,
      title: "Repli",
      reservedCastes: [Caste.commercant],
    );

    s = SpecializedSkill.create(
      'deguisement:usurpation',
      Skill.deguisement,
      title: "Usurpation",
      reservedCastes: [Caste.commercant],
    );

    s = SpecializedSkill.create(
      'vieEnCite:instinctCitadin',
      Skill.vieEnCite,
      title: "Instinct citadin (Mage des Cités)",
      reservedCastes: [Caste.mage],
    );

    s = SpecializedSkill.create(
      'lireEtEcrire:cryptographie',
      Skill.lireEtEcrire,
      title: "Cryptographie",
      reservedCastes: [Caste.erudit],
    );

    s = SpecializedSkill.create(
      'artisanat:ingenierieNavale',
      Skill.artisanat,
      title: "Ingénierie navale",
      reservedCastes: [Caste.erudit],
    );

    s = SpecializedSkill.create(
      'orientation:navigation',
      Skill.orientation,
      title: "Navigation",
      reservedCastes: [Caste.erudit],
    );

    s = SpecializedSkill.create(
      'diplomatie:ambassadeMaritime',
      Skill.diplomatie,
      title: "Ambassade maritime (Mage des Océans)",
      reservedCastes: [Caste.mage],
    );

    s = SpecializedSkill.create(
      'medecine:medecineAnimale',
      Skill.medecine,
      title: "Médecine animale",
      reservedCastes: [Caste.prodige],
    );

    s = SpecializedSkill.create(
      'medecine:medecineDeHeyra',
      Skill.medecine,
      title: "Médecine de Heyra (Mage de la Nature)",
      reservedCastes: [Caste.mage],
    );

    s = SpecializedSkill.create(
      'strategie:manoeuvre',
      Skill.strategie,
      title: "Manœuvre",
      reservedCastes: [Caste.protecteur],
    );

    s = SpecializedSkill.create(
      'discretion:camouflage',
      Skill.discretion,
      title: "Camouflage",
      reservedCastes: [Caste.voyageur],
    );

    s = SpecializedSkill.create(
      'equitation:tirMonte',
      Skill.equitation,
      title: "Tir monté",
      reservedCastes: [Caste.voyageur],
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
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
