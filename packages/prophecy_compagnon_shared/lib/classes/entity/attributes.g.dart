// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attributes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EntityAttributes _$EntityAttributesFromJson(Map<String, dynamic> json) =>
    EntityAttributes.empty()
      ..physique = (json['physique'] as num).toInt()
      ..mental = (json['mental'] as num).toInt()
      ..manuel = (json['manuel'] as num).toInt()
      ..social = (json['social'] as num).toInt();

Map<String, dynamic> _$EntityAttributesToJson(EntityAttributes instance) =>
    <String, dynamic>{
      'physique': instance.physique,
      'mental': instance.mental,
      'manuel': instance.manuel,
      'social': instance.social,
    };
