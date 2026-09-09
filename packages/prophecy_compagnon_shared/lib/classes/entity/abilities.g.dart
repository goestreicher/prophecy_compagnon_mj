// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abilities.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityAbilities _$EntityAbilitiesFromJson(Map<String, dynamic> json) =>
    EntityAbilities.empty()
      ..force = (json['force'] as num).toInt()
      ..intelligence = (json['intelligence'] as num).toInt()
      ..coordination = (json['coordination'] as num).toInt()
      ..presence = (json['presence'] as num).toInt()
      ..resistance = (json['resistance'] as num).toInt()
      ..volonte = (json['volonte'] as num).toInt()
      ..perception = (json['perception'] as num).toInt()
      ..empathie = (json['empathie'] as num).toInt();

Map<String, dynamic> _$EntityAbilitiesToJson(EntityAbilities instance) =>
    <String, dynamic>{
      'force': instance.force,
      'intelligence': instance.intelligence,
      'coordination': instance.coordination,
      'presence': instance.presence,
      'resistance': instance.resistance,
      'volonte': instance.volonte,
      'perception': instance.perception,
      'empathie': instance.empathie,
    };
