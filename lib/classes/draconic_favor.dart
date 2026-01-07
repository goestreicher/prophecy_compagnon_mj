import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import '../text_utils.dart';
import 'draconic_link.dart';
import 'magic.dart';

part 'draconic_favor.g.dart';

class EntityDraconicFavors with IterableMixin<DraconicFavor>, ChangeNotifier {
  EntityDraconicFavors({ List<DraconicFavor>? favors })
      : _all = favors ?? <DraconicFavor>[];

  @override
  Iterator<DraconicFavor> get iterator => _all.iterator;

  void add(DraconicFavor f) {
    _all.add(f);
    notifyListeners();
  }

  void remove(DraconicFavor f) {
    _all.remove(f);
    notifyListeners();
  }

  static List<dynamic>? readFavorsFromJson(Map<dynamic, dynamic> json, String key) =>
      json.containsKey(key)
          ? json[key] as List<dynamic>
          : <dynamic>[];

  static EntityDraconicFavors fromJson(List<dynamic> json) {
    var favors = <DraconicFavor>[];

    for(var j in json) {
      var f = j as Map<String, dynamic>;

      if(f.containsKey('id') && f.containsKey('sphere')) {
        var favor = DraconicFavor.byId(f['id'], MagicSphere.values.byName(f['sphere']));
        if(favor != null) favors.add(favor);
      }
      else {
        favors.add(DraconicFavor.fromJson(j));
      }
    }

    return EntityDraconicFavors(favors: favors);
  }

  static List<Map<String, dynamic>> toJson(EntityDraconicFavors favors) {
    var ret = <Map<String, dynamic>>[];

    for(var f in favors) {
      if(f.isDefault) {
        ret.add({'id': f.id, 'sphere': f.sphere.name});
      }
      else {
        ret.add(f.toJson());
      }
    }

    return ret;
  }

  final List<DraconicFavor> _all;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DraconicFavor {
  DraconicFavor({
    required this.sphere,
    required this.linkProgress,
    required this.title,
    required this.description,
    this.isDefault = false,
  });

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get id => sentenceToCamelCase(transliterateFrenchToAscii(title));
  MagicSphere sphere;
  DraconicLinkProgress linkProgress;
  String title;
  String description;
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isDefault;

  static Iterable<DraconicFavor> bySphere(MagicSphere sphere, { DraconicLinkProgress? maxProgress }) =>
      _favors[sphere]!
        .where(
          (DraconicFavor f) =>
            maxProgress == null || f.linkProgress.index <= maxProgress.index
        );

  static DraconicFavor? byName(String name, MagicSphere sphere) =>
      byId(sentenceToCamelCase(transliterateFrenchToAscii(name)), sphere);

  static DraconicFavor? byId(String id, MagicSphere sphere) {
    DraconicFavor? ret;

    for(var f in _favors[sphere]!) {
      if(f.id == id) {
        ret = f;
        break;
      }
    }

    return ret;
  }

  static DraconicFavor fromJson(Map<String, dynamic> json) =>
      _$DraconicFavorFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DraconicFavorToJson(this);

  static final Map<MagicSphere, List<DraconicFavor>> _favors = {
    MagicSphere.pierre: [
      DraconicFavor(
        sphere: MagicSphere.pierre,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "La peau de pierre",
        description: "Cette Faveur permet au personnage de créer un champ de force magique pour renforcer la protection d’une armure ou instaurer une barrière autour d’un individu sans défense. En réussissant un jet de Mental + Volonté contre une Difficulté de 10, le personnage permet à sa cible de bénéficier d’un nombre de champs égal à son nombre de Niveaux de Réussite plus 1. Chaque fois que le destinataire du pouvoir est touché, un de ces champs disparaît sans qu’aucune blessure ne lui soit infligée. Ensuite, une fois tous les champs disparus, le destinataire subit normalement les dommages. Ce pouvoir ne peut être utilisé que trois fois par jour, et seulement une fois par cible.",
      ),
      DraconicFavor(
        sphere: MagicSphere.pierre,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "De Pierre et de Cristaux",
        description: "Trois fois par jour, le personnage peut utiliser cette Faveur pour entrer en résonance avec la pierre, dans le but d'écouter et de percevoir des bruits à distance. Du moment que le lieu où il se trouve et celui qu'il souhaite “espionner” sont reliés par le sol ou par un élément minéral - tel qu'un mur, une paroi rocheuse, etc. - il peut ainsi suivre une conversation proche ou percevoir des bruits émis à des dizaines de mètres. La distance séparant le personnage de sa cible ne doit jamais excéder 20 fois son niveau de Lien en mètres. Pour entrer en résonance, le personnage doit effectuer un jet de Mental + Perception + Tendance Dragon contre une Difficulté de 15, qui peut- être augmentée en fonction d'éventuelles interférences. La résonance est active pendant 1 minute + 1 par Niveau de Réussite.",
      ),
      DraconicFavor(
        sphere: MagicSphere.pierre,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Les reflets de glaise",
        description: "En réussissant un jet de Manuel + Volonté contre une Difficulté de 10, le personnage peut modeler à sa guise un volume de roche d’un mètre cube. Du moment qu'il entretient un contact physique avec la roche, il peut ainsi façonner, creuser, déloger, solidifier, bâtir, etc. Il faut un tour complet avant que la roche ne devienne meuble, puis le personnage dispose d’un nombre de tours égal à la valeur de sa Tendance Dragon avant qu’elle ne se solidifie à nouveau. S'il le désire, il peut bien entendu solidifier la roche avant ce délai. Cette Faveur peut être utilisée une fois par jour.",
      ),
      DraconicFavor(
        sphere: MagicSphere.pierre,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "La Mémoire de la Terre",
        description: "Une fois par jour, le personnage peut entrer en contact avec l'esprit de la Terre et apprendre ce qui s'est produit à l'endroit où il se trouve. S'il réussit un jet de Mental + Empathie + niveau de Lien contre une Difficulté de 15, il pourra obtenir une information + 1 par Niveau de Réussite. Cette Difficulté peut être augmentée ou réduite de 5 en fonction de l'environnement géographique ou magique du personnage - plus facile en pleine montagne, plus délicat en forêt, totalement impossible en mer. Le meneur de jeu reste libre des informations qu'il transmet au personnage, en fonction de l'endroit, de l'ancienneté des événements, des énergies magiques mises en oeuvre, etc. Si la Terre a bonne mémoire, les énergies de cet élément ne comptent pas parmi les plus communicatives et leurs informations auront tendance à être brutes, symboliques et difficilement compréhensibles par un esprit humain.",
      ),
      DraconicFavor(
        sphere: MagicSphere.pierre,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "Les portes de silice",
        description: "Deux fois par jour, en réussissant un jet de Physique + Volonté contre une Difficulté de 5, le personnage peut se fondre dans la pierre et traverser n'importe quelle surface minérale, emportant avec lui tout ce qu’il porte de matière inerte. Cette immatérialité reste active pendant (3 + NR) tours. Dans la roche, le personnage progresse à la vitesse de la marche. S'il est toujours dans la pierre au moment où les effets de la Faveur expirent, il ne meurt pas, mais reste prisonnier jusqu’au lendemain. Le personnage conserve ses facultés de perception et peut toujours communiquer par télépathie, mais il est incapable d'effectuer le moindre mouvement.",
      ),
      DraconicFavor(
        sphere: MagicSphere.pierre,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "L’Éclat de Pierre",
        description: "Une fois par jour, le personnage peut conférer à une armure ou à un bouclier le pouvoir de résister à n'importe quelle attaque physique. Il lui suffit de toucher l'objet de la main pour l'enchanter une journée durant et lui permettre d'annuler tous les dommages infligés par un type d’arme, au choix de son porteur. L'enchantement disparaît instantanément si l'Élu conserve le dé de l'Homme ou de la Fatalité lors d'un appel aux Tendances, que l'objet lui appartienne ou non.",
      ),
      DraconicFavor(
        sphere: MagicSphere.pierre,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "À l'ombre des montagnes",
        description: "En utilisant cette Faveur, le personnage peut faire profiter ses proches compagnons de la protection de son armure, de son bouclier et de ses éventuels enchantements défensifs. Une fois activé, le mécanisme de défense reste efficace jusqu’au terme du combat, à moins que le personnage et ses compagnons ne s'éloignent de plus de deux mêtres les uns des autres. Tous les individus présents dans une zone de deux mètres de rayon autour du personnage bénéficient de sa protection. Leur Indice de protection d’armure devient égal à celui du personnage, bouclier compris, et l’Élu peut effectuer une parade gratuite par tour de combat, pour protéger un de ses compagnons. Cette parade ne dépense pas de dé d'action, mais reste soumise aux éventuels malus dus à des actions précédentes dans le tour. Cette Faveur peut être utilisée sans limitation.",
      ),
      DraconicFavor(
        sphere: MagicSphere.pierre,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "La Force de Silice",
        description: "Une fois par jour, le personnage peut pactiser avec la pierre et voir son corps se couvrir de plaques de silice. Pour ce faire, il doit se dévêtir et réussir un jet de Mental + Volonté contre une Difficulté de 10 (L’armure de silice ne peut s’ajouter à une armure physique (obligation d’être nu), mais se cumule avec d’éventuels sorts ou autres capacités spéciales). Cette carapace reste active 5 minutes + 10 par Niveau de Réussite obtenu et procure à l'Élu une armure naturelle d'Indice de protection 30, ainsi que deux cases de blessures légères supplémentaires. Cette protection s'ajoute à une éventuelle armure. En contrepartie, toutes les actions Sociales ou Manuelles du personnage voient leur Difficulté augmenter de 5. Tant que le personnage est couvert de sa carapace de silice, il voit sa Tendance Dragon augmenter temporairement de 1, pouvant ainsi dépasser 5, mais ne peut plus faire appel aux Tendances.",
      ),
      DraconicFavor(
        sphere: MagicSphere.pierre,
        linkProgress: DraconicLinkProgress.cinquiemeNiveau,
        isDefault: true,
        title: "Le cercle de pierre",
        description: "À ce stade, le personnage devient suffisamment important aux yeux du Grand Dragon de la Pierre pour intégrer le cercle des protecteurs de Brorne. S'il n’est pas déjà membre de cette caste, il devient protecteur et obtient le Statut de Capitaine, qui correspond au troisième Statut, ainsi que tous les Bénéfices et Techniques découlant de ce Statut. S'il est déjà membre, il est automatiquement promu au Statut supérieur et peut choisir gratuitement deux Privilèges de caste. Dans tous les cas, la Résistance du personnage est définitivement augmentée de 3 et il gagne une deuxième case de blessure mortelle.",
      ),
      DraconicFavor(
        sphere: MagicSphere.pierre,
        linkProgress: DraconicLinkProgress.cinquiemeNiveau,
        isDefault: true,
        title: "L’Argile de la Vie",
        description: "Le Lien entre le personnage et l'élément de Brorne est si fort que l'Elu peut désormais puiser dans l'argile primordial pour créer la vie et remplacer un membre détruit ou sectionné. Tout d'abord, le personnage doit façonner un membre en usant d'argile et de magie, et réussir un jet de Manuel + Empathie + Tendance Dragon contre une Difficulté de 15. Les Niveaux de Réussite obtenus s'ajoutent au jet de Manuel + Volonté + Tendance Dragon contre une Difficulté de 20 qu'il doit ensuite réussir pour le greffer par magie à un être vivant, qu'il soit humain ou animal. Une fois greffé, le membre et ses muscles obéissent pleinement à leur porteur, mais celui-ci perd définitivement 1 point d'Empathie et 1 point de Coordination. Pour chaque Niveau de Réussite obtenu sur le second jet, celui de la greffe, le bénéficiaire gagne définitivement 1 en Force et en Résistance. Cette Faveur ne permet pas de créer un organe sensoriel, tel qu'un œil ou une oreille, et encore moins une tête. De plus, elle ne fonctionne pas sur un être mort ou possédant une Tendance Fatalité égale à 2 ou plus.",
      ),
    ],

    MagicSphere.feu: [
      DraconicFavor(
        sphere: MagicSphere.feu,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "L’œil incandescent",
        description: "Le personnage peut percevoir la chaleur dégagée par tous les corps chauds (êtres humains, animaux, feux de camp, etc.) sur une distance maximale de dix mètres par point de Perception. Lorsqu'il utilise ce pouvoir, il doit cependant modifier sa vision et son regard ne balaie plus qu’un angle restreint. Ses jets de Perception classiques sont réduits de 3. Le personnage doit, de plus, effectuer un jet de Mental + Perception contre une Difficulté de 10 pour déterminer avec exactitude la nature de la masse de chaleur qu’il observe. Chaque NR peut lui donner une information supplémentaire (la créature est blessée, le feu est d’origine magique, etc.).",
      ),
      DraconicFavor(
        sphere: MagicSphere.feu,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "Les Mains de Lave",
        description: "En réussissant, un jet de Mental + Volonté contre une Difficulté de 10, le personnage peut enflammer de petites surfaces de matière inerte, d'une taille maximum de 10 cm2 par point de Tendance Dragon qu'il possède. Chaque Niveau de Réussite lui permet, d'augmenter la surface de 10 cm2, d'améliorer la qualité de la combustion ou d'accélérer le processus. Utilisé en attaque, le jet voit sa Difficulté augmentée de 5 et les dommages de base sont égaux à 5 + la Tendance Dragon du personnage. Les dommages s’ajoutent aux dommages à mains nues et ignorent les armures comportant du métal.",
      ),
      DraconicFavor(
        sphere: MagicSphere.feu,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Le flot de lave",
        description: "Grâce à cette Faveur, le personnage peut, à tout moment d’un combat, décider de ne plus effectuer la moindre action de défense jusqu’à la fin de l'affrontement. La Difficulté de tous ses jets d’attaque n’est alors plus augmentée par les pénalités d'actions supplémentaires. De plus, tous ses dommages sont augmentés de 3 fois la valeur de la Tendance Dragon du personnage. Une fois la Faveur déclenchée, il est tout simplement impossible de tenter la moindre action défensive.",
      ),
      DraconicFavor(
        sphere: MagicSphere.feu,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Le Don du Feu",
        description: "En enduisant son arme de son propre sang, le personnage lui confère, l'espace d'un combat, +1D en initiative (dé neutre) et ajoute la valeur de sa Tendance Dragon à chacun de ses jets de dommages. En contrepartie, l'Élu subit instantanément deux Égratignures et voit la Difficulté de tous ses jets de combat, augmentée de 5 s'il vient à perdre son arme durant le conflit.",
      ),
      DraconicFavor(
        sphere: MagicSphere.feu,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Le Voile Pourpre",
        description: "En réussissant un jet de Mental + Volonté contre une Difficulté de 10, le personnage provoque une altération magique qui confère à tout ce qu'il porte - ainsi qu'à sa peau - une immunité totale au feu, aux flammes et à la chaleur. Les effets de cette Faveur durent 1 minute + 1 par Niveau de Réussite. Une fois le temps écoulé, la protection s'estompe graduellement et disparaît totalement en moins d'une minute.",
      ),
      DraconicFavor(
        sphere: MagicSphere.feu,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "La cérémonie du volcan",
        description: "En utilisant cette Faveur, le personnage peut s’enflammer littéralement, transformant son corps en une véritable torche vivante. Les effets de ces flammes ne lui causent aucun désagrément, mais toutes les créatures et les matières inflammables qui entrent en contact avec lui subissent les dommages du feu. Chaque contact provoque une brûlure causant (15 + 1D10) points de dommages. Ces dommages sont doublés dans le cas de créatures particulièrement sensibles au feu. De plus, toutes les matières inflammables ont 50% de chance de prendre feu dès le premier contact. Les flammes perdurent pendant 10 tours pour chaque Point de Tendance Dragon que possède le personnage. Les flammes disparaissent immédiatement si le personnage fait appel aux Tendances et conserve un autre dé que celui du Dragon, ou si le dé du Dragon obtient un 1, qu’il soit ou non conservé.",
      ),
      DraconicFavor(
        sphere: MagicSphere.feu,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "La Nuée de Magma",
        description: "Le personnage entre dans une frénésie guerrière qui l'empêche d'effectuer la moindre action de défense jusqu'à la fin de l’affrontement. Il porte ses coups avec violence et rage, ce qui augmente de 5 la Difficulté de tous les jets d'esquive et de parade du défenseur. De plus, lors du calcul des dommages, le personnage double sa Force et peut relancer le plus faible de ses dés. Cette faveur n'est, pas cumulable avec une Attaque brutale ou une Charge et ne peut être utilisée qu'une fois par jour. Si le compagnon draconique du personnage juge que le combat, ne mérite pas cette aide, il peut refuser sa Faveur à l'Élu qui, en lieu et place de bonus, voit la Difficulté de toutes ses attaques augmentée de 5 - une façon comme une autre pour le dragon de rappeler son Elu à l'ordre tout en testant son mérite.",
      ),
      DraconicFavor(
        sphere: MagicSphere.feu,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "La danse des étincelles",
        description: "Cette Faveur permet au personnage d’entrer dans une transe hypnotique, sorte de frénésie guerrière accompagnée d’une danse effrénée. Le personnage se met à tournoyer sur lui-même à grande vitesse puis, après quelques secondes, devient capable de se déplacer et de combattre sans cesser de tournoyer. Toutes les attaques portées contre lui voient leur Difficulté augmenter de 5. De plus, le personnage voit le dé d’Initiative de toutes ses actions augmenter de 4 et double sa Force lorsqu'il inflige des dommages.",
      ),
      DraconicFavor(
        sphere: MagicSphere.feu,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "Morngärdt",
        description: "Cette Faveur est réservée aux plus méritants des Élus, ceux jugés dignes par Kroryn lui-même de porter, l'espace d'un combat, la plus fabuleuse des lames de tous les temps. En réussissant un jet de Mental + Volonté + Tendance Dragon, contre une Difficulté de 20, le personnage peut invoquer la puissance de Morngärdt, l'épée de feu du Seigneur de Guerre. Quel qu’elle soit, un halo igné entoure alors l’arme de l’Elu, prenant la forme d’une titanesque épée. L’arme se manipule avec les mêmes Compétences et pré requis que si elle était inerte, mais ne cumule pas les bonus magiques. Une fois invoquée, la puissance de l'épée reste présente jusqu'à la victoire ou la mort de son porteur. La Difficulté du jet peut être réduite si les circonstances - et surtout les adversaires - sont particuliers. Face à un Humaniste, une créature corrompue, un Dragon de la Pierre, elle est réduite de 5. Face à un Dragon de l'Ombre, un Élu de Kalimsshar ou un Grand Dragon, elle est réduite de 10.\nMorngärdt n'apparaît jamais face à un Dragon du Feu ou un Élu de Kroryn - et encore moins contre Kroryn lui-même. Morngärdt octroie à son porteur un bonus de 6 en Physique pour toutes ses actions de combat et un bonus de 4 en Force pour le calcul des dégâts. Elle pèse plus de trois kilogrammes, sa lame reste toujours chaude et inflige des dommages terrifiants.\nInitiative : +1/NA. Dommages : (For x 2 +15 + 1D). Les blessures infligées par Morngärdt sont celles d'un fer porté au rouge : par NR obtenu lors d'une attaque, la cible perd définitivement 1 point de Présence. Morngärdt a également le pouvoir d'éveiller le Sang de Moryagorn, en ouvrant le sol pour en faire jaillir des torrents de lave en fusion. Pour cela, le porteur doit posséder au moins 4 en Tendance Dragon et effectuer un jet de Physique + Sphère du Feu contre une Difficulté de 15. Il est impossible de dépenser des points de Maîtrise ou de Chance pour ce jet. Pour chaque NR obtenu, il ouvre le sol sur dix mètres et en fait jaillir une gerbe de magma qui inflige 1D10 Blessures à toute créature présente dans un rayon de 30 mètres autour du porteur, qu'elle soit hostile ou non au porteur. Ce pouvoir peut être utilisé une fois par jour et affecte également les dragons de Kroryn.",
      ),
      DraconicFavor(
        sphere: MagicSphere.feu,
        linkProgress: DraconicLinkProgress.cinquiemeNiveau,
        isDefault: true,
        title: "Le feu intérieur",
        description: "Le Lien octroyé par Kroryn permet au personnage de puiser dans sa propre énergie vitale pour faire naître le feu, à l’image des dragons qui soufflent leur venin embrasé. En prenant la posture du dragon, le personnage devient capable de cracher un jet de flammes tourbillonnantes qui atteindra automatiquement sa cible, pour peu qu’elle soit située à moins de quarante mètres de lui. Pour chaque case de blessure que le personnage décide de noircir, en commençant par les égratignures, le jet de flammes inflige 20 points de dommages à la cible et toutes les cibles présentes dans un rayon de dix mètres autour de la trajectoire du jet. Toutes les créatures particulièrement sensibles au feu subissent le double des dommages. Les dragons du feu et les créatures immunisées divisent les dommages par deux. Il faut une action pour activer la Faveur et une autre pour cracher le jet de flammes.",
      ),
    ],

    MagicSphere.oceans: [
      DraconicFavor(
        sphere: MagicSphere.oceans,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "Le secret du verbe",
        description: "Le personnage est jugé digne de l'instruction d’Ozyr. Il peut alors utiliser la langue draconique pure, et ce quelle que soit son éducation ou sa culture. L'esprit du dragon des océans se mêle au sien pour lui insuffler spontanément les multiples figures de style et règles de prononciation de ce langage. Le personnage peut alors s'adresser aux dragons de tous types dans leur langue originelle sans avoir à utiliser la forme abâtardie des hommes. Il peut de plus comprendre intuitivement tous les dialectes et patois dérivés de cette langue sans avoir à s’habituer à l’accent local. Il ne peut par contre pas parler ce dialecte, recourant soit à la langue pure ou à la forme humaine pour s'exprimer. Les dragons apprécient que l’on s'adresse à eux dans la langue pure et cette habileté est un grand atout social vis-à-vis des ailés comme des hommes.",
      ),
      DraconicFavor(
        sphere: MagicSphere.oceans,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "Odes aux Sources Cachées",
        description: "En réussissant un jet de Mental + Volonté contre une Difficulté de 15, cette Faveur permet à l'Elu de faire naître une source d'eau pure dans n'importe quel lieu pour une durée d'une heure. Chaque Niveau de Réussite prolonge l'activité de la source d'une demi-heure. Cette Faveur est utilisable une fois par jour.",
      ),
      DraconicFavor(
        sphere: MagicSphere.oceans,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "L’infinie sagesse",
        description: "Cette Faveur permet au personnage de puiser dans la connaissance d’Ozyr pour obtenir la réponse à une question qu’il se pose. Le joueur doit effectuer un jet de Mental + Empathie contre une Difficulté de 10 et chaque NR lui donne un élément de réponse. Ces éléments peuvent être délayés par le meneur de jeu si celui-ci estime que la question est particulièrement difficile ou que le personnage n’est pas censé tout apprendre tout de suite. En d’autres termes, c’est à lui de se substituer au dragon des océans pour répondre au personnage. Par exemple, s’il tente de découvrir où se cache le mage qu’il traque depuis des semaines, le meneur de jeu peut se contenter de lui répondre “à l’est”, “dans une cité côtière”, “à l’abri du regard de Szyl”, etc.",
      ),
      DraconicFavor(
        sphere: MagicSphere.oceans,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Ceux qui Bruissent",
        description: "Cette Faveur permet à l'Élu d'invoquer de petits êtres liquides qui le guideront lors de la résolution d'un problème épineux faisant appel à une Compétence de Théorie. La réussite d'un jet de Mental + Empathie contre une Difficulté de 20 permet de gagner un bonus de 2 +2 points par Niveau de Réussite lors de l'utilisation d'une Compétence de Théorie. “Ceux qui bruissent” n'offriront jamais leur aide gratuitement et réclameront toujours un paiement en nature (par exemple : une information, la résolution d'une énigme, etc.)",
      ),
      DraconicFavor(
        sphere: MagicSphere.oceans,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Souvenirs Pluvieux",
        description: "En réussissant un jet de Mental + Perception contre une Difficulté de 15, l'Élu voit sa vue troublée par des trombes d'eau, qui dévoilent petit à petit, le passé du lieu dans lequel il se tient. Cela permet de remonter dans l'histoire du lieu de 5 années +5/NR. En réussissant un jet de Mental + Volonté contre une Difficulté de 15, l'Élu peut se concentrer sur certains détails de la scène (par exemple : une porte, un toit, une fenêtre, etc.)",
      ),
      DraconicFavor(
        sphere: MagicSphere.oceans,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "Le poids du souvenir",
        description: "En établissant un contact empathique avec n'importe quel être humain consentant, le personnage peut partager la vision d’un souvenir enfoui dans la mémoire de l'individu - ou inversement. La vision peut être vieille de plusieurs années, mais le personnage ne peut maintenir le lien plus d’un nombre de minutes égal à sa Volonté. Pour chaque minute ainsi écoulée, il peut partager une heure de souvenirs réels. Si la personne n’est pas consentante, il est possible de forcer le contact en réussissant un jet d'opposition en Mental + Empathie contre Mental + Volonté de la cible. Un jet réussi ne permet d’établir qu’un contact de quelques secondes, ce qui correspond tout au plus à quelques minutes de souvenirs.",
      ),
      DraconicFavor(
        sphere: MagicSphere.oceans,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "La Force des Mots",
        description: "Cette Faveur, utilisable une seule fois au cours d'un combat au contact contre un adversaire intelligent, permet de remplacer une Compétence d'arme par une Compétence de Théorie. Par cette Faveur, l'Élu “hypnotise” littéralement son adversaire grâce à la complexité de ses propos et peut ainsi porter plus aisément ses coups. Il est indispensable que l'Élu possède néanmoins la Compétence normale relative à l'arme utilisée.",
      ),
      DraconicFavor(
        sphere: MagicSphere.oceans,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "L’esprit des profondeurs",
        description: "Tout comme le vent colporte les rumeurs, l’eau conserve dans ses profondeurs les secrets de toute chose. Cette Faveur permet au personnage de créer, l’espace de quelques minutes, un lien télépathique très profond avec l’esprit de n'importe quel cours d’eau. En fonction de la taille et de la profondeur de cette source d’eau, le personnage pourra avoir accès à des consciences plus ou moins intelligentes, sensibles et bien disposées. On distingue quatre catégories de cours d’eau : les bassins, les mares, les lacs et les océans.\nPour contacter un esprit, le personnage doit se concentrer et réussir un jet de Mental + Empathie contre une Difficulté de 20 s’il s’agit d’un océan - ou assimilé. Cette Difficulté est réduite de 5 par catégorie de cours d’eau inférieure - soit 15 pour un lac, 10 pour une mare et 5 pour un bassin.\nPour chaque NR obtenu, le personnage a le droit de poser une question à l’esprit qu’il contacte et d'obtenir une réponse fiable. Attention, les esprits de l’eau ne peuvent répondre qu’à des questions théoriques, liées à des connaissances anciennes ou communément répandues, et fournir des informations sur ce dont ils ont été témoins récemment. Ainsi, l’esprit d’un océan pourra parler du bateau qui a gagné le port d’Oforia une semaine plus tôt, ou répondre à des questions concernant l’histoire, mais il n'aura pratiquement aucune chance de connaître le nom d’un marchand résidant à Havre.\nCette Faveur ne peut être utilisée qu’une seule fois par jour pour un seul et même cours d’eau. Généralement, s'ils acceptent de bonne grâce d'aider un Élu d'Ozyr, les esprits marins des grands cours d'eau aiment également “négocier” leurs faveurs, en demandent quelques menus services en échange (réparer un pont, apprendre une nouvelle histoire, faire fuir une meute de prédateurs rôdant aux alentours, etc.).",
      ),
      DraconicFavor(
        sphere: MagicSphere.oceans,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "Calice du Savoir",
        description: "En réussissant un jet de Mental + Empathie contre une Difficulté de 20, cette Faveur contraint toute personne, qui consomme un liquide (eau, vin, potage, etc.) dans un rayon de 5 mètres, à faire étalage de ses connaissances en répondant très précisément et très longuement aux questions qui lui sont posées pendant 5 minutes. Pour chaque Niveau de Réussite obtenu, soit la durée augmente de 1 minute, soit le rayon d'action augmente de 3 mètres, selon le désir de l'Élu. Cette Faveur est utilisable une fois par jour.",
      ),
      DraconicFavor(
        sphere: MagicSphere.oceans,
        linkProgress: DraconicLinkProgress.cinquiemeNiveau,
        isDefault: true,
        title: "La rive harmonie",
        description: "Grâce à cette Faveur, le personnage peut étendre le champ de sa conscience et profiter de l'expérience de n'importe quel être doué de réflexion, présent dans un rayon égal à sa Volonté en mètres. Trois fois par jour, il peut utiliser cette Faveur pour partager une Caractéristique intellectuelle (Volonté, Intelligence, Perception ou Empathie), un Attribut (Mental ou Social), une Compétence, un sortilège, une Discipline ou n'importe quel autre trait technique (Avantage ou bonus temporaire), à l’exclusion des Privilèges, Techniques, Bénéfices ou Faveurs. Il lui suffit d’annoncer le trait qu’il souhaite “copier” pour que le meneur de jeu lui attribue la meilleure valeur présente aux alentours. Une fois copiée, cette valeur reste effective pendant un nombre de tours égal à son Attribut Mental. Si aucun être vivant ne possède un meilleur score que lui dans le trait annoncé, l’effet de la Faveur est tout de même perdu. Les animaux et les monstres dénués de véritable intelligence ne sont pas affectés par ce pouvoir - faut-il préciser que les dragons sont, quant à eux, incroyablement intelligents ?",
      ),
    ],

    MagicSphere.metal: [
      DraconicFavor(
        sphere: MagicSphere.metal,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "La main du maître",
        description: "Grâce à cette Faveur, le personnage peut utiliser la technique du Dragon du Métal pour augmenter son Attribut Maîtrise lors d’un combat. Il lui faut effectuer un jet de Physique + Coordination contre une Difficulté de 5 pour gagner 2 Points de Maîtrise par NR. Ces points supplémentaires peuvent être utilisés sans aucune restriction, mais il est impossible de regagner plus de Points de Maîtrise que le score de base possédé par le personnage. Ce pouvoir peut être utilisé une fois par combat, mais le personnage perd tous ses Points de Maîtrise s’il obtient un échec critique lors d’un combat où il a déjà utilisé ce pouvoir. Suite à un échec critique, il pourra regagner normalement ses Points de Maîtrise mais sera incapable d'utiliser de nouveau son pouvoir avant le lendemain.",
      ),
      DraconicFavor(
        sphere: MagicSphere.metal,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "L’Inspiration Draconique",
        description: "Grâce à cette Faveur, le personnage peut utiliser les secrets du Grand Dragon du Métal pour augmenter son Attribut Maîtrise lors de l'utilisation de Compétences Manuelles. En réalisant un jet de Manuel + Volonté contre une Difficulté de 10, l'Élu gagne 2 points de Maîtrise +2 par Niveau de Réussite. Ces points ne peuvent être utilisés que pour une et une seule action faisant appel à une Compétence Technique ou de Manipulation. Suite à un échec critique, le personnage pourra regagner normalement ses Points de Maîtrise, mais sera dans l'impossibilité d'utiliser à nouveau cette Faveur avant le lendemain.",
      ),
      DraconicFavor(
        sphere: MagicSphere.metal,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "La justesse de l’outil",
        description: "Une fois par jour, en effectuant un jet de Mental + Volonté contre une Difficulté de 15, le personnage peut conférer à n’importe quel objet, arme ou armure, un bonus de NR points. Ce bonus peut s'appliquer à n'importe quelle fonction initiale de l’objet - bonus à la Compétence, aux dommages, au toucher, etc. Une seule utilisation est possible par jour, les bonus perdurent jusqu’au prochain lever du soleil. Il est possible de dépenser des Points de Maîtrise pour augmenter le score de base de ce jet.",
      ),
      DraconicFavor(
        sphere: MagicSphere.metal,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "L’Arrogance de l’Aveugle",
        description: "Une fois par jour, en effectuant un jet de Mental + Empathie contre une Difficulté de 20, l'Élu peut conférer à n'importe quel objet manufacturé (outil, arme, armure, etc.), qui n'appartient pas à un Élu de Kezyr, un malus de 1 point par Niveau de Réussite. Ce malus peut s'appliquer à n'importe quelle fonction initiale de l'objet - Compétence, dommages, toucher, etc. Ce malus dure jusqu'au prochain lever du soleil. Il est impossible de dépenser des Points de Maîtrise pour augmenter le score de ce jet.",
      ),
      DraconicFavor(
        sphere: MagicSphere.metal,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "L’enfant du métal",
        description: "En réussissant un jet de Mental + Volonté contre une Difficulté de 15, le personnage peut couvrir de métal l’équivalent d’un tiers de son corps par NR. Ainsi, s’il obtient au moins trois Niveaux de Réussite, son corps tout entier deviendra lisse et solide comme du métal, Les effets de la transformation durent 1 tour par Point de Tendance Dragon du personnage. Toute partie du corps ainsi couverte de métal devient insensible à la température et gagne un Indice de protection naturel de 25. Cette protection peut être cumulée avec une éventuelle armure. Cependant, pour chaque tiers de son corps métallisé, le personnage voit son Initiative réduite d’un dé pendant la durée de l'effet. La transformation est instantanée et peut être effectuée une fois par jour.",
      ),
      DraconicFavor(
        sphere: MagicSphere.metal,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "La Valse Métallique",
        description: "Une fois par jour, l'espace d'un combat, un personnage peut puiser dans la force de Kezyr. Grâce à la réussite d'un jet de Physique + Volonté + Tendance Dragon contre une Difficulté de 20, il voit sa peau se couvrir d'une fine pellicule de métal luisant, lui conférant ainsi un Indice de protection naturel de 15. De plus, aucune arme métallique - excepté les armes enchantées - ne peut lui infliger de dommages.",
      ),
      DraconicFavor(
        sphere: MagicSphere.metal,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "Empathie Matérielle",
        description: "Active en permanence, cette Faveur permet à l'Élu d'identifier les intentions du porteur d'un objet. En touchant un objet manufacturé, qui doit être en contact avec son propriétaire, l'Élu, s'il réussit un jet d’opposition de Mental + Empathie + Tendance Dragon contre Mental + Volonté, peut percevoir les émotions et intentions - peur, stress, agressivité, envie d'engager un conflit, mensonge - de son interlocuteur.",
      ),
      DraconicFavor(
        sphere: MagicSphere.metal,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "L’âme de l’immatériel",
        description: "Grâce à cette Faveur, active en permanence, le personnage peut communiquer mentalement avec n'importe quel objet qu’il touche ou possède. Cet objet sera capable de lui révéler toutes les informations qui ont pu constituer son passé, comme le nom de ses différents porteurs, l’origine de sa création, ses capacités, ses récents changements de main, etc. Seuls les objets enchantés sont capables d'appréhender la réalité qui les entoure, les autres n’ayant conscience que des individus et objets avec lesquels ils sont entrés en contact physique. Pour établir le contact avec un objet, le personnage doit dépenser 1 Point de Maîtrise. Une fois le contact établi, il reste actif aussi longtemps que le personnage le souhaite, mais se rompt dès que le contact physique est interrompu. Les objets ensorcellés n’ont pas de réfléxion en tant que telle. Dotés d’une sorte de mémoire assez étendue, ils n’ont aucun jugement et aucune conviction capable de nourrir une discussion ou une conversation subtile.",
      ),
      DraconicFavor(
        sphere: MagicSphere.metal,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "L’Essence de l’Art",
        description: "Une fois par jour, le personnage peut entrer en empathie avec un autre individu en vue de profiter de son expérience artisanale. En réussissant un jet de Mental + Empathie contre une Difficulté de 15, il peut “copier” une Compétence Manuelle pour un nombre d'heures égal à ses Niveaux de Réussite. Cette faveur ne tient pas compte des restrictions appliquées à certaines Compétences. La copie de la Compétence dure 1 + 1/NR heures.",
      ),
      DraconicFavor(
        sphere: MagicSphere.metal,
        linkProgress: DraconicLinkProgress.cinquiemeNiveau,
        isDefault: true,
        title: "Le sang de Kezyr",
        description: "À ce niveau de Lien, le personnage est tellement investi de la force de Kezyr qu’il se met à développer certaines caractéristiques physiques propres aux dragons du métal. Sa peau devient lisse et résistante comme l’acier, conférant un Indice de protection naturel de 10 au personnage. Désormais, aucune arme métallique ne peut plus lui infliger de dommages tant qu’elle n’est pas enchantée par un sortilège de niveau 1 ou supérieur. Enfin, les yeux du personnage deviennent très légèrement luminescents, signe indéniable de son Lien avec Kezyr.",
      ),
    ],

    MagicSphere.nature: [
      DraconicFavor(
        sphere: MagicSphere.nature,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "Le sang et la sève",
        description: "Cette Faveur accorde au personnage la faculté de soigner les blessures en imposant ses mains sur une plaie, une fracture ou une hémorragie. En réussissant un jet de Mental + Volonté contre une Difficulté de 10, il soigne (1 + NR) blessures en commençant par les plus graves. Cette Faveur peut être utilisée autant de fois par jour que la valeur de la Tendance Dragon de l’Élu.",
      ),
      DraconicFavor(
        sphere: MagicSphere.nature,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "Communion Terrestre",
        description: "En milieu rural, le personnage peut, en réussissant un jet de Mental + Volonté + Tendance Dragon contre une Difficulté de 20, s'enfoncer complètement dans le sol sur une dizaine de mètres de profondeur. Il emporte avec lui toutes ses possessions. Sous terre, il ne peut ni se déplacer, ni atteindre des cavités ou des nappes liquides. Il conserve une pleine conscience de ce qui se passe au dessus de lui et entend distinctement tout ce qui se dit. Lors de sa remontée, il réapparaît à l'endroit exact de sa communion. Le personnage peut survivre ainsi en osmose avec la terre durant une journée complète + une journée par Niveau de Réussite, sans devoir se nourrir ou s'abreuver. Il récupère ses Blessures au rythme normal, comme s'il passait une nuit de repos. Au-delà de cette période, la remontée est automatique car Heyra ne veut pas assister au suicide de ses enfants.",
      ),
      DraconicFavor(
        sphere: MagicSphere.nature,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Porté par la nature",
        description: "Une fois par jour, l’Élu peut puiser dans la force de la nature et multiplier par trois la valeur de son Attribut Physique, pour un nombre de tours égal à sa Volonté. Durant ce délai, le personnage ne peut en aucun cas faire appel aux Tendances. Par contre, il peut toujours gagner ou perdre des cercles de Tendance selon ses actions mais toute perte de cercles en tendance Dragon sera doublée durant la période d’utilisation de cette Faveur. Ensuite, l'Élu voit son Attribut Physique réduit de 2 pendant un nombre d’heures égal à 10 moins sa Volonté.",
      ),
      DraconicFavor(
        sphere: MagicSphere.nature,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Murmures Forestiers",
        description: "L'Élu peut hanter l'esprit d'un humain en effectuant un jet de Mental + Empathie contre une Difficulté variable de 10, si la cible est un compagnon, de 15 si elle est connue de vue ou de 20 si elle est inconnue. Chaque fois que la cible sera en milieu rural, les arbres, les plantes et les animaux adopteront un attitude agressive à son égard - sans pour autant l'attaquer ou lui nuire physiquement. De plus, la victime aura le sentiment que la faune et la flore lui murmurent des menaces à l'oreille. Tous ses jets de Mental et de Social impliquant la concentration, la confiance ou la réflexion voient leur Difficulté augmentée de 5. De plus, une nuit de repos ne permet de récupérer que la moitié de ses points de magie. Le malaise dure 1 journée + 1 par Niveau de Réussite, mais si le personnage reste proche de sa cible, il dure tant que l'Elu le désire. Il est possible d'affecter plusieurs personnes en même temps.",
      ),
      DraconicFavor(
        sphere: MagicSphere.nature,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Pacte Naturel",
        description: "En réussissant un jet de Mental + Empathie + Tendance Dragon contre une Difficulté variable, l'Élu peut obtenir de Heyra la faveur de soigner un mal, quel qu'il soit, en échange d'un service qu'il devra ensuite rendre à la nature. La Difficulté du jet est déterminée par le mal en question : 15 : Égratignure, Blessure Légère, trouble physique mineur, entorse, malaise. 20 : Blessure Grave, empoisonnement, trouble physique important, fracture. 25 : Blessure Fatale, trouble physique majeur, membre coupé. 30 : Organe détruit, Blessure Mortelle - si la Blessure a été provoquée il y a moins d'1 tour par niveau de Lien du personnage. Cette Faveur ne peut être réutilisée qu'une fois que le personnage s'est acquitté de sa dette - qu'il appartient au meneur de jeu de fixer, en accord avec l'importance de la faveur accordée. Par exemple, l'Élu peut avoir à planter une simple pousse d'arbre, à bâtir un village ou à éliminer une créature nuisible d'une forêt.",
      ),
      DraconicFavor(
        sphere: MagicSphere.nature,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "Le banquet de nature",
        description: "Grâce à cette Faveur, l’Élu peut faire venir à lui un grand nombre d'animaux présents dans la région. Les bêtes qui viendront ne seront pas hostiles et ne se battront pas entre elles. Si l’Élu est capable de communiquer avec eux, les animaux écouteront sa requête et l’aideront de leur mieux, pour peu que sa conduite s’inscrive dans la droite ligne d’Heyra. Sinon, ils repartiront comme ils sont venus. Cette Faveur peut être utilisée une fois par jour. Cette aide peut durer jusqu’au coucher du soleil si la requête que les animaux cherchent à remplir demande beaucoup de temps.",
      ),
      DraconicFavor(
        sphere: MagicSphere.nature,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "Stase de Vie",
        description: "En milieu rural, l'Élu peut s'étendre à même le sol et ralentir son métabolisme à l'extrême. Dans cet état de catalepsie et de pure communion avec Mère Nature, le personnage voit son organisme se régénérer. Tant que dure la stase, il ne doit ni se nourrir ni boire, et aucun animal ou dragon ne lui portera préjudice. Le personnage entre en stase en réussissant un jet de Mental + Volonté contre une Difficulté de 15. La stase dure normalement 7 jours et lui permet de récupérer de toutes ses blessures. Chaque Niveau de Réussite réduit la stase d'une journée.",
      ),
      DraconicFavor(
        sphere: MagicSphere.nature,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "Le cycle de la vie",
        description: "En utilisant cette Faveur, le personnage peut guérir n'importe quel mal, fracture, trouble ou blessure. Il lui suffit pour cela d’imposer les mains sur l’origine du trouble et focaliser la bonté d’Heyra sur le bénéficiaire des soins. Il peut s'agir de n’importe quelle forme de vie existante. Une fois les soins appliqués, tous les maux sont instantanément guéris, mais le miraculé perd tous ses cercles cochés de Tendances Homme et Fatalité, et le Prodige devient aveugle jusqu’au prochain coucher du soleil. Une journée complète doit s’écouler avant qu’il ne puisse de nouveau utiliser cette Faveur.",
      ),
      DraconicFavor(
        sphere: MagicSphere.nature,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "L’Écorce du Grand Chêne",
        description: "Grâce à cette Faveur, l'Élu méritant peut graver dans la mémoire de la Terre les plus importantes de ses actions. Chaque fois qu'il accomplit un acte de bienveillance, en défendant un animal faible ou en détruisant une créature corrompue, par exemple, le personnage peut effectuer un jet de Mental + Empathie + Tendance Dragon contre une Difficulté de 20. Un jet réussi lui confère une case de Mort supplémentaire + 1 par Niveau de Réussite. Ces cases disparaissent définitivement une fois qu'elles sont utilisées et l'Élu doit attendre de les avoir toutes effacées pour bénéficier de nouvelles. Pour symboliser son acte, il doit en effet procéder à un long rituel de symbiose et planter un arbre sacré au coeur d'une forêt, en compagnie de son homologue draconique. La Difficulté du jet peut être augmentée ou diminuée de 5 en fonction de l'acte de l'Élu, mais le meneur de jeu reste seul juge du mérite du personnage - il peut donc tout à fait lui interdire l'usage de cette Faveur s'il trouve son acte trop insignifiant. Les cases sont immédiatement effacées si l'arbre de l'Élu vient à être détruit. C'est sans doute pour cette raison que peu d'Élus partagent leur secret…",
      ),
      DraconicFavor(
        sphere: MagicSphere.nature,
        linkProgress: DraconicLinkProgress.cinquiemeNiveau,
        isDefault: true,
        title: "L’ordre primordial",
        description: "Cette Faveur permet au personnage de dresser autour de lui une barrière magique, translucide et fluctuante, capable de repousser n'importe quelle créature corrompue. Aucun jet n’est nécessaire. Le champ de protection s’étend, de façon sphérique, sur un diamètre total égal à deux fois la Volonté du personnage en mètres. Tout animal, dragon ou être humain qui franchit le seuil subit instantanément 10 points de dommages pour chaque Point de Tendance Homme ou Fatalité qu'il possède. Cette attaque n’affecte pas les individus présents dans la sphère au moment où la Faveur se déclenche. Tant qu’elle reste dans la zone, la créature subit ce même nombre de points de dommages au début de chaque tour. Les animaux, sauvages et domestiques, ne disposent d'aucun Point de Tendance.",
      ),
    ],

    MagicSphere.reves: [
      DraconicFavor(
        sphere: MagicSphere.reves,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "Le monde éthéré",
        description: "Cette Faveur est très puissante, mais elle ne peut être utilisée que durant la nuit, car elle utilise les rêves convoyés par la Chimère. Grâce à cet avantage, le personnage peut modeler un rêve et l'envoyer à un individu de son choix afin de faire passer un message ou de provoquer un cauchemar. La Difficulté du jet de Mental + Empathie varie en fonction du degré de connaissance qui unit les deux personnes. S'il s’agit d’amis de longue date, de parents ou de proches compagnons, la Difficulté est de 10. Si le personnage connaît sa cible de vue ou qu’il ne lui a adressé la parole que quelquefois, elle passe à 15. Si le personnage n’a jamais vu sa cible, la Difficulté est de 20. La possession d’un objet appartenant à la cible ou la préparation d’un rituel magique peut diminuer cette Difficulté, tout comme une défense magique ou un mauvais environnement peut l’augmenter.",
      ),
      DraconicFavor(
        sphere: MagicSphere.reves,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "Empathie Onirique",
        description: "À l'inverse du monde éthéré, l'Empathie onirique peut s'imprégner du rêve d'un autre. Durant la nuit, et pour peu que sa cible dorme, l'Élu peut tenter un jet de Mental + Empathie contre une Difficulté de 10, si la cible est un compagnon, de 15 si elle est connue de vue ou de 20 s'il s'agit d'un inconnu. De plus, cette Difficulté est fort sensible à la distance, à un mauvais environnement ou à une mauvaise préparation – elle peut donc être modifiée, à la discrétion du meneur de jeu.\nÉchec : la victime semble ne pas rêver cette nuit-là. Le vertige s'empare de l'Élu. Si le jet est un échec, il est possible de tenter un second jet avec une Difficulté de +5. Il n’est pas possible d’utiliser cette Faveur après deux contacts infructueux dans une même nuit, quelles qu’en aient été les cibles.\nRéussite simple : l'Elu voit indistinctement les scènes rêvées. Les images restent floues mais peuvent être interprétées.\n1 Niveau de Réussite : l'Élu voit distinctement les scènes rêvées.\n2 Niveaux de Réussite : l'Élu voit distinctement les scènes rêvées et certains éléments importants pour le rêveur prennent des teintes ou des proportions étranges, selon qu'il les juge négatives ou positives pour lui. Par exemple, un objet représentant un danger pourra être plus grand ou plus sombre que dans la vie réelle.\n3 Niveaux de Réussite : comme précédemment, si ce n'est que les détails inutiles sont gommés du rêve pour laisser place aux sentiments du rêveur. L'Élu peut donc ressentir l'angoisse, la peur ou le plaisir qui animent le rêveur.\n4 Niveaux de Réussite et plus : l'Élu est conscient du sens caché des éléments qui apparaissent dans le rêve. Il peut donc, avec certitude, connaître l'importance d'un élément ou l'autre par rapport à la vie réelle.",
      ),
      DraconicFavor(
        sphere: MagicSphere.reves,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Le rêve éveillé",
        description: "À ce niveau de Faveur, l’Élu bénéficie d’un léger décalage dans la perception que les autres ont de lui dans l’espace. Tant qu’il ne se livre à aucune action offensive, la Difficulté pour le toucher augmente de 10 car ses adversaires ont tendance à frapper là où il se trouvait quelques instants plus tôt. Dès que le personnage se manifeste de manière trop visible, en déclarant une attaque ou en lançant un sortilège offensif, il perd le bénéfice de cette Faveur et ne le retrouve qu'après une nuit de sommeil.",
      ),
      DraconicFavor(
        sphere: MagicSphere.reves,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Transe Onirique",
        description: "Durant la nuit, et pour peu que sa cible dorme, l'Élu peut tenter un jet d’opposition Mental + Volonté pour provoquer une crise de somnambulisme. La personne visée se lèvera et se comportera en accord avec le rêve qu'elle est en train de faire - elle peut donc parler, se battre, se déplacer, etc. La crise cesse dès que le rêve prend fin ou dès que la victime subit des dommages. Si ce rêve n'est pas induit magiquement, le meneur de jeu peut déterminer aléatoirement son contenu (1-2 : rêve érotique, 3-4 : rêve paisible, 5-6 : cauchemar angoissant, 7-8 : cauchemar terrifiant, 9-0 : rêve héroïque).",
      ),
      DraconicFavor(
        sphere: MagicSphere.reves,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Rémanence",
        description: "Cette Faveur permet au personnage de partager un souvenir récent d'un être humain avec qui il a établi un contact - une simple discussion suffit généralement. En réussissant un jet de Mental + Empathie contre une Difficulté de 10, il parvient à ressentir et à visualiser sommairement le souvenir qui “hante” le plus son interlocuteur. Avec une réussite simple, le souvenir doit être frais de moins d'une heure. Avec 1 Niveau de Réussite, l'événement peut avoir eu lieu dans la journée ; dans la semaine avec à Niveaux de Réussite, dans le mois avec 3, dans l'année avec 4, etc. De plus, en dépensant 1 Niveau de Réussite, le personnage peut bénéficier d'une dimension supplémentaire - comme le son, les sensations, etc. Si l'interlocuteur du personnage tient à masquer ce souvenir, il faut effectuer un jet d'opposition Mental + Volonté. La Difficulté du jet peut être réduite de 5, voire de 10, si le personnage est parvenu à instaurer une ambiance propice à la confession, à la rêverie, etc.",
      ),
      DraconicFavor(
        sphere: MagicSphere.reves,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "Le manteau de chimère",
        description: "Cette Faveur permet au personnage de lancer et de conserver un dé supplémentaire du Dragon chaque fois qu’il effectue une action impliquant l’Empathie, la psychologie, la perception de l’invisible ou l’onirisme.",
      ),
      DraconicFavor(
        sphere: MagicSphere.reves,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "Le Mentor Éthéré",
        description: "Le personnage peut appeler chaque nuit, sur la réussite d'un jet Mental + Empathie + Tendance Dragon contre une Difficulté de 15, un familier chimérique. Celui-ci lui prodiguera des conseils et lui obéira jusqu'à l'aube. De plus, le Mentor peut agir sur son environnement - il peut donc combattre. L'Élu est convaincu de voir à ses côtés un individu de sexe opposé d'une grande beauté. Tous les autres observateurs distinguent difficilement une forme fantomatique. S'ils réussissent un jet de Mental + Volonté contre une Difficulté de 10, ils discerneront l'être qui hante leurs fantasmes les plus inavoués ; cette image sera d'autant plus parfaite que le nombre de Niveaux de Réussite est élevé. La perte de son Mentor - pour des causes magiques ou parce qu'il se fait tuer dans un combat - plonge l'Elu dans une crise de dépression profonde qui lui fait remettre en cause tous ses acquis. Il gagne le désavantage Trouble mental (Dépression), sa Tendance Dragon est réduite de 1 et sa Sphère des Rêves, de 2 points. Cette crise dure jusqu’à son traitement psychologique (et son rachat en point).",
      ),
      DraconicFavor(
        sphere: MagicSphere.reves,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "Les miroirs des songes",
        description: "Cette Faveur permet à l'Élu de façonner et de projeter des illusions si crédibles qu’il est possible de les toucher, de les sentir, et même de les combattre. Tout d’abord, le personnage doit décrire avec précision l'illusion qu’il souhaite créer. Ensuite, il doit réussir un jet de Mental + Empathie contre ume Difficulté fixée par le meneur de jeu, en fonction de la complexité, de la taille et du degré de réalisme désirés. À titre de référence, créer l'illusion d'un cheval au galop demandera une Difficulté de 5. Cette Difficulté sera augmentée de 5 si les chevaux sont en troupeau et proches de l'observateur, de 10 s'ils se précipitent pour piétiner le spectateur… Une telle illusion dure un nombre de tours égal à la valeur d’Empathie du personnage.\n Il est cependant possible de la maintenir en réussissant, à chaque tour supplémentaire, un jet de Mental + Volonté contre la Difficulté de création de l'illusion, augmentée de 5 par tour. Seuls les Élus de Nenya et les dragons ont une chance de comprendre qu’il s’agit d’une illusion, en réussissant un jet de Mental + Empathie contre la Difficulté de création +5.",
      ),
      DraconicFavor(
        sphere: MagicSphere.reves,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "Absence",
        description: "Pour utiliser cette Faveur très puissante, le personnage doit tout d'abord établir un contact physique avec sa cible. Ensuite, en réussissant un jet d’opposition Mental + Empathie contre Mental + Volonté de la cible. Le personnage peut lui poser une question + une par Niveau de Réussite - questions auxquelles ce dernier répondra par l'entière vérité et sans même s'en rendre compte. La victime de cette Faveur ne garde aucun souvenir, mais peut avoir l'impression d'avoir eu une absence passagère, comme si elle était perdue dans ses songes. Elle ne peut bien évidemment répondre qu'à des questions dont elle connaît la réponse - et peut, au besoin, effectuer un jet de Mental + Intellect pour y réfléchir.",
      ),
      DraconicFavor(
        sphere: MagicSphere.reves,
        linkProgress: DraconicLinkProgress.cinquiemeNiveau,
        isDefault: true,
        title: "L’abîme de l'esprit",
        description: "Une fois par nuit, le personnage peut s’insinuer dans les songes d’un être humain avec qui il a déjà eu un contact, physique ou verbal, et lui dérober une partie de sa mémoire. Il est ainsi possible de ne gommer qu’une simple phrase, mais aussi une semaine toute entière. Le personnage ne peut effacer plus de journées de souvenirs qu’il ne possède de points d’Empathie.",
      ),
    ],

    MagicSphere.cite: [
      DraconicFavor(
        sphere: MagicSphere.cite,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "L’esprit des cités",
        description: "Cette Faveur, active en permanence, permet au personnage de se sentir particulièrement à l'aise dans les cités. Tout d’abord, il n’a pratiquement aucune chance de s'y perdre et peut effectuer un jet de Mental + Empathie contre une Difficulté de 10 pour tenter de trouver un quartier, une fontaine ou tout autre lieu courant. Cette Difficulté passe à 15 pour découvrir un magasin particulier, et à 20 pour trouver un endroit inhabituel ou masqué, tel qu’une guilde secrète, la demeure d’un herboriste indépendant, etc. Cette Faveur confère également un bonus de 3 à tous les jets de Social effectués en cité pour marchander, négocier des informations, intercepter des rumeurs, etc.",
      ),
      DraconicFavor(
        sphere: MagicSphere.cite,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "L’Âme des Cités",
        description: "Le personnage peut entrer en résonance avec son environnement urbain afin de trouver toute personne dont il connaît le nom et le visage - une simple description ne suffit pas. En réussissant un jet d'Empathie + Vie en Cité contre une Difficulté de 15, il peut identifier avec certitude le dernier trajet que sa cible a effectué. Cette Difficulté passe à 20 si sa cible se cache et à 25 si elle se déplace ou se trouve dans un site contre son gré - par exemple, si elle a été enlevée ou séquestrée.",
      ),
      DraconicFavor(
        sphere: MagicSphere.cite,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Le confort du foyer",
        description: "En réussissant un jet d’Empathie + Vie en cité contre une Difficulté de 10, l’Élu peut connaître parfaitement les plans de la maison qu’il touche comme s’il l’habitait depuis toujours. De plus, pour chaque NR, le personnage peut obtenir une information supplémentaire de son choix (passages dérobés, sources de chaleur, présence d'hommes ou de dragons, etc.).",
      ),
      DraconicFavor(
        sphere: MagicSphere.cite,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "L’Âme du Foyer",
        description: "En réussissant un jet d'Empathie + Vie en Cité contre une Difficulté de 20, l'Élu peut prendre connaissance des événements qui se sont déroulés dans un bâtiment au sein duquel il se trouve. Chaque Niveau de Réussite lui permet de remonter de 10 ans dans l'histoire de l'immeuble. L'information ainsi récoltée sera exprimée en termes d'émotions - peur, haine, amour, violence - et d'images mentales troubles - mouvements, gestes brusques - mais en aucun cas elle ne révélera une identité exacte ou ne permettra d'entendre précisément des sons.",
      ),
      DraconicFavor(
        sphere: MagicSphere.cite,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "L’Esprit du Commerce",
        description: "En manipulant un objet et en réussissant un jet de Manuel + Empathie contre une Difficulté de 10, le personnage peut identifier distinctement la provenance dudit objet - origines de fabrication et véritable propriétaire actuel. Chaque Niveau de Réussite permet de tracer le parcours de l'objet et de remonter de deux possesseurs légitimes. Les indications géographiques fournies resteront floues et générales. En revanche, les noms des propriétaires seront précis, mais correspondront aux noms couramment utilisés par l'entourage de ceux-là - par exemple, Hekym Aziel étant connu par ses hommes de troupe sous le nom d'Hekym-Le-Rouge, c'est cette seconde appellation qui sera restituée par son arme si on l'interroge.",
      ),
      DraconicFavor(
        sphere: MagicSphere.cite,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "L’œil du secret",
        description: "En réussissant un jet de Social + Empathie contre une Difficulté de 15, le personnage peut obtenir une information concernant la Tendance, l’affiliation, la mentalité ou l’éventuel Lien d’un homme qu’il observe, Pour chaque NR, le personnage pourra apprendre une information supplémentaire. Cette Faveur permet de déterminer la Tendance majeure d'un individu, la nature et le degré de son Lien draconique, ainsi que ses implications dans une mouvance affiliée à l’une des trois Tendances. Une seule tentative est possible par individu par jour.",
      ),
      DraconicFavor(
        sphere: MagicSphere.cite,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "L’Insignifiance du Mendiant",
        description: "Une fois par jour, le personnage peut devenir insignifiant aux yeux des autres humains. En réussissant un jet de Mental + Empathie + Tendance Homme contre une Difficulté de 20, il passe totalement inaperçu durant 10 minutes. Chaque Niveau de Réussite rajoute 10 minutes à son “insignifiance”. L'Élu peut se déplacer, parler, utiliser la magie ou des objets… personne ne fait attention à lui ! Ceci ne veut pas dire qu'il est invisible - il est juste capable de se faire oublier. En situation critique, par exemple, gardes vigilants, personne seule dans une pièce, les autres protagonistes de la scène peuvent tenter un jet de Mental + Perception contre une Difficulté de 15 + Tendance Homme afin de remarquer l'intrus. Pendant la durée de l'effet de cette Faveur, l'Élu souffre d'un malus de 10 à tous ses jets pour toutes les Compétences Sociales.",
      ),
      DraconicFavor(
        sphere: MagicSphere.cite,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "Les mille visages de Khy",
        description: "Cette Faveur permet à l’Élu qui en bénéficie de changer d’apparence, de taille, de poids et même de sexe, en à peine quelques secondes. Pour ressembler à quelqu'un qu’il connaît, il lui faudra effectuer un jet de Social + Volonté contre une Difficulté de 15. Cette Difficulté est augmentée de 5 pour ressembler à un individu de vague connaissance, et de 10 pour imiter le visage d’un portrait ou d'une esquisse.",
      ),
      DraconicFavor(
        sphere: MagicSphere.cite,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "Le Reflet des Cités",
        description: "Cette Faveur est utilisable, au sein d'une même cité, un nombre de fois égal au niveau de Lien du personnage. En réussissant un jet de Mental + Volonté contre une difficulté de 25, l'Élu peut modifier réellement la structure urbaine qui l'entoure pour une durée de 5 minutes plus 5 minutes supplémentaires par Niveau de Réussite. En l'espace d'un instant, les immeubles, les rues, les fortifications se modifient selon la volonté du personnage. Ces “aménagements” doivent être cohérents - un fortin ne flottera jamais dans les airs - et ne nuiront jamais à l'intégrité des bâtiments - une enceinte ne s'écroulera pas mais pourra, au mieux, se garnir d'une faille.",
      ),
      DraconicFavor(
        sphere: MagicSphere.cite,
        linkProgress: DraconicLinkProgress.cinquiemeNiveau,
        isDefault: true,
        title: "Les portes de la cité",
        description: "À ce niveau, l’Élu est totalement en phase avec chacune des cités qu’il visite et peut, sans effectuer le moindre jet, se déplacer miraculeusement d’un endroit à l’autre de la ville. Pour chaque Point de Chance ou de Maîtrise qu’il dépense, le personnage peut effectuer un “saut” vers n’importe quel endroit de la cité. Généralement, les Élus de Khy se plaisent à emprunter les portes, les arches et les puits pour disparaître et se transporter. Il est impossible de faire voyager un tiers de cette façon, mais l’Élu conserve tout ce qu’il porte sur lui au moment du saut.",
      ),
    ],

    MagicSphere.vents: [
      DraconicFavor(
        sphere: MagicSphere.vents,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "L’élan des brises",
        description: "Cette Faveur permet au personnage de lancer un dé supplémentaire pour déterminer son Initiative ou de tirer un projectile supplémentaire lorsqu'il utilise une arme à distance classique (de jet ou à projectiles par opposition aux armes interdites des Humanistes, telles que les arbalètes, les balistes, etc.). Il est possible d’utiliser cette Faveur trois fois par jour, réparties selon les applications de son choix (deux fois pour l’Initiative et une fois pour les projectiles, par exemple).",
      ),
      DraconicFavor(
        sphere: MagicSphere.vents,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "Les Vents Perforants",
        description: "Grâce à cette Faveur, le personnage peut lancer un nombre de projectiles invisibles égal à son niveau de Lien. Ces projectiles peuvent seulement être lancés un nombre de fois par jour égal à la Tendance Dragon du personnage. De plus, ils ont les particularités suivantes :Init.+1 / Act. 1 / Portée 120/300 m / Dom. VOL+5+1D10. Pour toucher sa cible, le personnage doit utiliser la compétence Armes à projectiles.",
      ),
      DraconicFavor(
        sphere: MagicSphere.vents,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Le murmure du vent",
        description: "À ce niveau, le personnage acquiert un sixième sens qui le prévient généralement du danger. Il sait instinctivement, par exemple, si une route risque d’être dangereuse et risque de se réveiller naturellement si des ennemis s’approchent de l’endroit où il dort. Le meneur de jeu doit effectuer un jet de Mental + Empathie contre une Difficulté de 20 pour le prévenir à temps.",
      ),
      DraconicFavor(
        sphere: MagicSphere.vents,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "L’Indiscrétion du Zéphyr",
        description: "Moyennant un jet de Mental + Perception contre une Difficulté de 20, l'Elu peut entendre distinctement ce qui est dit par une ou plusieurs personnes dans son champ de vision. Il n'y a pas de distance maximale à cette écoute tant que les personnes ciblées sont visibles distinctement - des ombres ou des reflets ne suffisent pas.",
      ),
      DraconicFavor(
        sphere: MagicSphere.vents,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "La fortune du voyageur",
        description: "En atteignant ce niveau, le personnage devient chanceux et regagne deux Points de Chance au lieu d’un à chaque échec. De plus, il peut toujours relancer une fois le dé du Dragon lorsqu'il fait appel aux Tendances, mais doit dans ce cas conserver ce second jet.",
      ),
      DraconicFavor(
        sphere: MagicSphere.vents,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "L’Empathie du Voyageur",
        description: "Une fois par jour, l'Élu peut avoir pleinement conscience de ce qui se déroule en une région du Royaume de Kor, qu'il la connaisse ou non, d'une superficie maximum égale à son niveau de Lien fois 10 km2. En se concentrant et en réussissant un jet de Mental + Perception + Tendance Dragon contre une Difficulté de 25, il aura l'impression de survoler cette zone et d'appréhender tons les détails du paysage. Le personnage gagne ainsi, jusqu'à la fin du jour, un bonus égal à sa Tendance Dragon pour les compétences Géographie, Orientation, Pister et Stratégie, si elles sont utilisées en relation avec la région ainsi “visitée”.",
      ),
      DraconicFavor(
        sphere: MagicSphere.vents,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "La légèreté des embruns",
        description: "À ce niveau de Faveur, l’Élu est capable de voler à volonté. Il n’est plus retenu par les contraintes de la gravité et peut se déplacer dans toutes les directions à la vitesse de la course. Il peut même faire des pointes à une vitesse trois fois supérieure pendant une durée égale à sa Résistance en minutes. Bien sûr, il reste à sa charge de gérer les rencontres avec d’éventuels dragons ignorants de son Lien…",
      ),
      DraconicFavor(
        sphere: MagicSphere.vents,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "La Fortune du Bienheureux",
        description: "Une fois par jour, le personnage peut bénéficier d'un coup de pouce du destin. Pour ce faire, il lance un dé contre la somme de son niveau de Lien et de sa Tendance Dragon. Si le chiffre obtenu par le dé est strictement inférieur à la somme, il gagne, pour la journée uniquement, un nombre de points égal au résultat du dé. Les points gagnés s’utilisent comme des points de Chance, mais ne comptent pas dans la valeur actuelle de la Chance du personnage, qui évolue normalement au gré des jets. Les points non dépensés sont perdus au prochain lever du soleil.",
      ),
      DraconicFavor(
        sphere: MagicSphere.vents,
        linkProgress: DraconicLinkProgress.cinquiemeNiveau,
        isDefault: true,
        title: "L’insouciance de Szyl",
        description: "Arrivé à ce stade, l’Élu est capable d'utiliser les éléments climatiques à sa convenance. Il peut faire neiger en été ou encore arrêter une tempête. Il maîtrise la force et la direction du vent ainsi que la densité des nuages. Il peut déchaîner la colère de la nature ou l’apaiser à volonté. Il faut simplement une vingtaine de minutes pour passer d’un grand beau temps à une tornade. Bien entendu, l’Élu est immunisé aux effets néfastes qu’il peut accroître jusqu’à les rendre offensifs, multipliant alors les décharges de foudre ou la grêle par exemple. Il n’a de contrôle que sur leur intensité, ne pouvant les orienter à son gré.",
      ),
      DraconicFavor(
        sphere: MagicSphere.vents,
        linkProgress: DraconicLinkProgress.cinquiemeNiveau,
        isDefault: true,
        title: "Le Pacte des Orages",
        description: "Une fois par combat, l'Élu peut, en réussissant un jet de Mental + Coordination contre une Difficulté de 20, ordonner à la foudre de s'abattre sur lui. En canalisant toute cette énergie, il peut, jusqu'à la fin du combat, ajouter sa Tendance Dragon à chacun des dés de dommages qu'il lance. Cette Faveur est utilisable dès qu’un simple nuage est en vue.",
      ),
    ],

    MagicSphere.ombre: [
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.aucunLien,
        isDefault: true,
        title: "Frayeur",
        description: "Chaque fois qu’un être humain ou animal fait face à l’Élu, il doit réussir un jet de Mental + Volonté ND 10 pour éviter de se sentir en danger, vulnérable et ainsi de recevoir un malus de 5 à toute action pendant 2 minutes. Permanent.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.aucunLien,
        isDefault: true,
        title: "Le Dernier Soupir",
        description: "En établissant un contact physique avec un être humain ou une créature morte, l’Élu peut partager ses dernières émotions − visions, sentiments − en réussissant un jet de Mental + Empathie + Fatalité ND 10 + 5 par tranche de 5 heure écoulées après la mort de la cible. Utilisable une fois par jour.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.aucunLien,
        isDefault: true,
        title: "Sens de la Vie",
        description: "L’Élu peut, s’il réussi un jet de Mental + Perception ND 5 + 5 par km de diamètre supplémentaire, sentir la présence de n’importe quelle forme de vie dans un diamètre de 1 km. Permanent.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.aucunLien,
        isDefault: true,
        title: "Vision nocturne",
        description: "L’Élu voit normalement dans les ténèbres naturelles et bénéficie d’un bonus de 2 à tous ses jets de Perception − tous sens confondus − effectués dans l’ombre ou au cours de la nuit. Permanent.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.premierNiveau,
        isDefault: true,
        title: "La marque de l'ombre",
        description: "Cette Faveur accorde au personnage le droit de développer la Sphère de l'Ombre, qui lui ouvre les portes de la magie de Kalimsshar. Qu'il s'agisse ou non d’un mage, le personnage pourra développer cette Sphère en dépensant des Points de Compétences à la création ou des Points d’Expérience en cours de campagne.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "L'ombre du doute",
        description: "Cette Faveur permet au personnage d'instaurer le doute et de provoquer la peur dans l’esprit de son adversaire. Pour l'utiliser, le joueur doit effectuer un jet d'opposition de Social + Volonté contre Mental + Volonté de sa cible. Le doute s’insinue dans l'esprit de la victime pendant un nombre de minutes égal au nombre de NR de différence.\nDurant cette période, la victime devra réussir un jet de Mental + Volonté contre une Difficulté de 15 chaque fois qu’elle tentera de s’en prendre au personnage, que ce soit par une action physique, un pouvoir magique ou une simple altercation verbale. De plus, tous ses jets basés sur le Mental voient leur Difficulté augmenter de 5. Si la victime échoue à ce jet, il lui est totalement impossible de s’en prendre au bénéficiaire de cette faveur. Ce pouvoir peut être utilisé trois fois par jour, mais il est inutile de rappeler que les manifestations des pouvoirs de l’ombre sont très mal considérées.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "L'Appel de l'Ombre",
        description: "En réussissant un jet d’opposition de Mental + Empathie contre Mental + Volonté de la cible, cette dernière avoue spontanément sa plus grande angoisse. Par Niveau de Réussite supplémentaire, elle exprimera volontairement une peur enfouie presque aussi profondément dans son inconscient.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Aura Ténébreuse",
        description: "En réussissant un jet de Mental + Présence + Tendance Fatalité contre une Difficulté de 20, l'Élu dégage une aura maléfique d'une noirceur absolue. Cette aura absorbe toute lumière dans une zone de deux mètres autour de l'Élu. Chaque Niveau de Réussite augmente cette zone d'influence de deux mètres. Au cœur de l'aura plus aucune source lumineuse ne fonctionne. Toute personne prise dans l'aura se sent totalement aveugle et seul l'Élu peut s'y repérer. L'aura peut durer dix minutes par niveau de Lien.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.deuxiemeNiveau,
        isDefault: true,
        title: "Sensation de la Faute",
        description: "Cette Faveur permet de percevoir chez un individu une ou plusieurs des fautes qu'il a commises au cours de sa vie. Généralement, plus la victime a de remords, plus son péché sera facile à détecter. Pour l'utiliser, le joueur doit effectuer un jet de Mental + Empathie contre un jet de Mental + Volonté de sa cible. Si le joueur l'emporte sur sa cible, il découvre une faute commise par sa victime, plus une pour chaque Niveau de Réussite obtenu. La Difficulté peut être réduite si le personnage dispose de certaines informations lui permettant de mieux connaître le passé de sa cible ou si cette dernière est particulièrement rongée par le remords.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "Le manteau de l’ombre",
        description: "En se concentrant, l’Élu peut disparaître à la vue de ses observateurs. Cette Faveur est plus efficace de nuit, dans un endroit peu éclairé ou encore par temps sombre plutôt qu’en plein soleil. Pour que le pouvoir soit activé, le personnage ne doit pas être visible lorsqu'il le déclenche. Dans des conditions favorables, le personnage qui désire utiliser cette capacité doit effectuer un jet de Mental + Empathie contre une Difficulté de 10. S'il réussit, il disparaît dans l’ombre, la chaleur de son corps baisse pour s’adapter à la température ambiante, ses mouvements ne font plus de bruits et il ne dégage plus aucune odeur. Il est virtuellement indétectable par tout autre moyen naturel que l’écholocation d’une chauve-souris. Il ne redevient visible que s’il se manifeste physiquement, en parlant ou en réalisant une action offensive. Il peut cependant tenter de rester caché en réussissant un jet Mental + Discrétion contre une Difficulté de 25. Dans des conditions moins favorables, le jet initial est Mental + Empathie contre une Difficulté de 20, et toute action signale automatiquement la présence de l'utilisateur. Cette Faveur est utilisable trois fois par jour.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "Corruption",
        description: "Cette Faveur permet de faire naître la corruption dans l'esprit d'une victime. Cette dernière, si elle cède à la corruption, pourra commettre des actes épouvantables - comme trahir ses camarades ou massacrer des innocents. Le joueur doit effectuer un jet en opposition de Mental + Volonté contre sa cible, qui subit un malus à ce jet égal à sa propre Tendance Fatalité. Si le jet est réussi, la corruption s'est introduite dans l'esprit de la victime. Pour chaque Niveau de Réussite obtenu, la victime sera sujette à un accès de corruption qui lui fera commettre des actes barbares, vicieux ou contraires à son éthique. Il appartient au meneur de jeu de décider de la manifestation exacte de chacun de ces “accès”. Pour tenter de résister, la victime peut effectuer un jet de Mental + Volonté contre une Difficulté de 15 pour la première crise, de 20 pour la suivante, puis de 25, etc. Les crises cessent une fois que tous les accès de corruption ont été gérés - qu'ils soient réussis ou ratés - et que la victime en a subi les éventuelles conséquences (gains de cercles de Tendance, sanctions, etc.). Note : un personnage n'effectue aucun jet s'il accepte de son plein gré ou ne manifeste aucune réticence.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "Masque de Mort",
        description: "En réussissant un jet d’opposition de Mental + Empathie contre Mental + Volonté de la cible, l'Élu provoque chez cette dernière une expérience traumatisante : vivre sa propre mort ! Cette illusion angoissante tétanise littéralement la victime qui subit ainsi un malus de 10 à toutes ses actions durant la prochaine heure. La sensation et la vision vécues ne sont que des illusions et sont sans rapport avec une réelle projection dans le futur.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.troisiemeNiveau,
        isDefault: true,
        title: "Le manteau de l’ombre",
        description: "En se concentrant, l’Élu peut disparaître à la vue de ses observateurs. Cette Faveur est plus efficace de nuit, dans un endroit peu éclairé ou encore par temps sombre plutôt qu’en plein soleil. Pour que le pouvoir soit activé, le personnage ne doit pas être visible lorsqu'il le déclenche. Dans des conditions favorables, le personnage qui désire utiliser cette capacité doit effectuer un jet de Mental + Empathie contre une Difficulté de 10. S'il réussit, il disparaît dans l’ombre, la chaleur de son corps baisse pour s’adapter à la température ambiante, ses mouvements ne font plus de bruits et il ne dégage plus aucune odeur. Il est virtuellement indétectable par tout autre moyen naturel que l’écholocation d’une chauve-souris. Il ne redevient visible que s’il se manifeste physiquement, en parlant ou en réalisant une action offensive. Il peut cependant tenter de rester caché en réussissant un jet Mental + Discrétion contre une Difficulté de 25. Dans des conditions moins favorables, le jet initial est Mental + Empathie contre une Difficulté de 20, et toute action signale automatiquement la présence de l'utilisateur. Cette Faveur est utilisable trois fois par jour.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "Le parfum de la corruption",
        description: "À ce niveau, le Lien avec Kalimsshar se fait plus fort. Ce dernier accorde à son serviteur, par l’intermédiaire du dragon, une parcelle de son pouvoir. Le joueur peut lancer un dé de Fatalité supplémentaire chaque fois qu’il fait appel aux Tendances. S'il décide de conserver les dés de la Fatalité, il peut additionner les deux.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "Remords",
        description: "Cette Faveur permet d'accroître le remords qu'éprouve un personnage pour un acte qu'il a commis dans le passé. Il faut nécessairement connaître la nature exacte de cet acte (grâce à la Faveur Sensation de la Faute, par exemple) pour pouvoir utiliser cette Faveur. Le joueur doit effectuer un jet de Mental + Volonté en opposition contre sa cible, mais cette dernière subit comme malus la valeur de sa propre tendance Fatalité. Si la réussite est normale, la victime éprouvera un profond remords et sera en proie au doute pour le reste de la journée. Avec un Niveau de Réussite supplémentaire, la victime gagne 3 cercles de Fatalité et s'emporte dès que l'on aborde le sujet, au risque de provoquer de violents conflits. Avec deux Niveaux de Réussite, elle gagne 5 cercles de Fatalité et sa faute le ronge, se transformant en une véritable paranoïa. Avec trois niveaux de réussite, la victime gagne automatiquement 1 point de Tendance Fatalité et devient véritablement obsédé par sa faute, remettant en cause l’enseignement de sa voie, la parole de ses amis, etc. La victime de ce pouvoir peut se libérer du remords en réparant son erreur ou en acceptant 1 point de Fatalité qu'elle ne pourra effacer qu'une fois sa faute rachetée.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.quatriemeNiveau,
        isDefault: true,
        title: "Membre Spectral",
        description: "L'Élu ouvre les portes du Royaume de l'Ombre pour gagner un nouveau membre spectral. En réussissant un jet de Mental + Volonté + Tendance Fatalité contre une Difficulté de 20, l'Élu voit un de ses membres remplacé par une horrible parodie spectrale. Cette excroissance maléfique peut servir d'arme (Compétence Corps à corps) et inflige FOR + 5 + 1D10 dommages ; chaque Niveau de Réussite confère 2 points de dommages supplémentaires. De plus, les adversaires de l'Élu doivent réussir un jet de Mental + Volonté contre une Difficulté de 20 pour ne pas fuir terrorisés ! L’effet de terreur qu’il provoque ne s’applique qu’au premier regard. Si l’adversaire le surmonte, il y résiste pour toute la durée de la présence spectrale, soit une heure par niveau de lien. Ce membre spectral atteint directement l’âme de la victime et ignore toute armure ou protection surnaturelle (sauf celles octroyées par Kalimsshar). Seules les créatures immortelles sont insensibles à cette excroissance (Jyr, Sercya, Grands Dragons).",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.cinquiemeNiveau,
        isDefault: true,
        title: "Le souffle de vie",
        description: "Le Lien atteint ici son niveau maximum. Il se manifeste par un partage entre le dragon et l’Élu du souffle de vie. Si l’un vient à mourir, l’autre succombera aussi vingt-quatre heures après la mort de son compagnon. Pendant ce laps de temps, il subira d’incroyables souffrances - étant d’une certaine manière déjà mort. Il revivra sans cesse l’agonie de son compagnon et dérivera lentement vers la folie. Tant qu’ils sont tous deux en vie, ils sont aussi immortels l’un que l’autre et arrêtent même de vieillir. Ils bénéficient de plus tous deux des Seuils de blessures du dragon.",
      ),
      DraconicFavor(
        sphere: MagicSphere.ombre,
        linkProgress: DraconicLinkProgress.cinquiemeNiveau,
        isDefault: true,
        title: "Ombre Traîtresse",
        description: "Cette terrifiante Faveur permet d'animer l'ombre d'une victime pour la faire attaquer son propriétaire. Le joueur effectue un jet de Mental + Empathie contre une Difficulté de 10. L'ombre reste animée 1 tour + 1 par Niveau de Réussite obtenu. Elle attaque, en tentant de l'étrangler, avec les mêmes Caractéristiques et Attributs physiques que sa proie, mais augmentés de 1 point pour chaque Niveau de Réussite obtenu. L'ombre inflige des blessures physiques et des dommages correspondant aux armes, à la Force et aux bonus éventuels de son double, mais ne peut saisir ou influencer aucune autre matière physique que les copies des armes dont dispose sa victime ; de plus, elle ne bénéficie pas des Bénéfices, Techniques, Privilèges, Faveurs ou accès à la magie du personnage copié. Elle ne peut être atteinte que par son double et ne subit que la moitié des dommages physiques et magiques infligés par lui. Par contre, elle se volatilise immédiatement dès qu'elle disparaît physiquement à la vue - dans d'autres ombres, par exemple, ou à la tombée de la nuit.",
      ),
    ],
  };
}