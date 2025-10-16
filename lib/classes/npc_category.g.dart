// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'npc_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NPCSubCategory _$NPCSubCategoryFromJson(Map<String, dynamic> json) =>
    NPCSubCategory(
      title: json['title'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => const NPCCategoryJsonConverter().fromJson(e as String))
          .toList(),
      isDefault: json['is_default'] as bool? ?? false,
    );

Map<String, dynamic> _$NPCSubCategoryToJson(NPCSubCategory instance) =>
    <String, dynamic>{
      'title': instance.title,
      'categories': instance.categories
          .map(const NPCCategoryJsonConverter().toJson)
          .toList(),
    };
