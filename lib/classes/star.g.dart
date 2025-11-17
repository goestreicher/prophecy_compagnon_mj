// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'star.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Star _$StarFromJson(Map<String, dynamic> json) => Star(
  name: json['name'] as String,
  source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
  location: json['location'] == null
      ? ObjectLocation.memory
      : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
  description: json['description'] as String? ?? '',
  envergure: $enumDecode(_$StarReachEnumMap, json['envergure']),
  motivations: StarMotivations.fromJson(
    json['motivations'] as Map<String, dynamic>,
  ),
  powers: (json['powers'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(int.parse(k), $enumDecode(_$StarPowerEnumMap, e)),
  ),
  companies: (json['companies'] as List<dynamic>?)
      ?.map((e) => StarCompany.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StarToJson(Star instance) => <String, dynamic>{
  'source': instance.source.toJson(),
  'name': instance.name,
  'description': instance.description,
  'envergure': _$StarReachEnumMap[instance.envergure]!,
  'motivations': instance.motivations.toJson(),
  'powers': instance.powers.map(
    (k, e) => MapEntry(k.toString(), _$StarPowerEnumMap[e]!),
  ),
  'companies': instance.companies.map((e) => e.toJson()).toList(),
};

const _$StarReachEnumMap = {
  StarReach.level0: 'level0',
  StarReach.level1: 'level1',
  StarReach.level2: 'level2',
  StarReach.level3: 'level3',
  StarReach.level4: 'level4',
  StarReach.level5: 'level5',
  StarReach.level6: 'level6',
  StarReach.level7: 'level7',
  StarReach.level8: 'level8',
  StarReach.level9: 'level9',
};

const _$StarPowerEnumMap = {
  StarPower.benediction: 'benediction',
  StarPower.champDeForce: 'champDeForce',
  StarPower.empathie: 'empathie',
  StarPower.harmonie: 'harmonie',
  StarPower.offensive: 'offensive',
  StarPower.partage: 'partage',
  StarPower.ralliement: 'ralliement',
  StarPower.rappelALaVie: 'rappelALaVie',
  StarPower.rituel: 'rituel',
  StarPower.symbiose: 'symbiose',
  StarPower.telepathie: 'telepathie',
  StarPower.transfert: 'transfert',
  StarPower.transport: 'transport',
  StarPower.visionPartagee: 'visionPartagee',
};

PlayersStar _$PlayersStarFromJson(Map<String, dynamic> json) =>
    PlayersStar(
        name: json['name'] as String,
        source: ObjectSource.fromJson(json['source'] as Map<String, dynamic>),
        location: json['location'] == null
            ? ObjectLocation.memory
            : ObjectLocation.fromJson(json['location'] as Map<String, dynamic>),
        description: json['description'] as String? ?? '',
        envergure: $enumDecode(_$StarReachEnumMap, json['envergure']),
        motivations: StarMotivations.fromJson(
          json['motivations'] as Map<String, dynamic>,
        ),
        powers: (json['powers'] as Map<String, dynamic>?)?.map(
          (k, e) => MapEntry(int.parse(k), $enumDecode(_$StarPowerEnumMap, e)),
        ),
        vertuCircles: (json['vertu_circles'] as num?)?.toInt() ?? 0,
        penchantCircles: (json['penchant_circles'] as num?)?.toInt() ?? 0,
        idealCircles: (json['ideal_circles'] as num?)?.toInt() ?? 0,
        interditCircles: (json['interdit_circles'] as num?)?.toInt() ?? 0,
        epreuveCircles: (json['epreuve_circles'] as num?)?.toInt() ?? 0,
        destineeCircles: (json['destinee_circles'] as num?)?.toInt() ?? 0,
        experiencePoints: (json['experience_points'] as num?)?.toInt() ?? 0,
      )
      ..companies = (json['companies'] as List<dynamic>)
          .map((e) => StarCompany.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$PlayersStarToJson(PlayersStar instance) =>
    <String, dynamic>{
      'source': instance.source.toJson(),
      'name': instance.name,
      'description': instance.description,
      'envergure': _$StarReachEnumMap[instance.envergure]!,
      'motivations': instance.motivations.toJson(),
      'powers': instance.powers.map(
        (k, e) => MapEntry(k.toString(), _$StarPowerEnumMap[e]!),
      ),
      'companies': instance.companies.map((e) => e.toJson()).toList(),
      'vertu_circles': instance.vertuCircles,
      'penchant_circles': instance.penchantCircles,
      'ideal_circles': instance.idealCircles,
      'interdit_circles': instance.interditCircles,
      'epreuve_circles': instance.epreuveCircles,
      'destinee_circles': instance.destineeCircles,
      'experience_points': instance.experiencePoints,
    };
