import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'base.g.dart';

enum Ability {
  force(title: "Force"),
  intelligence(title: "Intelligence"),
  coordination(title: "Coordination"),
  presence(title: "Présence"),
  resistance(title: "Résistance"),
  volonte(title: "Volonté"),
  perception(title: "Perception"),
  empathie(title: "Empathie");

  const Ability({
    required this.title,
  });

  final String title;
}

enum Attribute {
  physique(title: "Physique"),
  mental(title: "Mental"),
  manuel(title: "Manuel"),
  social(title: "Social");

  const Attribute({
    required this.title,
  });

  final String title;
}

enum CasteStatus {
  none,
  apprenti,
  initie,
  expert,
  maitre,
  grandMaitre,
}

enum Caste {
  sansCaste(title: 'Sans caste'),
  artisan(title: 'Artisan'),
  combattant(title: 'Combattant'),
  commercant(title: 'Commerçant'),
  erudit(title: 'Érudit'),
  mage(title: 'Mage'),
  prodige(title: 'Prodige'),
  protecteur(title: 'Protecteur'),
  voyageur(title: 'Voyageur');

  const Caste({
    required this.title,
  });

  final String title;

  static Caste? byTitle(String descr) {
    Caste? ret;
    for(var caste in Caste.values) {
      if(caste.title == descr) ret = caste;
    }
    return ret;
  }

  static String statusName(Caste c, CasteStatus s) {
    String ret = 'Sans statut';
    if(_statusNames.containsKey(c) && _statusNames[c]!.containsKey(s)) {
      ret = _statusNames[c]![s]!;
    }
    return ret;
  }

  static List<String> benefits(Caste c, CasteStatus s) {
    var ret = <String>[];
    if(_benefits.containsKey(c)) {
      for(var i = CasteStatus.apprenti.index; i <= s.index; ++i) {
        var status = CasteStatus.values[i];
        if(_benefits[c]!.containsKey(status)) {
          ret.add(_benefits[c]![status]!);
        }
      }
    }
    return ret;
  }

  static List<String> techniques(Caste c, CasteStatus s) {
    var ret = <String>[];
    if(_techniques.containsKey(c)) {
      for(var i = CasteStatus.apprenti.index; i <= s.index; ++i) {
        var status = CasteStatus.values[i];
        if(_techniques[c]!.containsKey(status)) {
          ret.add(_techniques[c]![status]!);
        }
      }
    }
    return ret;
  }

  static final Map<Caste, Map<CasteStatus, String>> _statusNames = {
    Caste.artisan: {
      CasteStatus.apprenti: 'Apprenti',
      CasteStatus.initie: 'Compagnon',
      CasteStatus.expert: 'Artisan',
      CasteStatus.maitre: 'Maître artisan',
      CasteStatus.grandMaitre: 'Grand maître artisan',
    },
    Caste.combattant: {
      CasteStatus.apprenti: 'Apprenti',
      CasteStatus.initie: 'Spadassin',
      CasteStatus.expert: 'Combattant',
      CasteStatus.maitre: "Maître d'armes",
      CasteStatus.grandMaitre: "Grand maître d'armes",
    },
    Caste.commercant: {
      CasteStatus.apprenti: 'Marchand',
      CasteStatus.initie: 'Commerçant',
      CasteStatus.expert: 'Négociant',
      CasteStatus.maitre: 'Dignitaire',
      CasteStatus.grandMaitre: 'Prince marchand',
    },
    Caste.erudit: {
      CasteStatus.apprenti: 'Apprenti',
      CasteStatus.initie: 'Initié',
      CasteStatus.expert: 'Érudit',
      CasteStatus.maitre: 'Sage',
      CasteStatus.grandMaitre: 'Prophète',
    },
    Caste.mage: {
      CasteStatus.apprenti: 'Apprenti',
      CasteStatus.initie: 'Initié',
      CasteStatus.expert: 'Mage',
      CasteStatus.maitre: 'Grand mage',
      CasteStatus.grandMaitre: 'Grand maître',
    },
    Caste.prodige: {
      CasteStatus.apprenti: 'Premier statut',
      CasteStatus.initie: 'Deuxième statut',
      CasteStatus.expert: 'Troisème statut',
      CasteStatus.maitre: 'Quatrième statut',
      CasteStatus.grandMaitre: 'Cinquième statut',
    },
    Caste.protecteur: {
      CasteStatus.apprenti: 'Soldat',
      CasteStatus.initie: 'Lieutenant',
      CasteStatus.expert: 'Capitaine',
      CasteStatus.maitre: 'Commandeur',
      CasteStatus.grandMaitre: 'Commandeur-Dragon',
    },
    Caste.voyageur: {
      CasteStatus.apprenti: 'Marcheur',
      CasteStatus.initie: 'Pisteur',
      CasteStatus.expert: 'Voyageur',
      CasteStatus.maitre: 'Solitaire',
      CasteStatus.grandMaitre: 'Orphelin',
    },
  };

  static final Map<Caste, Map<CasteStatus, String>> _benefits = {
    Caste.artisan: {
      CasteStatus.apprenti: "Spécialisation Technique",
      CasteStatus.initie: "Sorcellerie et une Sphère",
      CasteStatus.expert: "Relancer le dé de l'Homme pour 1 point de Chance",
      CasteStatus.maitre: "Sorts de Magie Instinctive et Sorcellerie sans surcoût",
      CasteStatus.grandMaitre: "Lance et conserve 1 dé supplémentaire de l'Homme",
    },
    Caste.combattant: {
      CasteStatus.apprenti: "Spécialisation Combat",
      CasteStatus.initie: "Trois spécialisations (2 Combat, 1 libre)",
      CasteStatus.expert: "Une attaque supplémentaire sans pénalité par tour",
      CasteStatus.maitre: "Bonus de 2 en attaque et parade si l'adversaire utilise une arme dans laquelle le personnage est spécialisé",
      CasteStatus.grandMaitre: "Difficulté des jets de combat réduite de 5 quand le personnage utilise son arme de prédilection",
    },
    Caste.commercant: {
      CasteStatus.apprenti: "500 dracs d'argent, Spécialisation Communication ou Manipulation",
      CasteStatus.initie: "Dispose d'un petit comptoir marchand",
      CasteStatus.expert: "Connaissance des compagnies commerciales, guildes et factions de son royaume",
      CasteStatus.maitre: "Lance 1 dé de l'Homme supplémentaire pour Social ou Manuel, +1 en Social dans sa cité",
      CasteStatus.grandMaitre: "Peut apprendre la vérité lors d'une discussion suite à un jet de SOC+EMP (diff. 15)",
    },
    Caste.erudit: {
      CasteStatus.apprenti: "Spécialisation Mental",
      CasteStatus.initie: "Influence des convictions",
      CasteStatus.expert: "Lance un dé neutre supplémentaire pour tous les jets MEN, qu'il ajoute au résultat",
      CasteStatus.maitre: "Représentant d'Ozyr consulté pour des discussions importantes",
      CasteStatus.grandMaitre: "Peut consulter les écrits de n'importe quelle bibliothèque draconique",
    },
    Caste.mage: {
      CasteStatus.apprenti: "Peut lire les matrices magique, Spécialisation Combat ou Théorie",
      CasteStatus.initie: "Peut reconnaître un sort lancé avec un jet MEN+INT (diff. 15)",
      CasteStatus.expert: "Peut créer ses propres sorts",
      CasteStatus.maitre: "Ajoute le niveau de sa Sphère en défense contre les sorts de cette Sphère",
      CasteStatus.grandMaitre: "Immunité contre les sorts de niveau 1 de sa Sphère privilégiée",
    },
    Caste.prodige: {
      CasteStatus.apprenti: "Peut communiquer mentalement avec toute créature draconique, Spécialisation libre",
      CasteStatus.initie: "Peut déterminer la tendance Dragon d'un être vivant (nécessite un contact visuel suffisant)",
      CasteStatus.expert: "Peut déterminer l'âge, la lignée et les traits de caractère de n'importe quel Dragon",
      CasteStatus.maitre: "Ne sera jamais attaqué par un Dragon (sauf Dragon de Kalimsshar)",
      CasteStatus.grandMaitre: "Peut réduire à zéro la tendance Homme ou Fatalité d'un individu consentant en sacrifiant sous ses cercles de tendance Dragon",
    },
    Caste.protecteur: {
      CasteStatus.apprenti: "Peut porter un bouclier dragon, Spécialisation Combat",
      CasteStatus.initie: "Peut donner des ordres à des Protecteurs de statut inférieur",
      CasteStatus.expert: "Peut prendre les mesures nécessaires pour faire respecter la loi draconique au sein d'une cité",
      CasteStatus.maitre: "Peut prendre les mesures nécessaires pour faire respecter la loi draconique partout dans Kor, bonus de +2 à tous ses subordonnés en combat",
      CasteStatus.grandMaitre: "Peut monter n'importe quel dragon de pierre",
    },
    Caste.voyageur: {
      CasteStatus.apprenti: "Planification de voyages optimale, Spécialisation Mouvement ou Théorie",
      CasteStatus.initie: "Peut se repérer parfaitement dans un endroit déjà visité au moins une fois",
      CasteStatus.expert: "Peut apprendre 1 information sur une région nouvellement visitée par NR sur un jet MEN+EMP (diff. 5)",
      CasteStatus.maitre: "Ne sera jamais attaqué par les animaux sauvages",
      CasteStatus.grandMaitre: "Sommeil léger et réparateur, peut dépenser un point de Chance par case de blessure à récupérer",
    },
  };

  static final Map<Caste, Map<CasteStatus, String>> _techniques = {
    Caste.artisan: {
      CasteStatus.apprenti: "D'un compagnon à l'autre",
      CasteStatus.initie: "La voie du progrès",
      CasteStatus.expert: "L'essence de l'art",
      CasteStatus.maitre: "L'esquisse du destin",
      CasteStatus.grandMaitre: "La force du rouage",
    },
    Caste.combattant: {
      CasteStatus.apprenti: "L'œil du maître",
      CasteStatus.initie: "La main du maître",
      CasteStatus.expert: "La puissance du maître",
      CasteStatus.maitre: "La voie du maître",
      CasteStatus.grandMaitre: "La maîtrise parfaite",
    },
    Caste.commercant: {
      CasteStatus.apprenti: "Le sourire accueillant",
      CasteStatus.initie: "Reconnaître son erreur",
      CasteStatus.expert: "L'examen de conscience",
      CasteStatus.maitre: "Une technique éprouvée",
      CasteStatus.grandMaitre: "Le bénéfice du doute",
    },
    Caste.erudit: {
      CasteStatus.apprenti: "La lettre et le nom",
      CasteStatus.initie: "La rune et le secret",
      CasteStatus.expert: "L'homme et l'Étoile",
      CasteStatus.maitre: "Le livre et le temps",
      CasteStatus.grandMaitre: "L'homme et le destin",
    },
    Caste.mage: {
      CasteStatus.apprenti: "La matière",
      CasteStatus.initie: "L'esprit",
      CasteStatus.expert: "La volonté",
      CasteStatus.maitre: "La flamme",
      CasteStatus.grandMaitre: "La source",
    },
    Caste.prodige: {
      CasteStatus.apprenti: "La source de vie",
      CasteStatus.initie: "Le feu intérieur",
      CasteStatus.expert: "La clarté de l'esprit",
      CasteStatus.maitre: "Le cycle primordial",
      CasteStatus.grandMaitre: "Le serment de la Terre",
    },
    Caste.protecteur: {
      CasteStatus.apprenti: "L'écaille du dragon",
      CasteStatus.initie: "La cuirasse du dragon",
      CasteStatus.expert: "Le souffle du dragon",
      CasteStatus.maitre: "Le sang du dragon",
      CasteStatus.grandMaitre: "Le don draconique",
    },
    Caste.voyageur: {
      CasteStatus.apprenti: "À la croisée des chemins",
      CasteStatus.initie: "Porté par le vent",
      CasteStatus.expert: "Projectile cardinal",
      CasteStatus.maitre: "Le couvert de la nuit",
      CasteStatus.grandMaitre: "L'œil du fou",
    },
  };
}

enum Interdict {
  loiDuCompagnon(caste: Caste.artisan, title: 'La Loi du Compagnon'),
  loiDeLaPerfection(caste: Caste.artisan, title: 'La Loi de la Perfection'),
  loiDuRespect(caste: Caste.artisan, title: 'La Loi du Respect'),
  loiDeLArme(caste: Caste.combattant, title: "La Loi de l'Arme"),
  loiDeLHonneur(caste: Caste.combattant, title: "La Loi de l'Honneur"),
  loiDuSangCombattant(caste: Caste.combattant, title: 'La Loi du Sang (Combattant)'),
  loiDuCoeur(caste: Caste.commercant, title: 'La Loi du Cœur'),
  loiDeLOrdre(caste: Caste.commercant, title: "La Loi de l'Ordre"),
  loiDuProgres(caste: Caste.commercant, title: 'La Loi du Progrès'),
  loiDuSavoir(caste: Caste.erudit, title: 'La Loi du Savoir'),
  loiDuCollege(caste: Caste.erudit, title: 'La Loi du Collège'),
  loiDuSecret(caste: Caste.erudit, title: 'La Loi du Secret'),
  loiDuPacte(caste: Caste.mage, title: 'La Loi du Pacte'),
  loiDuPartage(caste: Caste.mage, title: 'La Loi du Partage'),
  loiDeLaPrudence(caste: Caste.mage, title: 'La Loi de la Prudence'),
  loiDeLaMeditation(caste: Caste.prodige, title: 'La Loi de la Méditation'),
  loiDeLaNature(caste: Caste.prodige, title: 'La Loi de la Nature'),
  loiDuSangProdige(caste: Caste.prodige, title: 'La Loi du Sang (Prodige)'),
  loiDuLien(caste: Caste.protecteur, title: 'La Loi du Lien'),
  loiDuSacrifice(caste: Caste.protecteur, title: 'La Loi du Sacrifice'),
  loiDuSangProtecteur(caste: Caste.protecteur, title: 'La Loi du Sang (Protecteur)'),
  loiDeLAmitie(caste: Caste.voyageur, title: "La Loi de l'Amitié"),
  loiDeLaDecouverte(caste: Caste.voyageur, title: 'La Loi de la Découverte'),
  loiDeLaLiberte(caste: Caste.voyageur, title: 'La Loi de la Liberté'),
  ;

  final Caste caste;
  final String title;

  const Interdict({ required this.caste, required this.title });
}

enum CastePrivilege {
  apprenti(caste: Caste.artisan, title: 'Apprenti', cost: 3),
  autorisation(caste: Caste.artisan, title: 'Autorisation', cost: 4),
  charteDAtelier(caste: Caste.artisan, title: "Charte d'atelier", cost: 4),
  ecole(caste: Caste.artisan, title: "École", cost: 4, unique: false, requireDescription: true),
  elementalisme(caste: Caste.artisan, title: "Élémentalisme", cost: 6, requireDescription: true),
  familier(caste: Caste.artisan, title: 'Familier', cost: 1, unique: false, requireDescription: true),
  notable(caste: Caste.artisan, title: 'Notable', cost: 3, requireDescription: true),
  outils(caste: Caste.artisan, title: 'Outils', cost: 4),
  psychometrie(caste: Caste.artisan, title: 'Psychométrie', cost: 5),
  reparationDeRoutine(caste: Caste.artisan, title: 'Réparation de routine', cost: 4),
  symbiose3(caste: Caste.artisan, title: "Symbiose (trois conditions)", cost: 3, requireDescription: true),
  symbiose5(caste: Caste.artisan, title: "Symbiose (deux conditions)", cost: 5, requireDescription: true),
  symbiose8(caste: Caste.artisan, title: "Symbiose (une condition)", cost: 8, requireDescription: true),
  expertiseArtisan(caste: Caste.artisan, title: 'Expertise', cost: 4),
  faveurPolitiqueArtisan(caste: Caste.artisan, title: 'Faveur politique', cost: 4, unique: false, requireDescription: true),
  tuteurArtisan(caste: Caste.artisan, title: 'Tuteur', cost: 8, requireDescription: true),

  adaptation(caste: Caste.combattant, title: 'Adaptation', cost: 3),
  anticipation(caste: Caste.combattant, title: 'Anticipation', cost: 5),
  argotCombattant(caste: Caste.combattant, title: 'Argot combattant', cost: 2),
  botteSecrete(caste: Caste.combattant, title: 'Botte secrète', cost: 5, unique: false, requireDescription: true),
  convictionSuperieure(caste: Caste.combattant, title: 'Conviction supérieure', cost: 5),
  doubleAttaque(caste: Caste.combattant, title: 'Double attaque', cost: 6),
  engagement(caste: Caste.combattant, title: 'Engagement', cost: 4),
  feinte(caste: Caste.combattant, title: 'Feinte', cost: 6),
  recuperation(caste: Caste.combattant, title: 'Récupération', cost: 6),
  riposte(caste: Caste.combattant, title: 'Riposte', cost: 5),
  sommeilLeger(caste: Caste.combattant, title: 'Sommeil léger', cost: 3),
  vigilanceCombattant(caste: Caste.combattant, title: 'Vigilance', cost: 4),
  alliesMercenairesCombattant(caste: Caste.combattant, title: 'Alliés mercenaires', cost: 6, unique: false, requireDescription: true),
  compagnonsDeBatailleCombattant(caste: Caste.combattant, title: 'Compagnons de bataille', cost: 6, unique: false, requireDescription: true),
  maitriseDArmureCombattant(caste: Caste.combattant, title: "Maîtrise d'armure", cost: 10),

  bonneFoi(caste: Caste.commercant, title: 'Bonne foi', cost: 4),
  bonneFortune(caste: Caste.commercant, title: 'Bonne fortune', cost: 5),
  expertise(caste: Caste.commercant, title: 'Expertise', cost: 2),
  faveurPolitique(caste: Caste.commercant, title: 'Faveur politique', cost: 2, unique: false, requireDescription: true),
  fournisseurDePoisons(caste: Caste.commercant, title: 'Fournisseur de poisons', cost: 5, requireDescription: true),
  notorieteCommercant(caste: Caste.commercant, title: 'Notoriété', cost: 2, unique: false, requireDescription: true),
  psychologie(caste: Caste.commercant, title: 'Psychologie', cost: 2),
  reflexesDeFuite(caste: Caste.commercant, title: 'Réflexes de fuite', cost: 3),
  reseau(caste: Caste.commercant, title: 'Réseau', cost: 4),
  ressources(caste: Caste.commercant, title: 'Ressources', cost: 3),
  rumeurs(caste: Caste.commercant, title: 'Rumeurs', cost: 3),
  connaissanceDuMondeCommercant(caste: Caste.commercant, title: 'Connaissance du monde', cost: 6),
  messagerCommercant(caste: Caste.commercant, title: 'Messager', cost: 4, unique: false, requireDescription: true),
  relationsDAffairesCommercant(caste: Caste.commercant, title: "Relations d'affaires", cost: 6, unique: false, requireDescription: true),

  ambassade(caste: Caste.erudit, title: 'Ambassade', cost: 3, unique: false, requireDescription: true),
  aplomb(caste: Caste.erudit, title: 'Aplomb', cost: 1),
  avalDraconique(caste: Caste.erudit, title: 'Aval draconique', cost: 6, unique: false, requireDescription: true),
  calligraphieOfficielle(caste: Caste.erudit, title: 'Calligraphie officielle', cost: 4),
  demagogie(caste: Caste.erudit, title: 'Démagogie', cost: 3),
  ecritTechnique(caste: Caste.erudit, title: 'Écrit technique', cost: 4),
  garantErudit(caste: Caste.erudit, title: 'Garant', cost: 3),
  linguistique(caste: Caste.erudit, title: 'Linguistique', cost: 2),
  memoire(caste: Caste.erudit, title: 'Mémoire', cost: 4),
  notorieteErudit(caste: Caste.erudit, title: 'Notoriété', cost: 4),
  faveurPolitiqueErudit(caste: Caste.erudit, title: 'Faveur politique', cost: 4, unique: false, requireDescription: true),
  messagerErudit(caste: Caste.erudit, title: 'Messager', cost: 4, unique: false, requireDescription: true),
  psychologieErudit(caste: Caste.erudit, title: 'Psychologie', cost: 4),

  approvisionnement(caste: Caste.mage, title: 'Approvisionnement (Mage des Cités)', cost: 4),
  aura(caste: Caste.mage, title: 'Aura', cost: 3),
  anonymat(caste: Caste.mage, title: 'Anonymat', cost: 4),
  cotation(caste: Caste.mage, title: 'Cotation (Mage des Cités)', cost: 3),
  detachement(caste: Caste.mage, title: 'Détachement (Mage des Océans)', cost: 3),
  duelliste(caste: Caste.mage, title: 'Duelliste (Mage du Feu)', cost: 4),
  empathieAquatique(caste: Caste.mage, title: 'Empathie aquatique (Mage des Océans)', cost: 2),
  empathieElementaire(caste: Caste.mage, title: 'Empathie élémentaire', cost: 5),
  familierMagique(caste: Caste.mage, title: 'Familier magique (Mage du Métal)', cost: 4, unique: false, requireDescription: true),
  immuniteContreLElectricite(caste: Caste.mage, title: 'Immunité contre l\'électricité (Mage du Feu)', cost: 4),
  insensibiliteALaChaleur(caste: Caste.mage, title: 'Insensibilité à la chaleur', cost: 4),
  laboratoire(caste: Caste.mage, title: 'Laboratoire', cost: 5),
  langageTechnique(caste: Caste.mage, title: 'Langage technique (Mage du Métal', cost: 2),
  leurre(caste: Caste.mage, title: 'Leurre', cost: 3),
  messager(caste: Caste.mage, title: 'Messager', cost: 2, unique: false, requireDescription: true),
  messagerOnirique(caste: Caste.mage, title: 'Messager onirique (Mage des Rêves)', cost: 5),
  mouvementDeFoule(caste: Caste.mage, title: 'Mouvement de foule', cost: 3),
  nomDeKalimsshar(caste: Caste.mage, title: 'Nom de Kalimsshar (Mage de l\'Ombre)', cost: 3),
  pistesCachees(caste: Caste.mage, title: 'Pistes cachées (Mage des Vents)', cost: 3),
  predispositions(caste: Caste.mage, title: 'Prédispositions', cost: 3),
  prevoyance(caste: Caste.mage, title: 'Prévoyance', cost: 2),
  privilegeDeVoyageur(caste: Caste.mage, title: 'Privilège de voyageur (Mage des Rêves ou des Vents)', cost: 0),
  protectionDesEeries(caste: Caste.mage, title: 'Protection des Eeries (Mage des Rêve ou de la Nature)', cost: 4),
  puissanceDeSang(caste: Caste.mage, title: 'Puissance de sang (Mage de l\'Ombre)', cost: 5),
  refugeSylvestre(caste: Caste.mage, title: 'Refuge sylvestre (Mage de la Nature)', cost: 4),
  renommee(caste: Caste.mage, title: 'Renommée (Mage de la Nature)', cost: 2, requireDescription: true),
  sortilegeFetiche(caste: Caste.mage, title: 'Sortilège fétiche', cost: 4, unique: false, requireDescription: true),
  sortilegeFeticheMetal(caste: Caste.mage, title: 'Sortilège fétiche du Métal', cost: 4, unique: false, requireDescription: true),
  sortilegeFeticheFeu(caste: Caste.mage, title: 'Sortilège fétiche du Feu', cost: 4, unique: false, requireDescription: true),
  sortilegeFeticheCites(caste: Caste.mage, title: 'Sortilège fétiche des Cités', cost: 4, unique: false, requireDescription: true),
  sortilegeFeticheOceans(caste: Caste.mage, title: 'Sortilège fétiche des Océans', cost: 4, unique: false, requireDescription: true),
  sortilegeFeticheReves(caste: Caste.mage, title: 'Sortilège fétiche des Rêves', cost: 4, unique: false, requireDescription: true),
  sortilegeFeticheNature(caste: Caste.mage, title: 'Sortilège fétiche de la Nature', cost: 4, unique: false, requireDescription: true),
  sortilegeFetichePierre(caste: Caste.mage, title: 'Sortilège fétiche de la Pierre', cost: 4, unique: false, requireDescription: true),
  sortilegeFeticheVents(caste: Caste.mage, title: 'Sortilège fétiche des Vents', cost: 4, unique: false, requireDescription: true),
  sortilegeFeticheOmbre(caste: Caste.mage, title: 'Sortilège fétiche de l\'Ombre', cost: 4, unique: false, requireDescription: true),
  style(caste: Caste.mage, title: 'Style', cost: 3),
  transmutation(caste: Caste.mage, title: 'Transmutation (Mage du Métal)', cost: 4),
  tuteur(caste: Caste.mage, title: 'Tuteur', cost: 4, requireDescription: true),
  tuteurSpecialise(caste: Caste.mage, title: 'Tuteur spécialisé', cost: 2, requireDescription: true),
  visions(caste: Caste.mage, title: 'Visions (Mage des Océans)', cost: 3),
  voixDeKalimsshar(caste: Caste.mage, title: 'Voix de Kalimsshar (Mage de l\'Ombre)', cost: 3),
  autoriteMagePierre(caste: Caste.mage, title: 'Autorité (Mage de la Pierre)', cost: 4),
  apprentiMage(caste: Caste.mage, title: 'Apprenti', cost: 6),
  engagementMage(caste: Caste.mage, title: 'Engagement', cost: 8),
  memoireMage(caste: Caste.mage, title: 'Mémoire', cost: 8),
  porteParoleMage(caste: Caste.mage, title: 'Porte-parole (Mage de la Pierre)', cost: 4),

  donDeBrorne(caste: Caste.prodige, title: 'Le don de Brorne', cost: 4),
  donDeHeyra(caste: Caste.prodige, title: 'Le don de Heyra', cost: 4),
  donDeKali(caste: Caste.prodige, title: 'Le don de Kali', cost: 5),
  donDeKalimsshar(caste: Caste.prodige, title: 'Le don de Kalimsshar', cost: 4),
  donDeKezyr(caste: Caste.prodige, title: 'Le don de Kezyr', cost: 4),
  donDeKhy(caste: Caste.prodige, title: 'Le don de Khy', cost: 4),
  donDeKhymera(caste: Caste.prodige, title: 'Le don de Khyméra', cost: 6),
  donDeKroryn(caste: Caste.prodige, title: 'Le don de Kroryn', cost: 4),
  donDeMoryagorn(caste: Caste.prodige, title: 'Le don de Moryagorn', cost: 6),
  donDeNenya(caste: Caste.prodige, title: 'Le don de Nenya', cost: 4),
  donDOzyr(caste: Caste.prodige, title: "Le don d'Ozyr", cost: 4),
  donDeSolyr(caste: Caste.prodige, title: 'Le don de Solyr', cost: 4),
  donDeSzyl(caste: Caste.prodige, title: 'Le don de Szyl', cost: 4),
  aplombProdige(caste: Caste.prodige, title: 'Aplomb', cost: 2),
  engagementProdige(caste: Caste.prodige, title: 'Engagement', cost: 8),
  reflexesDeDegagement(caste: Caste.prodige, title: 'Réflexes de dégagement', cost: 6),

  adopte(caste: Caste.protecteur, title: 'Adopté', cost: 5),
  autorite(caste: Caste.protecteur, title: 'Autorité', cost: 4),
  cuirasse(caste: Caste.protecteur, title: 'Cuirasse', cost: 5),
  defense(caste: Caste.protecteur, title: 'Défense', cost: 6),
  influences(caste: Caste.protecteur, title: 'Influences', cost: 3, requireDescription: true),
  lucidite(caste: Caste.protecteur, title: 'Lucidité', cost: 4),
  porteParole(caste: Caste.protecteur, title: 'Porte-parole', cost: 3),
  renseignement(caste: Caste.protecteur, title: 'Renseignement', cost: 4),
  requisition(caste: Caste.protecteur, title: 'Réquisition', cost: 4),
  signesDeBatailleProtecteur(caste: Caste.protecteur, title: 'Signes de bataille', cost: 4),
  suspicion(caste: Caste.protecteur, title: 'Suspicion', cost: 4),
  engagementProtecteur(caste: Caste.protecteur, title: 'Engagement', cost: 8),
  notorieteProtecteur(caste: Caste.protecteur, title: 'Notoriété', cost: 8, unique: false, requireDescription: true),

  archer(caste: Caste.voyageur, title: 'Archer', cost: 6),
  chasseur(caste: Caste.voyageur, title: 'Chasseur', cost: 6),
  compagnons(caste: Caste.voyageur, title: 'Compagnong', cost: 3, unique: false, requireDescription: true),
  connaissanceDuMonde(caste: Caste.voyageur, title: 'Connaissance du monde', cost: 3),
  filsDeLaTerre(caste: Caste.voyageur, title: 'Fils de la terre', cost: 4),
  garantVoyageur(caste: Caste.voyageur, title: 'Garant', cost: 4),
  logistique(caste: Caste.voyageur, title: 'Logistique', cost: 2),
  maitriseDArmure(caste: Caste.voyageur, title: "Maîtrise d'armure", cost: 5),
  rancune(caste: Caste.voyageur, title: 'Rancune', cost: 4, unique: false, requireDescription: true),
  solitaire(caste: Caste.voyageur, title: 'Solitaire', cost: 4),
  vigilanceVoyageur(caste: Caste.voyageur, title: 'Vigilance', cost: 5),
  ambassadeVoyageur(caste: Caste.voyageur, title: 'Ambassade', cost: 6),
  familierVoyageur(caste: Caste.voyageur, title: 'Familier', cost: 2, unique: false, requireDescription: true),
  linguistiqueVoyageur(caste: Caste.voyageur, title: 'Linguistique', cost: 4)
  ;

  final Caste caste;
  final String title;
  final int cost;
  final bool unique;
  final bool requireDescription;

  const CastePrivilege({
    required this.caste,
    required this.title,
    required this.cost,
    this.unique = true,
    this.requireDescription = false,
  });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterCastePrivilege {
  CharacterCastePrivilege({ required this.privilege, this.description });

  CastePrivilege privilege;
  String? description;

  factory CharacterCastePrivilege.fromJson(Map<String, dynamic> j) => _$CharacterCastePrivilegeFromJson(j);
  Map<String, dynamic> toJson() => _$CharacterCastePrivilegeToJson(this);
}

enum Career {
  forgeron(caste: Caste.artisan, title: 'Le forgeron', interdict: 'Tu ne tiendras aucune œuvre pour parfaite', benefit: 'La beauté du geste'),
  architecte(caste: Caste.artisan, title: "L'architecte", interdict: "Tu n'entreprendras rien sans préparation", benefit: "L'esquisse"),
  orfevre(caste: Caste.artisan, title: "L'orfèvre", interdict: 'Tu honoreras ta caste par ton talent', benefit: 'La source de beauté'),
  alchimiste(caste: Caste.artisan, title: "L'alchimiste", interdict: "Tu ne corrompras pas les éléments fondamentaux" , benefit: 'Les secrets de la matière'),
  tisserand(caste: Caste.artisan, title: 'Le tisserand', interdict: "Tu magnifieras les traditions", benefit: 'La fibre de la vie'),
  mineur(caste: Caste.artisan, title: 'Le mineur', interdict: "Tu ne souilleras pas le corps de l'Être Primordial", benefit: 'Le diamant brut'),
  artisanElementaire(caste: Caste.artisan, title: "L'artisan élémentaire", interdict: "Tu resteras en harmonie avec les énergies fondamentales", benefit: "L'écheveau élémentaire"),
  mecaniste(caste: Caste.artisan, title: 'Le mécaniste', interdict: "Tu n'auras d'autre but que l'évolution", benefit: 'La liberté de pensée'),
  aventurier(caste: Caste.combattant, title: "L'aventurier", interdict: null, benefit: "Forger l'expérience"),
  guerrier(caste: Caste.combattant, title: 'Le guerrier', interdict: "Tu ne feras preuve d'aucune lâcheté", benefit: "L'engagement du combat"),
  duelliste(caste: Caste.combattant, title: 'Le duelliste', interdict: "Tu honoreras chaque adversaire", benefit: "L'instant de vérité"),
  mercenaire(caste: Caste.combattant, title: 'Le mercenaire', interdict: 'Tu ne trahiras point', benefit: 'Une cause, un bras'),
  maitreDArmes(caste: Caste.combattant, title: "Le maître d'armes", interdict: "Tu ne manieras d'autre arme que la tienne", benefit: "La perfection ne retient qu'un nom"),
  strategeCombattant(caste: Caste.combattant, title: 'Le stratège', interdict: "Tu respecteras l'adversaire valeureux", benefit: "La voie d'une armée"),
  chevalier(caste: Caste.combattant, title: 'Le chevalier', interdict: 'Tu feras honneur à ta caste', benefit: 'Le cœur pur'),
  gladiateur(caste: Caste.combattant, title: 'Le gladiateur', interdict: "Tu respecteras l'adversaire valeureux", benefit: "L'art du combat"),
  paladin(caste: Caste.combattant, title: 'Le paladin', interdict: 'Tu protégeras la vie', benefit: 'Nulle place au doute'),
  lutteur(caste: Caste.combattant, title: 'Le lutteur', interdict: "Tu n'useras pas d'artifice", benefit: "De chair et d'os"),
  courtisane(caste: Caste.commercant, title: 'La courtisane', interdict: 'Tu ne renieras pas ta condition', benefit: 'Le sourire'),
  diplomate(caste: Caste.commercant, title: 'Le diplomate', interdict: 'Tu ne laisseras aucune situation tendre verse le meurtre', benefit: 'Les mots justes'),
  espion(caste: Caste.commercant, title: "L'espion", interdict: 'Tu ne trahiras pas tes secrets', benefit: "Le manteau d'ombre"),
  joueur(caste: Caste.commercant, title: 'Le joueur', interdict: "Tu prendras les riques qui s'imposent", benefit: 'Relever le défi'),
  marchand(caste: Caste.commercant, title: 'Le marchand', interdict: "Tu ne ruineras jamais pour t'enrichir", benefit: 'Le sens des réalités'),
  marchandItinerant(caste: Caste.commercant, title: 'Le marchand itinérant', interdict: 'Tu pousseras toujours plus loin ta bourse et ta monture', benefit: 'La poignée de main'),
  mendiant(caste: Caste.commercant, title: 'Le mendiant', interdict: 'Tu refuseras le confort et la possession matérielle', benefit: 'La roue de fortune'),
  tenancier(caste: Caste.commercant, title: 'Le tenancier', interdict: "Tu ne refuseras pas l'hospitalité", benefit: "Le coup d'œil"),
  voleur(caste: Caste.commercant, title: 'Le voleur', interdict: 'Tu ne voleras pas la vie', benefit: 'La main sûre'),
  architectes(caste: Caste.erudit, title: 'Les architectes', interdict: 'Tu ne cautionneras aucune hérésie', benefit: "L'œil de l'expert"),
  astronomes(caste: Caste.erudit, title: 'Les astronomes', interdict: "Tu ne chercheras aucune vérité fondamentale dans les astres", benefit: 'Sous les yeux du ciel'),
  cartographes(caste: Caste.erudit, title: 'Les cartographes', interdict: "Tu peindras fidèlement le portrait de l'Être Primordial", benefit: "L'expérience du terrain"),
  erudits(caste: Caste.erudit, title: 'Les érudits', interdict: 'Tu ne laisseras aucune passion motiver ton jugement', benefit: "L'esprit clair"),
  herboristes(caste: Caste.erudit, title: 'Les herboristes', interdict: 'Tu ne corrompras la tature par aucune de tes pratiques', benefit: 'À la racine de tout bienfait'),
  historiens(caste: Caste.erudit, title: 'Les historiens', interdict: "Tu n'occulteras aucune vérité, n'inventeras aucun mensonge", benefit: "La mémoire de l'archiviste"),
  medecins(caste: Caste.erudit, title: 'Les médecins', interdict: "Tu ne seras l'agent d'aucune destruction", benefit: "L'os et le ligament"),
  navigateurs(caste: Caste.erudit, title: 'Les navigateurs', interdict: "Tu ne brigueras d'autre liberté que celle offerte par la Mère des Océans", benefit: 'La ferveur du large'),
  scientifiques(caste: Caste.erudit, title: 'Les scientifiques', interdict: 'Tu ne créeras aucun instrument de rébellien', benefit: 'La quintessence du savoir'),
  generaliste(caste: Caste.mage, title: 'Le généraliste', interdict: "Tu ne t'opposeras à aucun élément", benefit: 'Le grimoire de Nenya'),
  specialisteElementaire(caste: Caste.mage, title: 'Le spécialiste élémentaire', interdict: "Tu ne vivras que pour un élément", benefit: "Guidé par l'élément"),
  invocateur(caste: Caste.mage, title: "L'invocateur", interdict: "Tu ne mettras pas l'équilibre en péril", benefit: 'Maîtrise des Portails'),
  specialisteDesRituels(caste: Caste.mage, title: 'Le spécialiste des rituels', interdict: 'Tu suivras la Voie du Secret', benefit: 'Maîtrise des Rituels'),
  enchanteur(caste: Caste.mage, title: "L'enchanteur", interdict: 'Tu ne créeras aucune forme de vie', benefit: 'Le toucher de Nenya'),
  mageDeCombat(caste: Caste.mage, title: 'Le mage de combat', interdict: "Tu ne t'opposras pas aux faibles", benefit: 'Le feu du combat'),
  guerisseurMage(caste: Caste.mage, title: 'Le guérisseur', interdict: "Tu ne refuseras pas ton aide", benefit: 'La sève qui nous lie'),
  ingenieur(caste: Caste.mage, title: "L'ingénieur", interdict: 'Tu ne trahiras pas tes Pères', benefit: 'Le rouage invisible'),
  reveur(caste: Caste.mage, title: 'Le rêveur', interdict: "Tu ne pertuberas pas l'ordre naturel", benefit: "L'illusion du corps"),
  fideleDeChimere(caste: Caste.mage, title: 'Le fidèle de Chimère', interdict: 'Nenya sera ton seul maître', benefit: 'Guidé par Nenya'),
  gardien(caste: Caste.prodige, title: 'Le gardien', interdict: "Tu n'abandonneras pas ton devoir", benefit: 'La justesse du devoir'),
  tuteur(caste: Caste.prodige, title: 'Le tuteur', interdict: "Tu n'auras d'autre maître que la voie du savoir", benefit: "Le miroir de l'âme"),
  prophete(caste: Caste.prodige, title: 'Le prophète', interdict: "Tu ne pertuberas pas l'ordre naturel", benefit: 'Le cycle de la vie'),
  fervent(caste: Caste.prodige, title: 'Le fervent', interdict: 'Tu ne tueras point', benefit: "L'illusion des tendances"),
  guerisseurProdige(caste: Caste.prodige, title: 'Le guérisseur', interdict: 'Tu ne refuseras pas ton aide', benefit: "L'amour de la terre"),
  sage(caste: Caste.prodige, title: 'Le sage', interdict: 'Tu ne garderas aucun secret', benefit: 'Le grimoire de la vie'),
  mediateur(caste: Caste.prodige, title: 'Le médiateur', interdict: 'Tu ne permettras aucun conflit', benefit: 'Le visage de Solyr'),
  missionnaire(caste: Caste.prodige, title: 'Le missionnaire', interdict: 'Tu ne subiras pas le doute', benefit: 'Fils des dragons'),
  prodigeAnimal(caste: Caste.prodige, title: 'Le prodige animal', interdict: "Tu n'enfreindras pas les lois de la nature", benefit: 'Mon âme est celle de la nature'),
  poeteDeLaNature(caste: Caste.prodige, title: 'Le poète de la nature', interdict: 'Tu ne briseras aucune harmonie', benefit: 'La terre est mon jardin'),
  soldat(caste: Caste.protecteur, title: 'Le soldat', interdict: 'Tu respecteras ton supérieur', benefit: "L'esprit du corps"),
  legionnaire(caste: Caste.protecteur, title: 'Le légionnaire', interdict: 'Tu feras ton devoir', benefit: "L'appel du devoir"),
  gardeDuCorps(caste: Caste.protecteur, title: 'Le garde du corps', interdict: 'Tu accepteras tout sacrifice', benefit: 'Ton ennemi est le mien'),
  milicien(caste: Caste.protecteur, title: 'Le milicien', interdict: 'Tu respecteras la loi', benefit: 'Le garant de la paix'),
  inquisiteur(caste: Caste.protecteur, title: "L'inquisiteur", interdict: 'Tu ne connaîtras pas le doute', benefit: 'Que justice soit faite !'),
  instructeur(caste: Caste.protecteur, title: "L'instructeur", interdict: 'Tu transmettras la tradition', benefit: 'Les fruits de la tradition'),
  strategeProtecteur(caste: Caste.protecteur, title: 'Le stratège', interdict: "Tu sacrifieras l'individu à l'armée", benefit: 'La voix du guide'),
  ingenieurMilitaire(caste: Caste.protecteur, title: "L'ingénieur militaire", interdict: 'Tu ne te détourneras pas de ta voie', benefit: "Le jeu de l'ennemi"),
  protecteurItinerant(caste: Caste.protecteur, title: 'Le protecteur itinérant', interdict: "Tu n'oublieras jamais ta condition", benefit: "La force d'un seul"),
  chasseurs(caste: Caste.voyageur, title: 'Les chasseurs', interdict: "Tu respecteras l'ordre naturel et le cycle de la vie", benefit: 'Le carquois du chasseur'),
  eclaireurs(caste: Caste.voyageur, title: 'Les éclaireurs', interdict: 'Tu ne refuseras aucun périple, aucune traversée', benefit: 'Ouvrir la route'),
  errants(caste: Caste.voyageur, title: 'Les errants', interdict: 'Tu ne souilleras pas la mémoire des contrées que tu visites', benefit: "L'œil de l'Orphelin"),
  explorateurs(caste: Caste.voyageur, title: 'Les explorateurs', interdict: "Tu ne garderas secrète aucune découverte d'importance", benefit: 'Le feu de camp'),
  menestrels(caste: Caste.voyageur, title: 'Les ménestrels', interdict: "Tu n'altéreras pas la vérité de l'Histoire", benefit: 'La veillée'),
  messagers(caste: Caste.voyageur, title: 'Les messagers', interdict: "Tu ne priveras tes pairs d'aucune information", benefit: "L'ambassadeur"),
  missionnaires(caste: Caste.voyageur, title: 'Les missionnaires', interdict: "Tu ne détourneras pas l'enseignement draconique", benefit: 'La patience du tuteur')
  ;

  final Caste caste;
  final String title;
  final String? interdict;
  final String benefit;

  const Career({
    required this.caste,
    required this.title,
    this.interdict,
    required this.benefit,
  });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class AttributeBasedCalculator {
  AttributeBasedCalculator({
    required this.static,
    required this.multiply,
    required this.add,
    required this.dice,
  });

  double calculate(int ability, { List<int>? throws }) {
    var rnd = 0;
    if(throws == null) {
      for (var i = 0; i < dice; ++i) {
        rnd += (Random().nextInt(10) + 1);
      }
    }
    else {
      rnd += throws.reduce((value, element) => value + element);
    }

    if(static > 0) {
      return (static + rnd).toDouble();
    }
    else {
      return ((ability * multiply) + add + rnd).toDouble();
    }
  }

  final double static;
  final int multiply;
  final int add;
  final int dice;

  Map<String, dynamic> toJson() => _$AttributeBasedCalculatorToJson(this);
  factory AttributeBasedCalculator.fromJson(Map<String, dynamic> json) => _$AttributeBasedCalculatorFromJson(json);
}