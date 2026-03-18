import '../../../classes/equipment/equipment.dart';
import '../../../classes/object_source.dart';

class EquipmentModelListFilter {
  EquipmentModelListFilter({
    this.sourceType,
    this.source,
    this.unique = false,
    this.search,
  });

  ObjectSourceType? sourceType;
  ObjectSource? source;
  bool unique;
  String? search;

  bool isEmpty() =>
      sourceType == null
      && source == null
      && unique == false
      && search == null;

  bool isNotEmpty() => !isEmpty();

  bool match(EquipmentModel eq) =>
      (sourceType == null || eq.source.type == sourceType)
      && (source == null || eq.source == source)
      && (!unique || (unique && eq.unique))
      && (search == null || eq.name.toLowerCase().contains(search!.toLowerCase()));

  @override
  int get hashCode => Object.hash(sourceType, source, unique, search);

  @override
  bool operator ==(Object other) =>
      other is EquipmentModelListFilter
      && other.sourceType == sourceType
      && other.source == source
      && other.unique == unique
      && other.search == search;
}