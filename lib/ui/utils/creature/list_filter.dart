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