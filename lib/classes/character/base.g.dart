// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttributeBasedCalculator _$AttributeBasedCalculatorFromJson(
        Map<String, dynamic> json) =>
    AttributeBasedCalculator(
      static: (json['static'] as num).toDouble(),
      multiply: (json['multiply'] as num).toInt(),
      add: (json['add'] as num).toInt(),
      dice: (json['dice'] as num).toInt(),
    );

Map<String, dynamic> _$AttributeBasedCalculatorToJson(
        AttributeBasedCalculator instance) =>
    <String, dynamic>{
      'static': instance.static,
      'multiply': instance.multiply,
      'add': instance.add,
      'dice': instance.dice,
    };
