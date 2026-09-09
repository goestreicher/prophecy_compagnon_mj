// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'turn_initiative_input_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionInitiative _$ActionInitiativeFromJson(Map<String, dynamic> json) =>
    ActionInitiative(
      raw: (json['raw'] as num).toInt(),
      weaponModifier: (json['weapon_modifier'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActionInitiativeToJson(ActionInitiative instance) =>
    <String, dynamic>{
      'raw': instance.raw,
      'weapon_modifier': instance.weaponModifier,
    };

TurnInitiative _$TurnInitiativeFromJson(Map<String, dynamic> json) =>
    TurnInitiative(
      dominantHand: (json['dominant_hand'] as List<dynamic>)
          .map((e) => ActionInitiative.fromJson(e as Map<String, dynamic>))
          .toList(),
      weakHand: json['weak_hand'] == null
          ? null
          : ActionInitiative.fromJson(
              json['weak_hand'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$TurnInitiativeToJson(TurnInitiative instance) =>
    <String, dynamic>{
      'dominant_hand': instance.dominantHand.map((e) => e.toJson()).toList(),
      'weak_hand': instance.weakHand?.toJson(),
    };
