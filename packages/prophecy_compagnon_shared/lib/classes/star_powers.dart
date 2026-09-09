enum StarPower {
  benediction(
    title: 'Bénédiction',
    description: "En réussissant un jet de Mental + Volonté contre une Difficulté de 5, le Guide ou la Main du Destin peut attribuer un bonus à tous les Inspirés présents dans un rayon de 5 mètres. Ce bonus est égal à 1 par NR et s'applique à n'importe quel Attribut Majeur (au choix de chaque personnage) pendant une durée égale à dix tours par NR. Seuls le Guide et la Main du Destin peuvent utiliser ce pouvoir et uniquement une fois par jour.",
    eclat: [3, 4]
  ),
  champDeForce(
      title: 'Champ de force',
      description: "Ce pouvoir permet aux Inspirés de générer un champ d'énergie capable de stopper les projectiles et les attaque magiques. La protection de base du Champ de force est égale à la moitié de la somme des Caractéristiques Volonté de tous les Inspirés présents. La Main du Destin doit ensuite effectuer un jet de Mental + Volonté contre une Difficulté de 10 : le nombre de NR+ 1 détermine le multiplicateur de cette protection de base.\nLe Champ de force reste actif pendant (2 + 2 par NR) tours. Pendant cette période, il est impossible de pénétrer physiquement dans le Champ de force. L'Indice de protection fonctionne comme celui d’une armure et bloque tous les projectiles infligeant moins de dommages. Face aux attaques magiques, cet Indice de protection est divisé par deux. Le champ disparaît dès que l'un des Inspirés brise sa concentration (qui interdit toute autre action que la parole) ou quitte le périmètre, dont le rayon est égal au nombre de participants en mètres.",
      eclat: [4, 5]
  ),
  empathie(
      title: 'Empathie',
      description: "Actif en permanence, ce pouvoir permet aux Inspirés de la Compagnie de ressentir les émotions violentes d’un de leurs compagnons (être en danger, avoir besoin d'aide, être pétrifié de terreur, etc.), En réussissant un jet de Mental + Empathie contre une Difficulté de 15, un Inspiré peut également tenter de ressentir la situation émotionnelle globale d’un des membres de la Compagnie. La distance n’influe pas sur la Difficulté du jet.",
      eclat: [1]
  ),
  harmonie(
      title: 'Harmonie',
      description: "Ce pouvoir permet à tous les Inspirés participant au rituel de “redistribuer” leurs blessures. Aucun jet n’est nécessaire, mais il est impossible de transférer une blessure mortelle d’un personnage à un autre. Une fois transférées, les blessures se manifestent sous la forme de plaies, de fractures et de douleurs internes. Les malus s'appliquent directement. Les blessures ainsi guéries se referment en moins d'une heure et il est possible de soigner les nouvelles de toutes les façons imaginables.",
      eclat: [7]
  ),
  offensive(
      title: 'Offensive',
      description: "Une fois par jour, les Inspirés peuvent se concentrer pour porter une attaque sous la forme d'une vague d'énergie semi-circulaire longue de dix mètres par participant. Les dommages de base sont égaux au double du niveau d’Éclat de l'Étoile multiplié par le nombre d’Inspirés présents. La Main du Destin doit réussir un jet de Mental + Volonté contre une Difficulté de 10 pour toucher une cible précise, mais toutes les créatures présentes dans la zone d'effet et considérées comme des ennemis subissent la moitié des dommages. Les armures fonctionnent normalement.",
      eclat: [6, 7]
  ),
  partage(
      title: 'Partage',
      description: "Une fois par jour, en réussissant chacun un jet de Mental + Empathie contre une Difficulté de 15, deux Inspirés peuvent échanger une Compétence de leur choix, du moment qu’ils la possèdent tous deux. Ce changement reste actif jusqu’au sommeil et ne peut en aucun cas être inversé avant cela.",
      eclat: [5, 6]
  ),
  ralliement(
      title: 'Ralliement',
      description: "En utilisant ce pouvoir, un Inspiré peut se transporter instantanément vers le reste de la Compagnie. Toutes ses possessions l’accompagnent, mais seule la matière inerte peut ainsi voyager avec lui. L'endroit de départ et d'arrivée n’a aucune influence sur la réussite du pouvoir, mais il est indispensable que tous les autres Inspirés soient présents et se concentrent pour permettre le Ralliement. Il faut donc au préalable établir un contact mental ou toute autre forme de communication. L'Inspiré qui utilise ce pouvoir perd définitivement 1 point de Volonté.",
      eclat: [9]
  ),
  rappelALaVie(
      title: 'Rappel à la vie',
      description: "En réussissant un jet de Mental + Volonté contre une Difficulté de 50, la Main du Destin peut rappeler à la vie un des Inspirés de la Compagnie. Cette Difficulté est réduite de 5 par Inspiré participant au rituel. Si le jet est réussi, tous les participants - y compris le bénéficiaire du rituel - perdent définitivement 1 point de Volonté et 1 point de Résistance et l'Étoile perd un cercle dans toutes ses Motivations (elle peut dans ce cas perdre un point d’une Motivation et faire chuter l’Éclat). Si le jet est raté, aucune nouvelle tentative n’est possible.",
      eclat: [10]
  ),
  rituel(
      title: 'Rituel',
      description: "En partageant leurs énergies, les Inspirés peuvent faciliter les chances de réussite de n'importe quelle action et conférer un bonus à l’un d’eux. Ce bonus est égal au nombre de participants et s'applique à une Compétence, une Caractéristique ou un Attribut choisi par l’Inspiré qui bénéficie du rituel. Aucun jet n’est nécessaire. Le bonus disparaît une fois l’action effectuée. Dix tours complets sont nécessaires pour procéder au Rituel.",
      eclat: [4, 5]
  ),
  symbiose(
      title: 'Symbiose',
      description: "Chaque jour, deux Inspirés de la Compagnie peuvent établir un lien vital qui permettra à l’un d’eux de subir les dommages du second. Ce lien est à sens unique et ne peut être brisé tant que les deux participants n’ont pas procédé à un nouveau rituel, qui nécessite environ une heure de méditation. Un seul lien peut être établi par Inspiré.",
      eclat: [8, 9]
  ),
  telepathie(
      title: 'Télépathie',
      description: "Ce pouvoir permet à deux Inspirés de communiquer mentalement. Tant qu'aucun personnage ne précise qu’il refuse le contact, la réussite est automatique. Dans le cas contraire, deux Inspirés peuvent tenter un jet d’Opposition en Mental + Volonté pour déterminer si l’un d’eux parvient à passer les défenses mentales de l’autre. La distance n’influe pas sur la Difficulté du jet.",
      eclat: [2]
  ),
  transfert(
      title: 'Transfert',
      description: "En se concentrant sur un objet appartenant à l’un des Inspirés du groupe, il est possible de le faire disparaître et réapparaître dans les mains d’un autre Inspiré. Pour cela, la Main du Destin doit réussir un jet de Social + Empathie contre une Difficulté de 30. Cette Difficulté est réduite de 5 par Inspiré participant au rituel, d’un côté comme de l’autre. Si un Inspiré isolé tente d'utiliser ce pouvoir sans que les autres soient prévenus, la Difficulté reste de 30 et n’est pas modifiable. En revanche, si les deux extrémités de la chaîne sont prévenues, la Difficulté peut être réduite par le nombre de participants au rituel. Un seul jet est possible par objet et par jour.",
      eclat: [7, 8]
  ),
  transport(
      title: 'Transport',
      description: "En se concentrant sur une destination précise, la Compagnie peut se transporter magiquement vers n'importe quel endroit du monde. Pour réussir ce prodige, il est indispensable que tous les membres de la Compagnie soient présents et qu'ils aient une connaissance précise de la destination. Si l’endroit ne leur est pas véritablement familier, la Main du Destin doit réussir un jet de Mental + Volonté contre une Difficulté de 20. En cas d’échec, ou si les Inspirés n’ont jamais vu l’endroit où ils souhaitent se rendre, le Transport est tout simplement impossible, Une fois l’utilisation du pouvoir réussie, les Inspirés se dématérialisent et reprennent leur forme physique sur le lieu de leur destination. Ils ne gardent aucun souvenir de leur voyage. L'Étoile perd alors deux cercles dans toutes ses Motivations (elle peut dans ce cas perdre un point d’une Motivation et faire chuter l’Éclat).",
      eclat: [10]
  ),
  visionPartagee(
      title: 'Vision partagée',
      description: "Ce pouvoir permet à un Inspiré de voir par les yeux et d’entendre par les oreilles d’un autre membre de la Compagnie. La vision dure dix tours au maximum et la réussite est automatique. Cependant, un des deux personnages peut effectuer un jet de Mental + Empathie contre une Difficulté de 10 pour prolonger cette durée de dix tours par Niveau de Réussite. Si plusieurs Inspirés tentent de partager en même temps les visions d’un personnage, il leur faut réussir un jet de Mental + Volonté contre une Difficulté égale à 5 fois le nombre de “spectateurs”.",
      eclat: [3]
  ),
  ;

  static List<StarPower> forEclat(int e) => StarPower.values
      .where((StarPower s) => s.eclat.contains(e))
      .toList();

  final String title;
  final String description;
  final List<int> eclat;

  const StarPower({ required this.title, required this.description, required this.eclat });
}