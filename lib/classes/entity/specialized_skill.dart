import 'package:json_annotation/json_annotation.dart';

import '../../text_utils.dart';
import '../caste/base.dart';
import 'skill.dart';

part 'specialized_skill.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, constructor: 'create')
class SpecializedSkill {
  factory SpecializedSkill(String id) {
    _initializeGlobalSpecializedSkills();
    if(_instances.containsKey(id)) {
      return _instances[id]!;
    }
    throw UnsupportedError('No such skill $id');
  }

  factory SpecializedSkill.create({
    required Skill parent,
    String? parentImplementation,
    required String name,
    String description = '',
    bool reserved = false,
    String? reservedPrefix,
    List<Caste> reservedCastes = const <Caste>[],
  }) {
    _initializeGlobalSpecializedSkills();

    var cId = _getId(parent, name, reserved: reserved, reservedPrefix: reservedPrefix);
    if(_instances.containsKey(cId)) {
      return _instances[cId]!;
    }

    SpecializedSkill s = SpecializedSkill._internal(
      parent: parent,
      parentImplementation: parentImplementation,
      name: name,
      description: description,
      reserved: reserved,
      reservedPrefix: reservedPrefix,
      reservedCastes: reservedCastes,
    );

    _instances[cId] = s;
    return s;
  }

  SpecializedSkill cloneWithReservedPrefix({
    required String reservedPrefix,
  }) => SpecializedSkill.create(
      parent: parent,
      parentImplementation: parentImplementation,
      name: name,
      description: description,
      reserved: true,
      reservedPrefix: reservedPrefix,
      reservedCastes: reservedCastes,
    );

  SpecializedSkill._internal({
    required this.parent,
    this.parentImplementation,
    required this.name,
    this.description = '',
    this.reserved = false,
    this.reservedPrefix,
    this.reservedCastes = const <Caste>[],
  });

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

  static bool exists(String id) {
    _initializeGlobalSpecializedSkills();
    return _instances.containsKey(id);
  }

  static SpecializedSkill? byId(String id) {
    _initializeGlobalSpecializedSkills();
    return _instances[id];
  }

  static SpecializedSkill? byName(Skill parent, String name, { includeReserved = false }) {
    _initializeGlobalSpecializedSkills();
    SpecializedSkill? ret;
    for(SpecializedSkill sp in _instances.values) {
      if((!sp.reserved || includeReserved) && sp.parent == parent && sp.name == name) {
        ret = sp;
      }
    }
    return ret;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get id => _getId(parent, name, reserved: reserved, reservedPrefix: reservedPrefix);
  final Skill parent;
  final String? parentImplementation;
  final String name;
  final String description;
  bool reserved;
  String? reservedPrefix;
  List<Caste> reservedCastes;

  static final Map<String, SpecializedSkill> _instances = <String, SpecializedSkill>{};
  static bool _globalSpecializedSkillsInitialized = false;

  static String _getId(Skill parent, String name, { bool reserved = false, String? reservedPrefix }) =>
      '${reserved ? "reserved:" : ""}${reservedPrefix ?? ""}${parent.toString()}:${sentenceToCamelCase(transliterateFrenchToAscii(name))}';

  static void _initializeGlobalSpecializedSkills() {
    if(SpecializedSkill._globalSpecializedSkillsInitialized) return;
    SpecializedSkill._globalSpecializedSkillsInitialized = true;

    // TODO: add useful and known specializations here
    // ignore:unused_local_variable
    var s = SpecializedSkill.create(
      parent: Skill.vieEnCite,
      name: "Marché noir",
      reservedCastes: [Caste.commercant],
      description: "Cette spécialisation est réservée aux commerçants.\nPermet au personnage de connaître et d'utiliser les contacts nécessaires pour se procurer des substances et des marchandises interdites par les Lois draconiques en vigueur. La Difficulté du jet est déterminée par la rareté de l'objet convoité, au choix du meneur de jeu."
    );

    s = SpecializedSkill.create(
      parent: Skill.esquive,
      name: "Repli",
      reservedCastes: [Caste.commercant],
      description: "Cette spécialisation est réservée aux commerçants.\nPermet au personnage d'effectuer une manœuvre désespérée lors d'un combat, d'une attaque, et d'éviter un coup tout en se jetant hors de portée du prochain. Lors d’un jet d’Esquive, le personnage peut dépenser des actions encore non effectuées pour obtenir un bonus de +5 à son esquive par action dépensée."
    );

    s = SpecializedSkill.create(
      parent: Skill.vieEnCite,
      name: "Instinct citadin",
      reservedCastes: [Caste.mage],
      description: "Cette spécialisation est réservée aux Mages des Cités.\nVie en Cité permet de s'adapter à la vie urbaine. Instinct citadin permet d'envisager dans sa globalité une ville sans l'avoir jamais visitée. Cela permet de trouver la bonne ruelle pour s'échapper, de repérer la bonne auberge pour trouver des renseignements et de jauger d'un coup d'œil un interlocuteur que l'on rencontre pour la première fois."
    );

    s = SpecializedSkill.create(
      parent: Skill.lireEtEcrire,
      name: "Cryptographie",
      reservedCastes: [Caste.erudit],
      description: "Cette spécialisation est réservée aux érudits.\nPermet au personnaige de connaître, reconnaître, tracer et combiner les symboles écrits utilisés dans nombre de dialectes, langages occultes ou formules magiques. Un jet de Mental + Cryptographie contre une Difficulté variant de 15 à 30 permettra de déchiffrer, tandis qu'un jet de Manuel + Cryptographie permettra, s'il est réussi contre une Difficulté allant de 20 à 30, de recpoier, dissocier ou isoler certains symbole ou écrits cryptés."
    );

    s = SpecializedSkill.create(
      parent: Skill.artisanat,
      name: "Ingénierie navale",
      reservedCastes: [Caste.erudit],
      description: "Cette spécialisation est réservée aux érudits.\nPermet au personnage de disposer des connaissance spécifique et techniques relatives à l'architecture, la construction, la charpente et tous les aspects de la construction de bateaux et d'éléments de navigation. Telle qu'elle est enseignée aux érudits, et utilisée avec l'Attribut Mental, cette Compétence permet de dessiner des plans, de concevoir des structures et de fournir les indications destinées aux artisans."
    );

    s = SpecializedSkill.create(
      parent: Skill.orientation,
      name: "Navigation",
      reservedCastes: [Caste.erudit],
      description: "Cette spécialisation est réservée aux érudits.\nPermet au personnage d'utiliser des cartes, inrtuments de mesure et de repères en vue de sorienter en mer. La Difficulté du jet de base est susceptible d'être augmentée par les conditions climatiques, qui peuvent masquer les côtes ou les rives, et peut être réduite si le personnage bénéficie de soutiens magiques. La technique est radicalement différente de celle des astronomes, qui se repèrent aux étoiles, alors que les érudits utilisent les éléments rocheux, les cartes géographiques et les signes envoyés, dit-on, par les enfants d'Ozyr."
    );

    s = SpecializedSkill.create(
      parent: Skill.diplomatie,
      name: "Ambassade maritime",
      reservedCastes: [Caste.mage],
      description: "Cette spécialisation est réservée aux Mages des Océans.\nCette Compétence permet de repérer les signes de reconnaissance et d'avoir une idée approximative des dragons des océans célèbres qui vivent le long des côtes de Kor. Le mage n'est pas spécialement connu des dragons en question, mais il sait leur nom, âge approximatif et traits de caractère principaux. Il peut alors se porter garant des navires sur lesquels il se trouve pour faciliter leur passage et leur voyage en général. Le mage connaît un dragon par point dans cette Compétence, dont le niveau ne peut excéder deux fois celui de la Compétence Connaissance des dragons."
    );

    s = SpecializedSkill.create(
      parent: Skill.medecine,
      name: "Médecine animale",
      reservedCastes: [Caste.prodige],
      description: "Cette spécialisation est réservée aux Prodiges.\nPermet au personnage de pratiquer la médecin sur des animaux et des créatures vivantes. Pour soigner, il faut appliquer les mêmes règles que pour un humain. Avec cette Compétence, il est également possible de connaître les parties intéressantes d'un animal fraîchement tué (glandes, etc.), de procéder au prélèvement d'un organe ou de pratiquer un diagnostic précis."
    );

    s = SpecializedSkill.create(
      parent: Skill.strategie,
      name: "Manœuvre",
      reservedCastes: [Caste.protecteur],
      description: "Cette spécialisation est réservée aux protecteurs.\nPermet de diriger et de coordonner les actions d’un petit groupe d’hommes, en vue d’opérer une manœuvre militaire, un mouvement, une charge, une retraite, etc. Le nombre d’hommes maximum que peut englober cette manœuvre ne peut excéder 3 + le niveau de Compétence du personnage - lui compris. Le jet de Mental + Manœuvre s’effectue contre une Difficulté de 15, augmentée de 5 pour une action véritablement complexe, et confère un bonus de 1 + 1 par Niveau de Réussite à toutes les actions collectives des participants. Par exemple, une retraite coordonnée bénéficiant d’un jet réussi de Manœuvre, avec 1 Niveau de Réussite, confère à tous les participants un bonus de 2 à tous leurs jets d’esquive ou de parade.\nLe meneur de jeu reste libre d’interpréter les effets visuels et tactiques de ces manœuvres, ainsi que les réactions et éventuelles pénalités des adversaires."
    );

    // TODO: this would require an implementation mecanism, as for general skills
    s = SpecializedSkill.create(
      parent: Skill.discretion,
      name: "Camouflage",
      reservedCastes: [Caste.voyageur],
      description: "Cette spécialisation est réservée aux voyageurs.\nPermet au personnage d’accroître sa discrétion en tirant profit des particularités d’un environnement précis - que le joueur doit nommer au moment où il développe cette Compétence. Tous les jets s’effectuent avec un bonus de +2 dans ce milieu et la Difficulté est réduite de 5. Le niveau de cette Compétence ne peut dépasser Géographie + Mental du personnage pour un milieu naturel, ou Vie en Cité + Social s’il s’agit du milieu urbain.",
    );

    s = SpecializedSkill.create(
      parent: Skill.equitation,
      name: "Tir monté",
      reservedCastes: [Caste.voyageur],
      description: "Cette spécialisation est réservée aux voyageurs.\nPermet au personnage d'utiliser efficacement une arme de distance tout en dirigeant une monture. En réussissant un jet de Manuel + Tir monté contre une Difficulté de 10 au début d’un tour de combat (qui remplace le jet d'Équitation pour contrôler sa monture avant le début du tour), le personnage pourra lancer au maximum (1 + Niveaux de Réussite) projectiles durant ce tour - le combat monté limitant ordinairement à un le nombre d’actions de ce type. Si ce jet est réussi, la Difficulté de tous les jets de tir à distance du personnage est réduite de 5 par Niveau de Réussite pendant le tour en cours. \nSi le jet est raté, il faut normalement utiliser sa première action pour guider sa monture. Il n'est alors possible que de tirer un projectile par tour, aux conditions énoncées ci-dessus.\nLa Difficulté de base des tirs est inchangée et reste soumise aux malus d'actions cumulatives. Cette Compétence ne s'applique pas aux tirs depuis les véhicules.",
    );
  }

  factory SpecializedSkill.fromJson(Map<String, dynamic> json) =>
      _$SpecializedSkillFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SpecializedSkillToJson(this);

  @override
  bool operator==(Object other) =>
      other is SpecializedSkill && name == other.name;

  @override
  int get hashCode => name.hashCode;
}