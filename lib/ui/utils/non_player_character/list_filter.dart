import '../../../classes/non_player_character.dart';
import '../../../classes/npc_category.dart';
import '../../../classes/object_source.dart';

class NPCListFilter {
  NPCListFilter({
    this.sourceType,
    this.source,
    this.category,
    this.subCategory,
    this.search,
  });

  ObjectSourceType? sourceType;
  ObjectSource? source;
  NPCCategory? category;
  NPCSubCategory? subCategory;
  String? search;

  bool match(NonPlayerCharacterSummary npc) =>
      (sourceType == null || npc.source.type == sourceType)
      && (source == null || npc.source == source)
      && (category == null || npc.category == category)
      && (subCategory == null || npc.subCategory == subCategory)
      && (search == null || npc.name.toLowerCase().contains(search!.toLowerCase()));

  @override
  int get hashCode => Object.hash(sourceType, source, category, subCategory, search);

  @override
  bool operator ==(Object other) =>
      other is NPCListFilter
      && other.sourceType == sourceType
      && other.source == source
      && other.category == category
      && other.subCategory == subCategory
      && other.search == search;
}