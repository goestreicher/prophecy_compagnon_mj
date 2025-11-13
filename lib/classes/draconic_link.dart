import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'draconic_favor.dart';
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

  static List<DraconicFavor> favors({ required DraconicLinkProgress progress, required MagicSphere sphere }) {
    var ret = <DraconicFavor>[];
    for(var i = DraconicLinkProgress.premierNiveau.index; i <= progress.index; ++i) {
      var f = DraconicFavor.byName(_favors[sphere]![DraconicLinkProgress.values[i]]!, sphere);
      if(f != null) ret.add(f);
    }
    return ret;
  }

  factory DraconicLink.fromJson(Map<String, dynamic> j) => _$DraconicLinkFromJson(j);

  Map<String, dynamic> toJson() => _$DraconicLinkToJson(this);

  static final Map<MagicSphere, Map<DraconicLinkProgress, String>> _favors = {
    MagicSphere.pierre: {
      DraconicLinkProgress.premierNiveau: "La peau de pierre",
      DraconicLinkProgress.deuxiemeNiveau: "Les reflets de glaise",
      DraconicLinkProgress.troisiemeNiveau: "Les portes de silice",
      DraconicLinkProgress.quatriemeNiveau: "À l'ombre des montagnes",
      DraconicLinkProgress.cinquiemeNiveau: "Le cercle de pierre",
    },

    MagicSphere.feu: {
      DraconicLinkProgress.premierNiveau: "L’œil incandescent",
      DraconicLinkProgress.deuxiemeNiveau: "Le flot de lave",
      DraconicLinkProgress.troisiemeNiveau: "La cérémonie du volcan",
      DraconicLinkProgress.quatriemeNiveau: "La danse des étincelles",
      DraconicLinkProgress.cinquiemeNiveau: "Le feu intérieur",
    },

    MagicSphere.oceans: {
      DraconicLinkProgress.premierNiveau: "Le secret du verbe",
      DraconicLinkProgress.deuxiemeNiveau: "L’infinie sagesse",
      DraconicLinkProgress.troisiemeNiveau: "Le poids du souvenir",
      DraconicLinkProgress.quatriemeNiveau: "L’esprit des profondeurs",
      DraconicLinkProgress.cinquiemeNiveau: "La rive harmonie",
    },

    MagicSphere.metal: {
      DraconicLinkProgress.premierNiveau: "La main du maître",
      DraconicLinkProgress.deuxiemeNiveau: "La justesse de l’outil",
      DraconicLinkProgress.troisiemeNiveau: "L’enfant du métal",
      DraconicLinkProgress.quatriemeNiveau: "L’âme de l’immatériel",
      DraconicLinkProgress.cinquiemeNiveau: "Le sang de Kezyr",
    },

    MagicSphere.nature: {
      DraconicLinkProgress.premierNiveau: "Le sang et la sève",
      DraconicLinkProgress.deuxiemeNiveau: "Porté par la nature",
      DraconicLinkProgress.troisiemeNiveau: "Le banquet de nature",
      DraconicLinkProgress.quatriemeNiveau: "Le cycle de la vie",
      DraconicLinkProgress.cinquiemeNiveau: "L’ordre primordial",
    },

    MagicSphere.reves: {
      DraconicLinkProgress.premierNiveau: "Le monde éthéré",
      DraconicLinkProgress.deuxiemeNiveau: "Le rêve éveillé",
      DraconicLinkProgress.troisiemeNiveau: "Le manteau de chimère",
      DraconicLinkProgress.quatriemeNiveau: "Les miroirs des songes",
      DraconicLinkProgress.cinquiemeNiveau: "L’abîme de l'esprit",
    },

    MagicSphere.cite: {
      DraconicLinkProgress.premierNiveau: "L’esprit des cités",
      DraconicLinkProgress.deuxiemeNiveau: "Le confort du foyer",
      DraconicLinkProgress.troisiemeNiveau: "L’œil du secret",
      DraconicLinkProgress.quatriemeNiveau: "Les mille visages de Khy",
      DraconicLinkProgress.cinquiemeNiveau: "Les portes de la cité",
    },

    MagicSphere.vents: {
      DraconicLinkProgress.premierNiveau: "L’élan des brises",
      DraconicLinkProgress.deuxiemeNiveau: "Le murmure du vent",
      DraconicLinkProgress.troisiemeNiveau: "La fortune du voyageur",
      DraconicLinkProgress.quatriemeNiveau: "La légèreté des embruns",
      DraconicLinkProgress.cinquiemeNiveau: "L’insouciance de Szyl",
    },

    MagicSphere.ombre: {
      DraconicLinkProgress.premierNiveau: "La marque de l'ombre",
      DraconicLinkProgress.deuxiemeNiveau: "L'ombre du doute",
      DraconicLinkProgress.troisiemeNiveau: "Le manteau de l’ombre",
      DraconicLinkProgress.quatriemeNiveau: "Le parfum de la corruption",
      DraconicLinkProgress.cinquiemeNiveau: "Le souffle de vie",
    },
  };
}