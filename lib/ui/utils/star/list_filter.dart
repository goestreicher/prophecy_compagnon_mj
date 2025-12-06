import '../../../classes/object_source.dart';
import '../../../classes/star.dart';

class StarListFilter {
  StarListFilter({
    this.sourceType,
    this.source,
    this.search,
  });

  ObjectSourceType? sourceType;
  ObjectSource? source;
  String? search;

  bool match(Star star) =>
      (sourceType == null || star.source.type == sourceType)
      && (source == null || star.source == source)
      && (search == null || star.name.toLowerCase().contains(search!.toLowerCase()));

  @override
  int get hashCode => Object.hash(sourceType, source, search);

  @override
  bool operator ==(Object other) =>
      other is StarListFilter
          && other.sourceType == sourceType
          && other.source == source
          && other.search == search;
}