import 'base.dart';

enum CasteInterdict {
  loiDuCompagnon(
    caste: Caste.artisan,
    title: 'La Loi du Compagnon',
    description: "Tu transmettras ton savoir. S'il est bien un point sur lequel artisans et érudits peuvent s'entendre, c’est la nécessité de la transmission du savoir et l’enseignement des techniques qu'ils utilisent chaque jour. Ainsi, on attend toujours d’un artisan qu’il apporte des explications sur ce qu'il fait et la façon dont il le fait.",
  ),
  loiDeLaPerfection(
    caste: Caste.artisan,
    title: 'La Loi de la Perfection',
    description: "Tu rechercheras toujours l’œuvre ultime. Tout artisan ne recherchant pas la perfection dans son œuvre perd peu à peu son lien avec la matière et ne pourra plus jamais créer d'œuvres exceptionnelles et encore moins enchantées.",
  ),
  loiDuRespect(
    caste: Caste.artisan,
    title: 'La Loi du Respect',
    description: "Tu respecteras la matière que tu travailles et les œuvres d’autrui. Il est bien entendu essentiel d'aimer la matière. Au fur et à mesure qu’un artisan se désintéresse du produit qu’il façonne, la matière devient de plus en plus difficile à travailler et prend des formes de plus en plus laides. On raconte que certains artisans et sorciers de l'ombre transgresseraient cette Loi volontairement pour donner à leurs œuvres un aspect tourmenté.",
  ),
  loiDeLArme(
    caste: Caste.combattant,
    title: "La Loi de l'Arme",
    description: "Tu respecteras ton Statut. La plus ancienne des traditions de la caste interdit aux combattants de porter plus d'armes que ne leur permet leur rang - c’est-à-dire une arme par Statut obtenu.",
  ),
  loiDeLHonneur(
    caste: Caste.combattant,
    title: "La Loi de l'Honneur",
    description: "Tu honoreras ton arme. La notion du respect s'applique autant à l’arme que manie le combattant qu'à son adversaire. Il est donc interdit de se mesurer à plus faible que soi et de compromettre son arme dans un combat non équitable.",
  ),
  loiDuSangCombattant(
    caste: Caste.combattant,
    title: 'La Loi du Sang (Combattant)',
    description: "Tu ne chercheras que la victoire. Le code de l'honneur des combattants interdit aux membres de la caste d'achever un adversaire qui a d’ores et déjà perdu un combat, qu’il s'agisse d’un duel comme d’une véritable bataille.",
  ),
  loiDuCoeur(
    caste: Caste.commercant,
    title: 'La Loi du Cœur',
    description: "Tu respecteras la parole donnée. Bien qu'habitués à mentir, ou tout du moins à présenter certains éléments sous leur jour le plus attrayant, les commerçants ont pour tradition de respecter leurs engagements une fois pris et d'honorer la confiance qu'on leur témoigne.",
  ),
  loiDeLOrdre(
    caste: Caste.commercant,
    title: "La Loi de l'Ordre",
    description: "Tu respecteras l’ordre établi. Sans ordre, il n’y a pas de prospérité possible. Il est nécessaire de lutter contre l’anarchie et, donc, contre tous ceux qui voudraient développer des activités commerciales indépendantes des organisations.",
  ),
  loiDuProgres(
    caste: Caste.commercant,
    title: 'La Loi du Progrès',
    description: "Tu ne manqueras aucune occasion de faire progresser la société. Une société qui stagne est une société mourante. Un commerçant se doit de ne jamais repousser une idée. Il se doit de toujours trouver comment améliorer ses affaires et celles des autres.",
  ),
  loiDuSavoir(
    caste: Caste.erudit,
    title: 'La Loi du Savoir',
    description: "Tu partageras tes découvertes. La tradition primordiale de la caste pousse les érudits à mettre leurs connaissances en commun, à comparer leurs découvertes et à aider leurs confrères à évoluer dans la voie qu'ils ont choisie. De ce fait, un personnage ne peut refuser de révéler ce qu’il sait à un autre érudit qui lui en fait la demande. Cet Interdit ne concerne bien évidemment que les découvertes “académiques” du personnage, et non ses secrets personnels.",
  ),
  loiDuCollege(
    caste: Caste.erudit,
    title: 'La Loi du Collège',
    description: "Tu agiras dans la concertation. L'habitude qu'ont les érudits de débattre continuellement avec leurs confrères se traduit, chez ceux qui quittent un jour les académies où îls ont parfait leur éducation, par une incapacité de prendre des initiatives sans demander conseil. Le personnage devra donc référer à ses compagnons des moindres actions qu’il souhaite entreprendre et, d’une façon plus générale, ne cacher aucune de ses découvertes susceptibles d’orienter la conduite de son groupe.",
  ),
  loiDuSecret(
    caste: Caste.erudit,
    title: 'La Loi du Secret',
    description: "Tu ne partageras pas l’art interdit. Si tous les érudits s'intéressent de près ou de loin au développement des sciences chiffrées, qui sont l'apanage des Humanistes, rares sont ceux qui tolèrent leur enseignement au commun des mortels. Cet Interdit empêche le personnage de divulguer les secrets des techniques proscrites par les Dragons : sciences, art du mécanisme, conception d'explosifs, etc.",
  ),
  loiDuPacte(
    caste: Caste.mage,
    title: 'La Loi du Pacte',
    description: "Tu n'abuseras pas de ta force. La plus ancienne tradition des mages est de louer le don de Nenya, le Grand Dragon de la Magie, en n’utilisant leurs terribles pouvoirs qu’en cas de nécessité. De ce fait, un mage qui abuse outrageusement de sa magie risque de s’attirer les foudres de son collège, ainsi que de tous les autres mages, pour qui la discrétion est mère d’humilité.",
  ),
  loiDuPartage(
    caste: Caste.mage,
    title: 'La Loi du Partage',
    description: "Tu dois transmettre ton savoir. La magie est un art demandant une grande coopération entre ceux qui l’étudient. Les mages se doivent de partager leurs découvertes avec leurs confrères mais aussi de transmettre leurs connaissances à des apprentis. Ceux qui se montrent trop secrets et trop égoïstes, ne recherchant bien souvent que le pouvoir pour servir leurs propres intérêts, sont dangereux pour la société et peuvent être traités comme des criminels.",
  ),
  loiDeLaPrudence(
    caste: Caste.mage,
    title: 'La Loi de la Prudence',
    description: "Tu te dois d'être vigilant. La magie est une force dangereuse qui nécessite une très grande prudence pour ne pas mettre en danger des innocents. Ainsi, un mage ne doit pas tenter d’expériences dangereuses dans des endroits peuplés et doit assumer toutes les conséquences de ses actes. Ceux qui pratiquent la magie sans se soucier des conséquences que leur art peut entraîner chez les autres peuvent être bannis des écoles.",
  ),
  loiDeLaMeditation(
    caste: Caste.prodige,
    title: 'La Loi de la Méditation',
    description: "Tu te dois de réfléchir à ce que tu vois et à ce que tu fais. Le Prodige se doit de réfléchir à ce que lui ou un autre fait, a fait et fera. Toute action entraîne obligatoirement une réaction. Il faut donc penser avant d'agir mais aussi assumer toutes les conséquences d’une décision. Les actes irréfléchis rompent le lien qui existe entre un Prodige et la nature.",
  ),
  loiDeLaNature(
    caste: Caste.prodige,
    title: 'La Loi de la Nature',
    description: "Tu te dois de respecter la nature sous toutes ses formes, animées ou inanimées. La nature se comprend dans sa globalité. Montagnes, fleuves, forêts et plaines en sont une partie intégrante au même titre que l’homme, le dragon ou l'animal. Ne voir qu’un aspect de la nature en ignorant les autres revient à ne plus percevoir l’œuvre de Heyra.",
  ),
  loiDuSangProdige(
    caste: Caste.prodige,
    title: 'La Loi du Sang (Prodige)',
    description: "Tu ne verseras pas le sang. La plus ancienne tradition de Heyra interdit à ses fidèles de souiller la Terre du sang de toute forme de vie consciente, qu’il s'agisse d’un être humain ou d’un animal. C’est sans doute pourquoi la majorité des Prodiges manient les armes contondantes et usent de leur force physique pour se défendre des dangers quotidiens.",
  ),
  loiDuLien(
    caste: Caste.protecteur,
    title: 'La Loi du Lien',
    description: "Tu ne trahiras pas les Grands Dragons. Fidèles aux Lois draconiques, les protecteurs sont soumis à l’autorité directe des Grands Dragons et de leurs représentants. C’est pourquoi ils ne peuvent ni mentir, ni désobéir, ni cacher des informations ou tenter quelque action néfaste que ce soit à l'encontre des dragons et de leurs émissaires.",
  ),
  loiDuSacrifice(
    caste: Caste.protecteur,
    title: 'La Loi du Sacrifice',
    description: "Tu ne craindras pas la mort. On ne demande pas aux protecteurs de mourir en lieu et place d’un autre citoyen de Kor, mais uniquement de se porter au devant d’un danger le menaçant. Leur rôle de défenseur du royaume et de garant de la bonne marche des cités les contraint effectivement à courir le risque de mourir en combattant un danger qui ne leur était pas initialement destiné.",
  ),
  loiDuSangProtecteur(
    caste: Caste.protecteur,
    title: 'La Loi du Sang (Protecteur)',
    description: "Tu préserveras la vie. Chargés d'assurer la sécurité des cités, des routes, et des habitants de Kor, les protecteurs ont pour tradition de n'user de la force qu’en cas de nécessité absolue et, lorsque cette solution est encore possible, de lui préférer le dialogue et la conciliation. Cet Interdit n’est pas brisé lorsqu’un protecteur se défend d’une attaque, mais à chaque fois qu'il sort son arme avant d’avoir tenté de raisonner et d'arrêter officiellement un individu.",
  ),
  loiDeLAmitie(
    caste: Caste.voyageur,
    title: "La Loi de l'Amitié",
    description: "Tu ne refuseras pas ton aide. Habitués à la solitude de leurs errances, les voyageurs ont pour tradition de ne jamais refuser leur aide à un compagnon dans le besoin, qu’il s’agisse d'un membre de leur caste, d’un autre citoyen ou de n'importe quel être humain.",
  ),
  loiDeLaDecouverte(
    caste: Caste.voyageur,
    title: 'La Loi de la Découverte',
    description: "Tu te dois d'explorer l'inconnu. Un voyageur ne peut rester insensible à l’appel de l’inconnu. S'il entend parler d’un endroit inexploré, d'un vallon isolé ou d’un site légendaire, il se doit de tenter de le découvrir. C’est sa nature et, s’il n'y obéit pas, il perdra son Statut de voyageur.",
  ),
  loiDeLaLiberte(
    caste: Caste.voyageur,
    title: 'La Loi de la Liberté',
    description: "Tu dois refuser d’être enfermé. Un voyageur contraint à rester dans un même endroit meurt peu à peu. Il a besoin de liberté et de se déplacer. Emprisonné, enchaîné, il perd toute raison de vivre et dépérit.",
  ),
  ;

  final Caste caste;
  final String title;
  final String description;

  const CasteInterdict({ required this.caste, required this.title, required this.description });
}