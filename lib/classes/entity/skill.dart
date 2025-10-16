import '../caste/base.dart';
import 'skill_family.dart';

enum Skill {
  // Combat
  armesArticulees(name: "Armes articulées", family: SkillFamily.combat),
  armesContondantes(name: "Armes contondantes", family: SkillFamily.combat),
  armesDeChoc(name: "Armes de choc", family: SkillFamily.combat),
  armesDeJet(name: "Armes de jet", family: SkillFamily.combat),
  armesDoubles(name: "Armes doubles", family: SkillFamily.combat),
  armesDHast(name: "Armes d'hast", family: SkillFamily.combat),
  armesTranchantes(name: "Armes tranchantes", family: SkillFamily.combat),
  bouclier(name: "Bouclier", family: SkillFamily.combat),
  corpsACorps(name: "Corps à corps", family: SkillFamily.combat),
  criDeLaPierre(name: "Cri de la Pierre (Mage de la Pierre)", family: SkillFamily.combat, reservedCastes: [Caste.mage]),
  creatureNaturalWeapon(name: "Arme naturelle pour les créatures", family: SkillFamily.combat, canInstantiate: false),

  // Mouvement
  acrobatie(name: "Acrobatie", family: SkillFamily.mouvement),
  athletisme(name: "Athlétisme", family: SkillFamily.mouvement),
  combatMonte(name: "Combat monté", family: SkillFamily.mouvement, reservedCastes: [Caste.combattant]),
  endurance(name: "Endurance", family: SkillFamily.mouvement, reservedCastes: [Caste.combattant]),
  equitation(name: "Équitation", family: SkillFamily.mouvement),
  escalade(name: "Escalade", family: SkillFamily.mouvement),
  esquive(name: "Esquive", family: SkillFamily.mouvement),
  natation(name: "Natation", family: SkillFamily.mouvement),
  torture(name: "Torture", family: SkillFamily.mouvement, reservedCastes: [Caste.combattant]),

  // Theorie
  anticipationDesOrages(name: "Anticipation des orages (Mage du Feu)", family: SkillFamily.theorie, reservedCastes: [Caste.mage]),
  castes(name: "Castes", family: SkillFamily.theorie),
  conception(name: "Conception", family: SkillFamily.theorie, reservedCastes: [Caste.artisan]),
  connaissanceDeLaMagie(name: "Connaissance de la magie", family: SkillFamily.theorie),
  connaissanceDesAnimaux(name: "Connaissance des animaux", family: SkillFamily.theorie),
  connaissanceDesDragons(name: "Connaissance des dragons", family: SkillFamily.theorie),
  connaissanceDeLaPierre(name: "Connaissance de la pierre (Mage de la Pierre)", family: SkillFamily.theorie, reservedCastes: [Caste.mage]),
  facture(name: "Facture (Mage du Métal)", family: SkillFamily.theorie, reservedCastes: [Caste.mage]),
  fauneEtFlore(name: "Faune et flore", family: SkillFamily.theorie, reservedCastes: [Caste.prodige]),
  geographie(name: "Géographie", family: SkillFamily.theorie),
  histoire(name: "Histoire", family: SkillFamily.theorie),
  interpretationDesReves(name: "Interprétation des rêves (Mage des Rêves)", family: SkillFamily.theorie, reservedCastes: [Caste.mage]),
  lois(name: "Lois", family: SkillFamily.theorie),
  necromancie(name: "Nécromancie (Mage de l'Ombre)", family: SkillFamily.theorie, reservedCastes: [Caste.mage]),
  orientation(name: "Orientation", family: SkillFamily.theorie),
  perceptionClimatique(name: "Perception climatique (Mage des Vents)", family: SkillFamily.theorie, reservedCastes: [Caste.mage]),
  strategie(name: "Stratégie", family: SkillFamily.theorie),

  // Pratique
  alchimie(name: "Alchimie", family: SkillFamily.pratique),
  analyse(name: "Analyse", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  astrologie(name: "Astrologie", family: SkillFamily.pratique),
  cartographie(name: "Cartographie", family: SkillFamily.pratique),
  cartographierLesReves(name: "Cartographier les rêves (Mage des Rêves ou de l'Ombre)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  chirurgie(name: "Chirurgie", family: SkillFamily.pratique),
  estimation(name: "Estimation", family: SkillFamily.pratique),
  explosifs(name: "Explosifs", family: SkillFamily.pratique),
  explosifsDeBrorne(name: "Explosifs de Brorne (Mage de la Pierre)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  herboristerie(name: "Herboristerie", family: SkillFamily.pratique),
  investigation(name: "Investigation", family: SkillFamily.pratique, reservedCastes: [Caste.protecteur]),
  jardinage(name: "Jardinage (Mage de la Nature)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  langageDesAnimaux(name: "Langage des animaux (Mage de la Nature)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  langageDesPlantes(name: "Langage des plantes (Mage de la Nature)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  langueDesSignes(name: "Langue des signes", family: SkillFamily.pratique),
  lireEtEcrire(name: "Lire et écrire", family: SkillFamily.pratique),
  matieresPremieres(name: "Matières premières", family: SkillFamily.pratique),
  medecine(name: "Médecine", family: SkillFamily.pratique),
  meditation(name: "Méditation", family: SkillFamily.pratique, reservedCastes: [Caste.mage, Caste.prodige]),
  premiersSoins(name: "Premiers soins", family: SkillFamily.pratique),
  psychometrie(name: "Psychométrie", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  soinsOniriques(name: "Soins oniriques (Mage des Rêves)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  survie(name: "Survie", family: SkillFamily.pratique, requireSpecialization: true),
  toucheDePerfection(name: "Touche de perfection (Mage du Métal ou des Rêves)", family: SkillFamily.pratique, reservedCastes: [Caste.mage]),
  vieEnCite(name: "Vie en cité", family: SkillFamily.pratique),
  vieEnForet(name: "Vie en forêt", family: SkillFamily.pratique, reservedCastes: [Caste.prodige]),

  // Technique
  armesDeSiege(name: "Armes de siège", family: SkillFamily.technique),
  armesMecaniques(name: "Armes mécaniques", family: SkillFamily.technique),
  armure(name: "Armure", family: SkillFamily.technique, reservedCastes: [Caste.protecteur]),
  artisanat(name: "Artisanat", family: SkillFamily.technique, requireSpecialization: true),
  contrefacon(name: "Contrefaçon", family: SkillFamily.technique),
  discretion(name: "Discrétion", family: SkillFamily.technique),
  enchantement(name: "Enchantement", family: SkillFamily.technique, reservedCastes: [Caste.mage]),
  mecanismes(name: "Mécanismes", family: SkillFamily.technique),
  pieges(name: "Pièges", family: SkillFamily.technique),
  pister(name: "Pister", family: SkillFamily.technique),
  pyrotechnie(name: "Pyrotechnie (Mage du Feu)", family: SkillFamily.technique, reservedCastes: [Caste.mage]),
  reparation(name: "Réparation", family: SkillFamily.technique, reservedCastes: [Caste.combattant]),
  sabotage(name: "Sabotage", family: SkillFamily.technique, reservedCastes: [Caste.artisan]),

  // Manipulation
  armesAProjectiles(name: "Armes à projectiles", family: SkillFamily.manipulation),
  attelages(name: "Attelages", family: SkillFamily.manipulation),
  deguisement(name: "Déguisement", family: SkillFamily.manipulation),
  deverrouillage(name: "Déverrouillage", family: SkillFamily.manipulation),
  donArtistique(name: "Don artistique", family: SkillFamily.manipulation, requireSpecialization: true),
  faireLesPoches(name: "Faire les poches", family: SkillFamily.manipulation),
  imitation(name: "Imitation (Mage des Cités)", family: SkillFamily.manipulation, reservedCastes: [Caste.mage]),
  jeu(name: "Jeu", family: SkillFamily.manipulation),
  jongler(name: "Jongler", family: SkillFamily.manipulation),
  magnetisme(name: "Magnétisme (Mage du Métal)", family: SkillFamily.manipulation, reservedCastes: [Caste.mage]),
  manipulationDesPierresIrradiantes(name: "Manipulation des pierres irradiantes (Mage de la Pierre)", family: SkillFamily.manipulation, reservedCastes: [Caste.mage]),
  maitriseDesIncendies(name: "Maîtrise des incendies", family: SkillFamily.manipulation, reservedCastes: [Caste.mage]),

  // Communication
  baratin(name: "Baratin", family: SkillFamily.communication),
  ceremonie(name: "Cérémonie (Mage des Océans)", family: SkillFamily.communication, reservedCastes: [Caste.mage]),
  conte(name: "Conte", family: SkillFamily.communication),
  eloquence(name: "Éloquence", family: SkillFamily.communication),
  marchandage(name: "Marchandage", family: SkillFamily.communication),
  psychologie(name: "Psychologie", family: SkillFamily.communication),

  // Influence
  artDeLaScene(name: "Art de la scène", family: SkillFamily.influence, requireSpecialization: true),
  chantsOniriques(name: "Chants oniriques (Mage des Rêves)", family: SkillFamily.influence, reservedCastes: [Caste.mage]),
  commandement(name: "Commandement", family: SkillFamily.influence),
  diplomatie(name: "Diplomatie", family: SkillFamily.influence),
  domination(name: "Domination (Mage de l'Ombre)", family: SkillFamily.influence, reservedCastes: [Caste.mage]),
  dressage(name: "Dressage", family: SkillFamily.influence),
  enseignement(name: "Enseignement", family: SkillFamily.influence),
  interrogatoire(name: "Interrogatoire", family: SkillFamily.influence, reservedCastes: [Caste.protecteur]),
  intimidation(name: "Intimidation", family: SkillFamily.influence),
  seduction(name: "Séduction", family: SkillFamily.influence),
  ;

  const Skill({
    required this.name,
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

  static Skill? byName(String descr) {
    Skill? ret;
    for(var s in Skill.values) {
      if(s.name == descr) ret = s;
    }
    return ret;
  }

  final String name;
  final SkillFamily family;
  final bool requireSpecialization;
  final bool canInstantiate;
  final List<Caste> reservedCastes;
}