// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draconic_favor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DraconicFavor _$DraconicFavorFromJson(Map<String, dynamic> json) =>
    DraconicFavor(
      sphere: $enumDecode(_$MagicSphereEnumMap, json['sphere']),
      linkProgress: $enumDecode(
        _$DraconicLinkProgressEnumMap,
        json['link_progress'],
      ),
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$DraconicFavorToJson(DraconicFavor instance) =>
    <String, dynamic>{
      'sphere': _$MagicSphereEnumMap[instance.sphere]!,
      'link_progress': _$DraconicLinkProgressEnumMap[instance.linkProgress]!,
      'title': instance.title,
      'description': instance.description,
    };

const _$MagicSphereEnumMap = {
  MagicSphere.pierre: 'pierre',
  MagicSphere.feu: 'feu',
  MagicSphere.oceans: 'oceans',
  MagicSphere.metal: 'metal',
  MagicSphere.nature: 'nature',
  MagicSphere.reves: 'reves',
  MagicSphere.cite: 'cite',
  MagicSphere.vents: 'vents',
  MagicSphere.ombre: 'ombre',
};

const _$DraconicLinkProgressEnumMap = {
  DraconicLinkProgress.aucunLien: 'aucunLien',
  DraconicLinkProgress.prelude: 'prelude',
  DraconicLinkProgress.premierNiveau: 'premierNiveau',
  DraconicLinkProgress.deuxiemeNiveau: 'deuxiemeNiveau',
  DraconicLinkProgress.troisiemeNiveau: 'troisiemeNiveau',
  DraconicLinkProgress.quatriemeNiveau: 'quatriemeNiveau',
  DraconicLinkProgress.cinquiemeNiveau: 'cinquiemeNiveau',
};
