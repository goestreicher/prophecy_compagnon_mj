// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecializedSkill _$SpecializedSkillFromJson(Map<String, dynamic> json) =>
    SpecializedSkill(
      json['name'] as String,
    )..reserved = json['reserved'] as bool;

Map<String, dynamic> _$SpecializedSkillToJson(SpecializedSkill instance) =>
    <String, dynamic>{
      'name': instance.name,
      'reserved': instance.reserved,
    };

SkillInstance _$SkillInstanceFromJson(Map<String, dynamic> json) =>
    SkillInstance(
      skill: $enumDecode(_$SkillEnumMap, json['skill']),
      value: (json['value'] as num).toInt(),
    );

Map<String, dynamic> _$SkillInstanceToJson(SkillInstance instance) =>
    <String, dynamic>{
      'skill': _$SkillEnumMap[instance.skill]!,
      'value': instance.value,
    };

const _$SkillEnumMap = {
  Skill.armesArticulees: 'armesArticulees',
  Skill.armesContondantes: 'armesContondantes',
  Skill.armesDeChoc: 'armesDeChoc',
  Skill.armesDeJet: 'armesDeJet',
  Skill.armesDoubles: 'armesDoubles',
  Skill.armesDHast: 'armesDHast',
  Skill.armesTranchantes: 'armesTranchantes',
  Skill.bouclier: 'bouclier',
  Skill.corpsACorps: 'corpsACorps',
  Skill.creatureNaturalWeapon: 'creatureNaturalWeapon',
  Skill.acrobatie: 'acrobatie',
  Skill.athletisme: 'athletisme',
  Skill.equitation: 'equitation',
  Skill.escalade: 'escalade',
  Skill.esquive: 'esquive',
  Skill.natation: 'natation',
  Skill.castes: 'castes',
  Skill.connaissanceDeLaMagie: 'connaissanceDeLaMagie',
  Skill.connaissanceDesAnimaux: 'connaissanceDesAnimaux',
  Skill.connaissanceDesDragons: 'connaissanceDesDragons',
  Skill.geographie: 'geographie',
  Skill.histoire: 'histoire',
  Skill.lois: 'lois',
  Skill.orientation: 'orientation',
  Skill.strategie: 'strategie',
  Skill.alchimie: 'alchimie',
  Skill.astrologie: 'astrologie',
  Skill.cartographie: 'cartographie',
  Skill.estimation: 'estimation',
  Skill.herboristerie: 'herboristerie',
  Skill.lireEtEcrire: 'lireEtEcrire',
  Skill.matieresPremieres: 'matieresPremieres',
  Skill.medecine: 'medecine',
  Skill.premiersSoins: 'premiersSoins',
  Skill.survie: 'survie',
  Skill.vieEnCite: 'vieEnCite',
  Skill.armesDeSiege: 'armesDeSiege',
  Skill.artisanat: 'artisanat',
  Skill.contrefacon: 'contrefacon',
  Skill.discretion: 'discretion',
  Skill.pieges: 'pieges',
  Skill.pister: 'pister',
  Skill.armesAProjectiles: 'armesAProjectiles',
  Skill.attelages: 'attelages',
  Skill.deguisement: 'deguisement',
  Skill.deverrouillage: 'deverrouillage',
  Skill.donArtistique: 'donArtistique',
  Skill.faireLesPoches: 'faireLesPoches',
  Skill.jeu: 'jeu',
  Skill.jongler: 'jongler',
  Skill.baratin: 'baratin',
  Skill.conte: 'conte',
  Skill.eloquence: 'eloquence',
  Skill.marchandage: 'marchandage',
  Skill.psychologie: 'psychologie',
  Skill.artDeLaScene: 'artDeLaScene',
  Skill.commandement: 'commandement',
  Skill.diplomatie: 'diplomatie',
  Skill.dressage: 'dressage',
  Skill.intimidation: 'intimidation',
  Skill.seduction: 'seduction',
};
