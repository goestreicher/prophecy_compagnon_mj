import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'magic.dart';

part 'draconic_link.g.dart';

enum DraconicLinkProgress {
  aucunLien(title: 'Aucun lien'),
  prelude(title: 'Prélude'),
  premierNiveau(title: 'Premier Niveau'),
  deuxiemeNiveau(title: 'Deuxième Niveau'),
  troisiemeNiveau(title: 'Troisième Niveau'),
  quatriemeNiveau(title: 'Quatrième Niveau'),
  cinquiemeNiveau(title: 'Cinquième Niveau'),
  ;

  final String title;

  const DraconicLinkProgress({ required this.title });
}

class DraconicLinkFavor {
  const DraconicLinkFavor({ required this.title, required this.description });

  final String title;
  final String description;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DraconicLink {
  DraconicLink({
    required DraconicLinkProgress progress,
    required this.dragon,
    required MagicSphere sphere,
  })
    : progressNotifier = ValueNotifier<DraconicLinkProgress>(progress),
      sphereNotifier = ValueNotifier<MagicSphere>(sphere);

  DraconicLink.empty()
    : progressNotifier = ValueNotifier<DraconicLinkProgress>(DraconicLinkProgress.aucunLien),
      dragon = '',
      sphereNotifier = ValueNotifier<MagicSphere>(MagicSphere.pierre);

  @JsonKey(includeFromJson: false, includeToJson: false)
  ValueNotifier<MagicSphere> sphereNotifier;
  MagicSphere get sphere => sphereNotifier.value;
  set sphere(MagicSphere s) => sphereNotifier.value = s;

  String dragon;

  @JsonKey(includeFromJson: false, includeToJson: false)
  ValueNotifier<DraconicLinkProgress> progressNotifier;
  DraconicLinkProgress get progress => progressNotifier.value;
  set progress(DraconicLinkProgress p) => progressNotifier.value = p;

  static List<DraconicLinkFavor> favors({ required DraconicLinkProgress progress, required MagicSphere sphere }) {
    var ret = <DraconicLinkFavor>[];
    for(var i = DraconicLinkProgress.premierNiveau.index; i <= progress.index; ++i) {
      ret.add(_favors[sphere]![DraconicLinkProgress.values[i]]!);
    }
    return ret;
  }

  factory DraconicLink.fromJson(Map<String, dynamic> j) => _$DraconicLinkFromJson(j);

  Map<String, dynamic> toJson() => _$DraconicLinkToJson(this);

  static final Map<MagicSphere, Map<DraconicLinkProgress, DraconicLinkFavor>> _favors = {
    MagicSphere.pierre: {
      DraconicLinkProgress.premierNiveau: DraconicLinkFavor(
        title: "La peau de pierre",
        description: "Cette Faveur permet au personnage de créer un champ de force magique pour renforcer la protection d’une armure ou instaurer une barrière autour d’un individu sans défense. En réussissant un jet de Mental + Volonté contre une Difficulté de 10, le personnage permet à sa cible de bénéficier d’un nombre de champs égal à son nombre de Niveaux de Réussite plus 1. Chaque fois que le destinataire du pouvoir est touché, un de ces champs disparaît sans qu’aucune blessure ne lui soit infligée. Ensuite, une fois tous les champs disparus, le destinataire subit normalement les dommages. Ce pouvoir ne peut être utilisé que trois fois par jour, et seulement une fois par cible.",
      ),
      DraconicLinkProgress.deuxiemeNiveau: DraconicLinkFavor(
        title: "Les reflets de glaise",
        description: "En réussissant un jet de Manuel + Volonté contre une Difficulté de 10, le personnage peut modeler à sa guise un volume de roche d’un mètre cube. Du moment qu'il entretient un contact physique avec la roche, il peut ainsi façonner, creuser, déloger, solidifier, bâtir, etc. Il faut un tour complet avant que la roche ne devienne meuble, puis le personnage dispose d’un nombre de tours égal à la valeur de sa Tendance Dragon avant qu’elle ne se solidifie à nouveau. S'il le désire, il peut bien entendu solidifier la roche avant ce délai. Cette Faveur peut être utilisée une fois par jour.",
      ),
      DraconicLinkProgress.troisiemeNiveau: DraconicLinkFavor(
        title: "Les portes de silice",
        description: "Deux fois par jour, en réussissant un jet de Physique + Volonté contre une Difficulté de 5, le personnage peut se fondre dans la pierre et traverser n'importe quelle surface minérale, emportant avec lui tout ce qu’il porte de matière inerte. Cette immatérialité reste active pendant (3 + NR) tours. Dans la roche, le personnage progresse à la vitesse de la marche. S'il est toujours dans la pierre au moment où les effets de la Faveur expirent, il ne meurt pas, mais reste prisonnier jusqu’au lendemain. Le personnage conserve ses facultés de perception et peut toujours communiquer par télépathie, mais il est incapable d'effectuer le moindre mouvement.",
      ),
      DraconicLinkProgress.quatriemeNiveau: DraconicLinkFavor(
        title: "À l'ombre des montagnes",
        description: "En utilisant cette Faveur, le personnage peut faire profiter ses proches compagnons de la protection de son armure, de son bouclier et de ses éventuels enchantements défensifs. Une fois activé, le mécanisme de défense reste efficace jusqu’au terme du combat, à moins que le personnage et ses compagnons ne s'éloignent de plus de deux mêtres les uns des autres. Tous les individus présents dans une zone de deux mètres de rayon autour du personnage bénéficient de sa protection. Leur Indice de protection d’armure devient égal à celui du personnage, bouclier compris, et l’Élu peut effectuer une parade gratuite par tour de combat, pour protéger un de ses compagnons. Cette parade ne dépense pas de dé d'action, mais reste soumise aux éventuels malus dus à des actions précédentes dans le tour. Cette Faveur peut être utilisée sans limitation.",
      ),
      DraconicLinkProgress.cinquiemeNiveau: DraconicLinkFavor(
        title: "Le cercle de pierre",
        description: "À ce stade, le personnage devient suffisamment important aux yeux du Grand Dragon de la Pierre pour intégrer le cercle des protecteurs de Brorne. S'il n’est pas déjà membre de cette caste, il devient protecteur et obtient le Statut de Capitaine, qui correspond au troisième Statut, ainsi que tous les Bénéfices et Techniques découlant de ce Statut. S'il est déjà membre, il est automatiquement promu au Statut supérieur et peut choisir gratuitement deux Privilèges de caste. Dans tous les cas, la Résistance du personnage est définitivement augmentée de 3 et il gagne une deuxième case de blessure mortelle.",
      ),
    },

    MagicSphere.feu: {
      DraconicLinkProgress.premierNiveau: DraconicLinkFavor(
        title: "L’œil incandescent",
        description: "Le personnage peut percevoir la chaleur dégagée par tous les corps chauds (êtres humains, animaux, feux de camp, etc.) sur une distance maximale de dix mètres par point de Perception. Lorsqu'il utilise ce pouvoir, il doit cependant modifier sa vision et son regard ne balaie plus qu’un angle restreint. Ses jets de Perception classiques sont réduits de 3. Le personnage doit, de plus, effectuer un jet de Mental + Perception contre une Difficulté de 10 pour déterminer avec exactitude la nature de la masse de chaleur qu’il observe. Chaque NR peut lui donner une information supplémentaire (la créature est blessée, le feu est d’origine magique, etc.).",
      ),
      DraconicLinkProgress.deuxiemeNiveau: DraconicLinkFavor(
        title: "Le flot de lave",
        description: "Grâce à cette Faveur, le personnage peut, à tout moment d’un combat, décider de ne plus effectuer la moindre action de défense jusqu’à la fin de l'affrontement. La Difficulté de tous ses jets d’attaque n’est alors plus augmentée par les pénalités d'actions supplémentaires. De plus, tous ses dommages sont augmentés de 3 fois la valeur de la Tendance Dragon du personnage. Une fois la Faveur déclenchée, il est tout simplement impossible de tenter la moindre action défensive.",
      ),
      DraconicLinkProgress.troisiemeNiveau: DraconicLinkFavor(
        title: "La cérémonie du volcan",
        description: "En utilisant cette Faveur, le personnage peut s’enflammer littéralement, transformant son corps en une véritable torche vivante. Les effets de ces flammes ne lui causent aucun désagrément, mais toutes les créatures et les matières inflammables qui entrent en contact avec lui subissent les dommages du feu. Chaque contact provoque une brûlure causant (15 + 1D10) points de dommages. Ces dommages sont doublés dans le cas de créatures particulièrement sensibles au feu. De plus, toutes les matières inflammables ont 50% de chance de prendre feu dès le premier contact. Les flammes perdurent pendant 10 tours pour chaque Point de Tendance Dragon que possède le personnage. Les flammes disparaissent immédiatement si le personnage fait appel aux Tendances et conserve un autre dé que celui du Dragon, ou si le dé du Dragon obtient un 1, qu’il soit ou non conservé.",
      ),
      DraconicLinkProgress.quatriemeNiveau: DraconicLinkFavor(
        title: "La danse des étincelles",
        description: "Cette Faveur permet au personnage d’entrer dans une transe hypnotique, sorte de frénésie guerrière accompagnée d’une danse effrénée. Le personnage se met à tournoyer sur lui-même à grande vitesse puis, après quelques secondes, devient capable de se déplacer et de combattre sans cesser de tournoyer. Toutes les attaques portées contre lui voient leur Difficulté augmenter de 5. De plus, le personnage voit le dé d’Initiative de toutes ses actions augmenter de 4 et double sa Force lorsqu'il inflige des dommages.",
      ),
      DraconicLinkProgress.cinquiemeNiveau: DraconicLinkFavor(
        title: "Le feu intérieur",
        description: "Le Lien octroyé par Kroryn permet au personnage de puiser dans sa propre énergie vitale pour faire naître le feu, à l’image des dragons qui soufflent leur venin embrasé. En prenant la posture du dragon, le personnage devient capable de cracher un jet de flammes tourbillonnantes qui atteindra automatiquement sa cible, pour peu qu’elle soit située à moins de quarante mètres de lui. Pour chaque case de blessure que le personnage décide de noircir, en commençant par les égratignures, le jet de flammes inflige 20 points de dommages à la cible et toutes les cibles présentes dans un rayon de dix mètres autour de la trajectoire du jet. Toutes les créatures particulièrement sensibles au feu subissent le double des dommages. Les dragons du feu et les créatures immunisées divisent les dommages par deux. Il faut une action pour activer la Faveur et une autre pour cracher le jet de flammes.",
      ),
    },

    MagicSphere.oceans: {
      DraconicLinkProgress.premierNiveau: DraconicLinkFavor(
        title: "Le secret du verbe",
        description: "Le personnage est jugé digne de l'instruction d’Ozyr. Il peut alors utiliser la langue draconique pure, et ce quelle que soit son éducation ou sa culture. L'esprit du dragon des océans se mêle au sien pour lui insuffler spontanément les multiples figures de style et règles de prononciation de ce langage. Le personnage peut alors s'adresser aux dragons de tous types dans leur langue originelle sans avoir à utiliser la forme abâtardie des hommes. Il peut de plus comprendre intuitivement tous les dialectes et patois dérivés de cette langue sans avoir à s’habituer à l’accent local. Il ne peut par contre pas parler ce dialecte, recourant soit à la langue pure ou à la forme humaine pour s'exprimer. Les dragons apprécient que l’on s'adresse à eux dans la langue pure et cette habileté est un grand atout social vis-à-vis des ailés comme des hommes.",
      ),
      DraconicLinkProgress.deuxiemeNiveau: DraconicLinkFavor(
        title: "L’infinie sagesse",
        description: "Cette Faveur permet au personnage de puiser dans la connaissance d’Ozyr pour obtenir la réponse à une question qu’il se pose. Le joueur doit effectuer un jet de Mental + Empathie contre une Difficulté de 10 et chaque NR lui donne un élément de réponse. Ces éléments peuvent être délayés par le meneur de jeu si celui-ci estime que la question est particulièrement difficile ou que le personnage n’est pas censé tout apprendre tout de suite. En d’autres termes, c’est à lui de se substituer au dragon des océans pour répondre au personnage. Par exemple, s’il tente de découvrir où se cache le mage qu’il traque depuis des semaines, le meneur de jeu peut se contenter de lui répondre “à l’est”, “dans une cité côtière”, “à l’abri du regard de Szyl”, etc.",
      ),
      DraconicLinkProgress.troisiemeNiveau: DraconicLinkFavor(
        title: "Le poids du souvenir",
        description: "En établissant un contact empathique avec n'importe quel être humain consentant, le personnage peut partager la vision d’un souvenir enfoui dans la mémoire de l'individu - ou inversement. La vision peut être vieille de plusieurs années, mais le personnage ne peut maintenir le lien plus d’un nombre de minutes égal à sa Volonté. Pour chaque minute ainsi écoulée, il peut partager une heure de souvenirs réels. Si la personne n’est pas consentante, il est possible de forcer le contact en réussissant un jet d'opposition en Mental + Empathie contre Mental + Volonté de la cible. Un jet réussi ne permet d’établir qu’un contact de quelques secondes, ce qui correspond tout au plus à quelques minutes de souvenirs.",
      ),
      DraconicLinkProgress.quatriemeNiveau: DraconicLinkFavor(
        title: "L’esprit des profondeurs",
        description: "Tout comme le vent colporte les rumeurs, l’eau conserve dans ses profondeurs les secrets de toute chose. Cette Faveur permet au personnage de créer, l’espace de quelques minutes, un lien télépathique très profond avec l’esprit de n'importe quel cours d’eau. En fonction de la taille et de la profondeur de cette source d’eau, le personnage pourra avoir accès à des consciences plus ou moins intelligentes, sensibles et bien disposées. On distingue quatre catégories de cours d’eau : les bassins, les mares, les lacs et les océans.\nPour contacter un esprit, le personnage doit se concentrer et réussir un jet de Mental + Empathie contre une Difficulté de 20 s’il s’agit d’un océan - ou assimilé. Cette Difficulté est réduite de 5 par catégorie de cours d’eau inférieure - soit 15 pour un lac, 10 pour une mare et 5 pour un bassin.\nPour chaque NR obtenu, le personnage a le droit de poser une question à l’esprit qu’il contacte et d'obtenir une réponse fiable. Attention, les esprits de l’eau ne peuvent répondre qu’à des questions théoriques, liées à des connaissances anciennes ou communément répandues, et fournir des informations sur ce dont ils ont été témoins récemment. Ainsi, l’esprit d’un océan pourra parler du bateau qui a gagné le port d’Oforia une semaine plus tôt, ou répondre à des questions concernant l’histoire, mais il n'aura pratiquement aucune chance de connaître le nom d’un marchand résidant à Havre.\nCette Faveur ne peut être utilisée qu’une seule fois par jour pour un seul et même cours d’eau. Généralement, s'ils acceptent de bonne grâce d'aider un Élu d'Ozyr, les esprits marins des grands cours d'eau aiment également “négocier” leurs faveurs, en demandent quelques menus services en échange (réparer un pont, apprendre une nouvelle histoire, faire fuir une meute de prédateurs rôdant aux alentours, etc.).",
      ),
      DraconicLinkProgress.cinquiemeNiveau: DraconicLinkFavor(
        title: "La rive harmonie",
        description: "Grâce à cette Faveur, le personnage peut étendre le champ de sa conscience et profiter de l'expérience de n'importe quel être doué de réflexion, présent dans un rayon égal à sa Volonté en mètres. Trois fois par jour, il peut utiliser cette Faveur pour partager une Caractéristique intellectuelle (Volonté, Intelligence, Perception ou Empathie), un Attribut (Mental ou Social), une Compétence, un sortilège, une Discipline ou n'importe quel autre trait technique (Avantage ou bonus temporaire), à l’exclusion des Privilèges, Techniques, Bénéfices ou Faveurs. Il lui suffit d’annoncer le trait qu’il souhaite “copier” pour que le meneur de jeu lui attribue la meilleure valeur présente aux alentours. Une fois copiée, cette valeur reste effective pendant un nombre de tours égal à son Attribut Mental. Si aucun être vivant ne possède un meilleur score que lui dans le trait annoncé, l’effet de la Faveur est tout de même perdu. Les animaux et les monstres dénués de véritable intelligence ne sont pas affectés par ce pouvoir - faut-il préciser que les dragons sont, quant à eux, incroyablement intelligents ?",
      ),
    },

    MagicSphere.metal: {
      DraconicLinkProgress.premierNiveau: DraconicLinkFavor(
        title: "La main du maître",
        description: "Grâce à cette Faveur, le personnage peut utiliser la technique du Dragon du Métal pour augmenter son Attribut Maîtrise lors d’un combat. Il lui faut effectuer un jet de Physique + Coordination contre une Difficulté de 5 pour gagner 2 Points de Maîtrise par NR. Ces points supplémentaires peuvent être utilisés sans aucune restriction, mais il est impossible de regagner plus de Points de Maîtrise que le score de base possédé par le personnage. Ce pouvoir peut être utilisé une fois par combat, mais le personnage perd tous ses Points de Maîtrise s’il obtient un échec critique lors d’un combat où il a déjà utilisé ce pouvoir. Suite à un échec critique, il pourra regagner normalement ses Points de Maîtrise mais sera incapable d'utiliser de nouveau son pouvoir avant le lendemain.",
      ),
      DraconicLinkProgress.deuxiemeNiveau: DraconicLinkFavor(
        title: "La justesse de l’outil",
        description: "Une fois par jour, en effectuant un jet de Mental + Volonté contre une Difficulté de 15, le personnage peut conférer à n’importe quel objet, arme ou armure, un bonus de NR points. Ce bonus peut s'appliquer à n'importe quelle fonction initiale de l’objet - bonus à la Compétence, aux dommages, au toucher, etc. Une seule utilisation est possible par jour, les bonus perdurent jusqu’au prochain lever du soleil. Il est possible de dépenser des Points de Maîtrise pour augmenter le score de base de ce jet.",
      ),
      DraconicLinkProgress.troisiemeNiveau: DraconicLinkFavor(
        title: "L’enfant du métal",
        description: "En réussissant un jet de Mental + Volonté contre une Difficulté de 15, le personnage peut couvrir de métal l’équivalent d’un tiers de son corps par NR. Ainsi, s’il obtient au moins trois Niveaux de Réussite, son corps tout entier deviendra lisse et solide comme du métal, Les effets de la transformation durent 1 tour par Point de Tendance Dragon du personnage. Toute partie du corps ainsi couverte de métal devient insensible à la température et gagne un Indice de protection naturel de 25. Cette protection peut être cumulée avec une éventuelle armure. Cependant, pour chaque tiers de son corps métallisé, le personnage voit son Initiative réduite d’un dé pendant la durée de l'effet. La transformation est instantanée et peut être effectuée une fois par jour.",
      ),
      DraconicLinkProgress.quatriemeNiveau: DraconicLinkFavor(
        title: "L’âme de l’immatériel",
        description: "Grâce à cette Faveur, active en permanence, le personnage peut communiquer mentalement avec n'importe quel objet qu’il touche ou possède. Cet objet sera capable de lui révéler toutes les informations qui ont pu constituer son passé, comme le nom de ses différents porteurs, l’origine de sa création, ses capacités, ses récents changements de main, etc. Seuls les objets enchantés sont capables d'appréhender la réalité qui les entoure, les autres n’ayant conscience que des individus et objets avec lesquels ils sont entrés en contact physique. Pour établir le contact avec un objet, le personnage doit dépenser 1 Point de Maîtrise. Une fois le contact établi, il reste actif aussi longtemps que le personnage le souhaite, mais se rompt dès que le contact physique est interrompu. Les objets ensorcellés n’ont pas de réfléxion en tant que telle. Dotés d’une sorte de mémoire assez étendue, ils n’ont aucun jugement et aucune conviction capable de nourrir une discussion ou une conversation subtile.",
      ),
      DraconicLinkProgress.cinquiemeNiveau: DraconicLinkFavor(
        title: "Le sang de Kezyr",
        description: "À ce niveau de Lien, le personnage est tellement investi de la force de Kezyr qu’il se met à développer certaines caractéristiques physiques propres aux dragons du métal. Sa peau devient lisse et résistante comme l’acier, conférant un Indice de protection naturel de 10 au personnage. Désormais, aucune arme métallique ne peut plus lui infliger de dommages tant qu’elle n’est pas enchantée par un sortilège de niveau 1 ou supérieur. Enfin, les yeux du personnage deviennent très légèrement luminescents, signe indéniable de son Lien avec Kezyr.",
      ),
    },

    MagicSphere.nature: {
      DraconicLinkProgress.premierNiveau: DraconicLinkFavor(
        title: "Le sang et la sève",
        description: "Cette Faveur accorde au personnage la faculté de soigner les blessures en imposant ses mains sur une plaie, une fracture ou une hémorragie. En réussissant un jet de Mental + Volonté contre une Difficulté de 10, il soigne (1 + NR) blessures en commençant par les plus graves. Cette Faveur peut être utilisée autant de fois par jour que la valeur de la Tendance Dragon de l’Élu.",
      ),
      DraconicLinkProgress.deuxiemeNiveau: DraconicLinkFavor(
        title: "Porté par la nature",
        description: "Une fois par jour, l’Élu peut puiser dans la force de la nature et multiplier par trois la valeur de son Attribut Physique, pour un nombre de tours égal à sa Volonté. Durant ce délai, le personnage ne peut en aucun cas faire appel aux Tendances. Par contre, il peut toujours gagner ou perdre des cercles de Tendance selon ses actions mais toute perte de cercles en tendance Dragon sera doublée durant la période d’utilisation de cette Faveur. Ensuite, l'Élu voit son Attribut Physique réduit de 2 pendant un nombre d’heures égal à 10 moins sa Volonté.",
      ),
      DraconicLinkProgress.troisiemeNiveau: DraconicLinkFavor(
        title: "Le banquet de nature",
        description: "Grâce à cette Faveur, l’Élu peut faire venir à lui un grand nombre d'animaux présents dans la région. Les bêtes qui viendront ne seront pas hostiles et ne se battront pas entre elles. Si l’Élu est capable de communiquer avec eux, les animaux écouteront sa requête et l’aideront de leur mieux, pour peu que sa conduite s’inscrive dans la droite ligne d’Heyra. Sinon, ils repartiront comme ils sont venus. Cette Faveur peut être utilisée une fois par jour. Cette aide peut durer jusqu’au coucher du soleil si la requête que les animaux cherchent à remplir demande beaucoup de temps.",
      ),
      DraconicLinkProgress.quatriemeNiveau: DraconicLinkFavor(
        title: "Le cycle de la vie",
        description: "En utilisant cette Faveur, le personnage peut guérir n'importe quel mal, fracture, trouble ou blessure. Il lui suffit pour cela d’imposer les mains sur l’origine du trouble et focaliser la bonté d’Heyra sur le bénéficiaire des soins. Il peut s'agir de n’importe quelle forme de vie existante. Une fois les soins appliqués, tous les maux sont instantanément guéris, mais le miraculé perd tous ses cercles cochés de Tendances Homme et Fatalité, et le Prodige devient aveugle jusqu’au prochain coucher du soleil. Une journée complète doit s’écouler avant qu’il ne puisse de nouveau utiliser cette Faveur.",
      ),
      DraconicLinkProgress.cinquiemeNiveau: DraconicLinkFavor(
        title: "L’ordre primordial",
        description: "Cette Faveur permet au personnage de dresser autour de lui une barrière magique, translucide et fluctuante, capable de repousser n'importe quelle créature corrompue. Aucun jet n’est nécessaire. Le champ de protection s’étend, de façon sphérique, sur un diamètre total égal à deux fois la Volonté du personnage en mètres. Tout animal, dragon ou être humain qui franchit le seuil subit instantanément 10 points de dommages pour chaque Point de Tendance Homme ou Fatalité qu'il possède. Cette attaque n’affecte pas les individus présents dans la sphère au moment où la Faveur se déclenche. Tant qu’elle reste dans la zone, la créature subit ce même nombre de points de dommages au début de chaque tour. Les animaux, sauvages et domestiques, ne disposent d'aucun Point de Tendance.",
      ),
    },

    MagicSphere.reves: {
      DraconicLinkProgress.premierNiveau: DraconicLinkFavor(
        title: "Le monde éthéré",
        description: "Cette Faveur est très puissante, mais elle ne peut être utilisée que durant la nuit, car elle utilise les rêves convoyés par la Chimère. Grâce à cet avantage, le personnage peut modeler un rêve et l'envoyer à un individu de son choix afin de faire passer un message ou de provoquer un cauchemar. La Difficulté du jet de Mental + Empathie varie en fonction du degré de connaissance qui unit les deux personnes. S'il s’agit d’amis de longue date, de parents ou de proches compagnons, la Difficulté est de 10. Si le personnage connaît sa cible de vue ou qu’il ne lui a adressé la parole que quelquefois, elle passe à 15. Si le personnage n’a jamais vu sa cible, la Difficulté est de 20. La possession d’un objet appartenant à la cible ou la préparation d’un rituel magique peut diminuer cette Difficulté, tout comme une défense magique ou un mauvais environnement peut l’augmenter.",
      ),
      DraconicLinkProgress.deuxiemeNiveau: DraconicLinkFavor(
        title: "Le rêve éveillé",
        description: "À ce niveau de Faveur, l’Élu bénéficie d’un léger décalage dans la perception que les autres ont de lui dans l’espace. Tant qu’il ne se livre à aucune action offensive, la Difficulté pour le toucher augmente de 10 car ses adversaires ont tendance à frapper là où il se trouvait quelques instants plus tôt. Dès que le personnage se manifeste de manière trop visible, en déclarant une attaque ou en lançant un sortilège offensif, il perd le bénéfice de cette Faveur et ne le retrouve qu'après une nuit de sommeil.",
      ),
      DraconicLinkProgress.troisiemeNiveau: DraconicLinkFavor(
        title: "Le manteau de chimère",
        description: "Cette Faveur permet au personnage de lancer et de conserver un dé supplémentaire du Dragon chaque fois qu’il effectue une action impliquant l’Empathie, la psychologie, la perception de l’invisible ou l’onirisme.",
      ),
      DraconicLinkProgress.quatriemeNiveau: DraconicLinkFavor(
        title: "Les miroirs des songes",
        description: "Cette Faveur permet à l'Élu de façonner et de projeter des illusions si crédibles qu’il est possible de les toucher, de les sentir, et même de les combattre. Tout d’abord, le personnage doit décrire avec précision l'illusion qu’il souhaite créer. Ensuite, il doit réussir un jet de Mental + Empathie contre ume Difficulté fixée par le meneur de jeu, en fonction de la complexité, de la taille et du degré de réalisme désirés. À titre de référence, créer l'illusion d'un cheval au galop demandera une Difficulté de 5. Cette Difficulté sera augmentée de 5 si les chevaux sont en troupeau et proches de l'observateur, de 10 s'ils se précipitent pour piétiner le spectateur… Une telle illusion dure un nombre de tours égal à la valeur d’Empathie du personnage.\n Il est cependant possible de la maintenir en réussissant, à chaque tour supplémentaire, un jet de Mental + Volonté contre la Difficulté de création de l'illusion, augmentée de 5 par tour. Seuls les Élus de Nenya et les dragons ont une chance de comprendre qu’il s’agit d’une illusion, en réussissant un jet de Mental + Empathie contre la Difficulté de création +5.",
      ),
      DraconicLinkProgress.cinquiemeNiveau: DraconicLinkFavor(
        title: "L’abîme de l'esprit",
        description: "Une fois par nuit, le personnage peut s’insinuer dans les songes d’un être humain avec qui il a déjà eu un contact, physique ou verbal, et lui dérober une partie de sa mémoire. Il est ainsi possible de ne gommer qu’une simple phrase, mais aussi une semaine toute entière. Le personnage ne peut effacer plus de journées de souvenirs qu’il ne possède de points d’Empathie.",
      ),
    },

    MagicSphere.cite: {
      DraconicLinkProgress.premierNiveau: DraconicLinkFavor(
        title: "L’esprit des cités",
        description: "Cette Faveur, active en permanence, permet au personnage de se sentir particulièrement à l'aise dans les cités. Tout d’abord, il n’a pratiquement aucune chance de s'y perdre et peut effectuer un jet de Mental + Empathie contre une Difficulté de 10 pour tenter de trouver un quartier, une fontaine ou tout autre lieu courant. Cette Difficulté passe à 15 pour découvrir un magasin particulier, et à 20 pour trouver un endroit inhabituel ou masqué, tel qu’une guilde secrète, la demeure d’un herboriste indépendant, etc. Cette Faveur confère également un bonus de 3 à tous les jets de Social effectués en cité pour marchander, négocier des informations, intercepter des rumeurs, etc.",
      ),
      DraconicLinkProgress.deuxiemeNiveau: DraconicLinkFavor(
        title: "Le confort du foyer",
        description: "En réussissant un jet d’Empathie + Vie en cité contre une Difficulté de 10, l’Élu peut connaître parfaitement les plans de la maison qu’il touche comme s’il l’habitait depuis toujours. De plus, pour chaque NR, le personnage peut obtenir une information supplémentaire de son choix (passages dérobés, sources de chaleur, présence d'hommes ou de dragons, etc.).",
      ),
      DraconicLinkProgress.troisiemeNiveau: DraconicLinkFavor(
        title: "L’œil du secret",
        description: "En réussissant un jet de Social + Empathie contre une Difficulté de 15, le personnage peut obtenir une information concernant la Tendance, l’affiliation, la mentalité ou l’éventuel Lien d’un homme qu’il observe, Pour chaque NR, le personnage pourra apprendre une information supplémentaire. Cette Faveur permet de déterminer la Tendance majeure d'un individu, la nature et le degré de son Lien draconique, ainsi que ses implications dans une mouvance affiliée à l’une des trois Tendances. Une seule tentative est possible par individu par jour.",
      ),
      DraconicLinkProgress.quatriemeNiveau: DraconicLinkFavor(
        title: "Les mille visages de Khy",
        description: "Cette Faveur permet à l’Élu qui en bénéficie de changer d’apparence, de taille, de poids et même de sexe, en à peine quelques secondes. Pour ressembler à quelqu'un qu’il connaît, il lui faudra effectuer un jet de Social + Volonté contre une Difficulté de 15. Cette Difficulté est augmentée de 5 pour ressembler à un individu de vague connaissance, et de 10 pour imiter le visage d’un portrait ou d'une esquisse.",
      ),
      DraconicLinkProgress.cinquiemeNiveau: DraconicLinkFavor(
        title: "Les portes de la cité",
        description: "À ce niveau, l’Élu est totalement en phase avec chacune des cités qu’il visite et peut, sans effectuer le moindre jet, se déplacer miraculeusement d’un endroit à l’autre de la ville. Pour chaque Point de Chance ou de Maîtrise qu’il dépense, le personnage peut effectuer un “saut” vers n’importe quel endroit de la cité. Généralement, les Élus de Khy se plaisent à emprunter les portes, les arches et les puits pour disparaître et se transporter. Il est impossible de faire voyager un tiers de cette façon, mais l’Élu conserve tout ce qu’il porte sur lui au moment du saut.",
      ),
    },

    MagicSphere.vents: {
      DraconicLinkProgress.premierNiveau: DraconicLinkFavor(
        title: "L’élan des brises",
        description: "Cette Faveur permet au personnage de lancer un dé supplémentaire pour déterminer son Initiative ou de tirer un projectile supplémentaire lorsqu'il utilise une arme à distance classique (de jet ou à projectiles par opposition aux armes interdites des Humanistes, telles que les arbalètes, les balistes, etc.). Il est possible d’utiliser cette Faveur trois fois par jour, réparties selon les applications de son choix (deux fois pour l’Initiative et une fois pour les projectiles, par exemple).",
      ),
      DraconicLinkProgress.deuxiemeNiveau: DraconicLinkFavor(
        title: "Le murmure du vent",
        description: "À ce niveau, le personnage acquiert un sixième sens qui le prévient généralement du danger. Il sait instinctivement, par exemple, si une route risque d’être dangereuse et risque de se réveiller naturellement si des ennemis s’approchent de l’endroit où il dort. Le meneur de jeu doit effectuer un jet de Mental + Empathie contre une Difficulté de 20 pour le prévenir à temps.",
      ),
      DraconicLinkProgress.troisiemeNiveau: DraconicLinkFavor(
        title: "La fortune du voyageur",
        description: "En atteignant ce niveau, le personnage devient chanceux et regagne deux Points de Chance au lieu d’un à chaque échec. De plus, il peut toujours relancer une fois le dé du Dragon lorsqu'il fait appel aux Tendances, mais doit dans ce cas conserver ce second jet.",
      ),
      DraconicLinkProgress.quatriemeNiveau: DraconicLinkFavor(
        title: "La légèreté des embruns",
        description: "À ce niveau de Faveur, l’Élu est capable de voler à volonté. Il n’est plus retenu par les contraintes de la gravité et peut se déplacer dans toutes les directions à la vitesse de la course. Il peut même faire des pointes à une vitesse trois fois supérieure pendant une durée égale à sa Résistance en minutes. Bien sûr, il reste à sa charge de gérer les rencontres avec d’éventuels dragons ignorants de son Lien…",
      ),
      DraconicLinkProgress.cinquiemeNiveau: DraconicLinkFavor(
        title: "L’insouciance de Szyl",
        description: "Arrivé à ce stade, l’Élu est capable d'utiliser les éléments climatiques à sa convenance. Il peut faire neiger en été ou encore arrêter une tempête. Il maîtrise la force et la direction du vent ainsi que la densité des nuages. Il peut déchaîner la colère de la nature ou l’apaiser à volonté. Il faut simplement une vingtaine de minutes pour passer d’un grand beau temps à une tornade. Bien entendu, l’Élu est immunisé aux effets néfastes qu’il peut accroître jusqu’à les rendre offensifs, multipliant alors les décharges de foudre ou la grêle par exemple. Il n’a de contrôle que sur leur intensité, ne pouvant les orienter à son gré.",
      ),
    },

    MagicSphere.ombre: {
      DraconicLinkProgress.premierNiveau: DraconicLinkFavor(
        title: "La marque de l'ombre",
        description: "Cette Faveur accorde au personnage le droit de développer la Sphère de l'Ombre, qui lui ouvre les portes de la magie de Kalimsshar. Qu'il s'agisse ou non d’un mage, le personnage pourra développer cette Sphère en dépensant des Points de Compétences à la création ou des Points d’Expérience en cours de campagne.",
      ),
      DraconicLinkProgress.deuxiemeNiveau: DraconicLinkFavor(
        title: "L'ombre du doute",
        description: "Cette Faveur permet au personnage d'instaurer le doute et de provoquer la peur dans l’esprit de son adversaire. Pour l'utiliser, le joueur doit effectuer un jet d'opposition de Social + Volonté contre Mental + Volonté de sa cible. Le doute s’insinue dans l'esprit de la victime pendant un nombre de minutes égal au nombre de NR de différence.\nDurant cette période, la victime devra réussir un jet de Mental + Volonté contre une Difficulté de 15 chaque fois qu’elle tentera de s’en prendre au personnage, que ce soit par une action physique, un pouvoir magique ou une simple altercation verbale. De plus, tous ses jets basés sur le Mental voient leur Difficulté augmenter de 5. Si la victime échoue à ce jet, il lui est totalement impossible de s’en prendre au bénéficiaire de cette faveur. Ce pouvoir peut être utilisé trois fois par jour, mais il est inutile de rappeler que les manifestations des pouvoirs de l’ombre sont très mal considérées.",
      ),
      DraconicLinkProgress.troisiemeNiveau: DraconicLinkFavor(
        title: "Le manteau de l’ombre",
        description: "En se concentrant, l’Élu peut disparaître à la vue de ses observateurs. Cette Faveur est plus efficace de nuit, dans un endroit peu éclairé ou encore par temps sombre plutôt qu’en plein soleil. Pour que le pouvoir soit activé, le personnage ne doit pas être visible lorsqu'il le déclenche. Dans des conditions favorables, le personnage qui désire utiliser cette capacité doit effectuer un jet de Mental + Empathie contre une Difficulté de 10. S'il réussit, il disparaît dans l’ombre, la chaleur de son corps baisse pour s’adapter à la température ambiante, ses mouvements ne font plus de bruits et il ne dégage plus aucune odeur. Il est virtuellement indétectable par tout autre moyen naturel que l’écholocation d’une chauve-souris. Il ne redevient visible que s’il se manifeste physiquement, en parlant ou en réalisant une action offensive. Il peut cependant tenter de rester caché en réussissant un jet Mental + Discrétion contre une Difficulté de 25. Dans des conditions moins favorables, le jet initial est Mental + Empathie contre une Difficulté de 20, et toute action signale automatiquement la présence de l'utilisateur. Cette Faveur est utilisable trois fois par jour.",
      ),
      DraconicLinkProgress.quatriemeNiveau: DraconicLinkFavor(
        title: "Le parfum de la corruption",
        description: "À ce niveau, le Lien avec Kalimsshar se fait plus fort. Ce dernier accorde à son serviteur, par l’intermédiaire du dragon, une parcelle de son pouvoir. Le joueur peut lancer un dé de Fatalité supplémentaire chaque fois qu’il fait appel aux Tendances. S'il décide de conserver les dés de la Fatalité, il peut additionner les deux.",
      ),
      DraconicLinkProgress.cinquiemeNiveau: DraconicLinkFavor(
        title: "Le souffle de vie",
        description: "Le Lien atteint ici son niveau maximum. Il se manifeste par un partage entre le dragon et l’Élu du souffle de vie. Si l’un vient à mourir, l’autre succombera aussi vingt-quatre heures après la mort de son compagnon. Pendant ce laps de temps, il subira d’incroyables souffrances - étant d’une certaine manière déjà mort. Il revivra sans cesse l’agonie de son compagnon et dérivera lentement vers la folie. Tant qu’ils sont tous deux en vie, ils sont aussi immortels l’un que l’autre et arrêtent même de vieillir. Ils bénéficient de plus tous deux des Seuils de blessures du dragon.",
      ),
    },
  };
}