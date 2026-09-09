// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draconic_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DraconicLink _$DraconicLinkFromJson(Map<String, dynamic> json) => DraconicLink(
  progress: $enumDecode(_$DraconicLinkProgressEnumMap, json['progress']),
  dragon: json['dragon'] as String,
  sphere: $enumDecode(_$MagicSphereEnumMap, json['sphere']),
);

Map<String, dynamic> _$DraconicLinkToJson(DraconicLink instance) =>
    <String, dynamic>{
      'sphere': _$MagicSphereEnumMap[instance.sphere]!,
      'dragon': instance.dragon,
      'progress': _$DraconicLinkProgressEnumMap[instance.progress]!,
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
