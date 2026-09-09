// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MoneyWallet _$MoneyWalletFromJson(Map<String, dynamic> json) => MoneyWallet(
  fer: (json['fer'] as num?)?.toInt() ?? 0,
  bronze: (json['bronze'] as num?)?.toInt() ?? 0,
  argent: (json['argent'] as num?)?.toInt() ?? 0,
  or: (json['or'] as num?)?.toInt() ?? 0,
  dragon: (json['dragon'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MoneyWalletToJson(MoneyWallet instance) =>
    <String, dynamic>{
      'fer': instance.fer,
      'bronze': instance.bronze,
      'argent': instance.argent,
      'or': instance.or,
      'dragon': instance.dragon,
    };
