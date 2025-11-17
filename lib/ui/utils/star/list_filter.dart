import '../../../classes/object_source.dart';

class StarListFilter {
  StarListFilter({
    this.sourceType,
    this.source,
    this.search,
  });

  ObjectSourceType? sourceType;
  ObjectSource? source;
  String? search;

  @override
  int get hashCode => Object.hash(sourceType, source, search);

  @override
  bool operator ==(Object other) =>
      other is StarListFilter
          && other.sourceType == sourceType
          && other.source == source
          && other.search == search;
}