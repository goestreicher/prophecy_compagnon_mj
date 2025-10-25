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