// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'star_motivations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StarMotivations _$StarMotivationsFromJson(Map<String, dynamic> json) =>
    StarMotivations(
      vertu: $enumDecode(_$MotivationVertuEnumMap, json['vertu']),
      vertuValue: (json['vertu_value'] as num).toInt(),
      penchant: $enumDecode(_$MotivationPenchantEnumMap, json['penchant']),
      penchantValue: (json['penchant_value'] as num).toInt(),
      ideal: $enumDecode(_$MotivationIdealEnumMap, json['ideal']),
      idealValue: (json['ideal_value'] as num).toInt(),
      interdit: $enumDecode(_$MotivationInterditEnumMap, json['interdit']),
      interditValue: (json['interdit_value'] as num).toInt(),
      epreuve: $enumDecode(_$MotivationEpreuveEnumMap, json['epreuve']),
      epreuveValue: (json['epreuve_value'] as num).toInt(),
      destinee: $enumDecode(_$MotivationDestineeEnumMap, json['destinee']),
      destineeValue: (json['destinee_value'] as num).toInt(),
    );

Map<String, dynamic> _$StarMotivationsToJson(StarMotivations instance) =>
    <String, dynamic>{
      'vertu': _$MotivationVertuEnumMap[instance.vertu]!,
      'vertu_value': instance.vertuValue,
      'penchant': _$MotivationPenchantEnumMap[instance.penchant]!,
      'penchant_value': instance.penchantValue,
      'ideal': _$MotivationIdealEnumMap[instance.ideal]!,
      'ideal_value': instance.idealValue,
      'interdit': _$MotivationInterditEnumMap[instance.interdit]!,
      'interdit_value': instance.interditValue,
      'epreuve': _$MotivationEpreuveEnumMap[instance.epreuve]!,
      'epreuve_value': instance.epreuveValue,
      'destinee': _$MotivationDestineeEnumMap[instance.destinee]!,
      'destinee_value': instance.destineeValue,
    };

const _$MotivationVertuEnumMap = {
  MotivationVertu.loyaute: 'loyaute',
  MotivationVertu.tolerance: 'tolerance',
  MotivationVertu.pardon: 'pardon',
  MotivationVertu.courage: 'courage',
  MotivationVertu.devouement: 'devouement',
  MotivationVertu.sagesse: 'sagesse',
  MotivationVertu.diplomatie: 'diplomatie',
  MotivationVertu.prudence: 'prudence',
  MotivationVertu.engagement: 'engagement',
  MotivationVertu.imagination: 'imagination',
};

const _$MotivationPenchantEnumMap = {
  MotivationPenchant.violence: 'violence',
  MotivationPenchant.haine: 'haine',
  MotivationPenchant.luxure: 'luxure',
  MotivationPenchant.tentation: 'tentation',
  MotivationPenchant.colere: 'colere',
  MotivationPenchant.fanatisme: 'fanatisme',
  MotivationPenchant.discorde: 'discorde',
  MotivationPenchant.fatalisme: 'fatalisme',
  MotivationPenchant.precipitation: 'precipitation',
  MotivationPenchant.lachete: 'lachete',
};

const _$MotivationIdealEnumMap = {
  MotivationIdeal.decouvrir: 'decouvrir',
  MotivationIdeal.construire: 'construire',
  MotivationIdeal.partager: 'partager',
  MotivationIdeal.survivre: 'survivre',
  MotivationIdeal.creer: 'creer',
  MotivationIdeal.evoluer: 'evoluer',
  MotivationIdeal.modifier: 'modifier',
  MotivationIdeal.apprendre: 'apprendre',
  MotivationIdeal.provoquer: 'provoquer',
  MotivationIdeal.harmoniser: 'harmoniser',
};

const _$MotivationInterditEnumMap = {
  MotivationInterdit.tuer: 'tuer',
  MotivationInterdit.trahir: 'trahir',
  MotivationInterdit.abandonner: 'abandonner',
  MotivationInterdit.mentir: 'mentir',
  MotivationInterdit.detruire: 'detruire',
  MotivationInterdit.corrompre: 'corrompre',
  MotivationInterdit.voler: 'voler',
  MotivationInterdit.fuir: 'fuir',
  MotivationInterdit.renier: 'renier',
  MotivationInterdit.faillir: 'faillir',
};

const _$MotivationEpreuveEnumMap = {
  MotivationEpreuve.dilemme: 'dilemme',
  MotivationEpreuve.quete: 'quete',
  MotivationEpreuve.solitude: 'solitude',
  MotivationEpreuve.trahison: 'trahison',
  MotivationEpreuve.corruption: 'corruption',
  MotivationEpreuve.doute: 'doute',
  MotivationEpreuve.perte: 'perte',
  MotivationEpreuve.duel: 'duel',
  MotivationEpreuve.errance: 'errance',
  MotivationEpreuve.vengeance: 'vengeance',
};

const _$MotivationDestineeEnumMap = {
  MotivationDestinee.triomphe: 'triomphe',
  MotivationDestinee.sacrifice: 'sacrifice',
  MotivationDestinee.rebellion: 'rebellion',
  MotivationDestinee.illumination: 'illumination',
  MotivationDestinee.obeissance: 'obeissance',
  MotivationDestinee.echec: 'echec',
  MotivationDestinee.malediction: 'malediction',
  MotivationDestinee.desillusion: 'desillusion',
  MotivationDestinee.puissance: 'puissance',
  MotivationDestinee.accomplissement: 'accomplissement',
};
