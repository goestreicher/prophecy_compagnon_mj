import 'package:prophecy_compagnon_shared/classes/entity/attributes.dart';

enum SkillFamily {
  combat(title: "Combat", defaultAttribute: Attribute.physique),
  mouvement(title: "Mouvement", defaultAttribute: Attribute.physique),
  theorie(title: "Théorie", defaultAttribute: Attribute.mental),
  pratique(title: "Pratique", defaultAttribute: Attribute.mental),
  technique(title: "Technique", defaultAttribute: Attribute.manuel),
  manipulation(title: "Manipulation", defaultAttribute: Attribute.manuel),
  communication(title: "Communication", defaultAttribute: Attribute.social),
  influence(title: "Influence", defaultAttribute: Attribute.social);

  const SkillFamily({
    required this.title,
    required this.defaultAttribute,
  });

  final String title;
  final Attribute defaultAttribute;
}