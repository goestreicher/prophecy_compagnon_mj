import '../../../classes/creature.dart';
import '../../../classes/object_source.dart';

class CreatureListFilter {
  CreatureListFilter({
    this.sourceType,
    this.source,
    this.category,
    this.search,
  });

  ObjectSourceType? sourceType;
  ObjectSource? source;
  CreatureCategory? category;
  String? search;

  bool match(CreatureSummary c) =>
      (sourceType == null || c.source.type == sourceType)
      && (source == null || c.source == source)
      && (category == null || c.category == category)
      && (search == null || c.name.toLowerCase().contains(search!.toLowerCase()));

  @override
  int get hashCode => Object.hash(sourceType, source, category, search);

  @override
  bool operator ==(Object other) =>
      other is CreatureListFilter
      && other.sourceType == sourceType
      && other.source == source
      && other.category == category
      && other.search == search;
}