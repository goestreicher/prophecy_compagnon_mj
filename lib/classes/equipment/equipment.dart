import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../entity/abilities.dart';
import '../resource_base_class.dart';

part 'equipment.g.dart';

enum EquipableItemSlot {
  body(title: 'Corps'),
  fullBody(title: 'Corps & Tête'),
  upperBody(title: 'Haut du corps'),
  head(title: 'Tête'),
  neck(title: 'Cou'),
  torso(title: 'Torse'),
  belt(title: 'Ceinture'),
  arms(title: 'Bras'),
  hands(title: 'Mains'),
  dominantHand(title: 'Main dominante'),
  weakHand(title: 'Main faible'),
  fingers(title: 'Doigts'),
  legs(title: 'Jambes'),
  feet(title: 'Pieds'),
  ;
  
  final String title;
  
  const EquipableItemSlot({ required this.title });

  static List<EquipableItemSlot> slotsFor(EquipableItemSlot bp) {
    if(bp == body) {
      return [
        torso,
        arms,
        legs,
      ];
    }
    else if(bp == fullBody) {
      return [
        head,
        neck,
        torso,
        arms,
        legs,
      ];
    }
    else if(bp == upperBody) {
      return [
        torso,
        arms,
      ];
    }
    else {
      return [bp];
    }
  }
}

enum EquipableItemLayer {
  under(title: 'Sous-couche'),
  normal(title: 'Défaut'),
  over(title: 'Sur-couche'),
  ;

  final String title;

  const EquipableItemLayer({ required this.title });
}

enum EquipmentScarcity {
  tresCommun(title: 'Très commun', short: 'tc'),
  commun(title: 'Commun', short: 'c'),
  peuCommun(title: 'Peu commun', short: 'pc'),
  rare(title: 'Rare', short: 'r'),
  tresRare(title: 'Très rare', short: 'tr'),
  introuvable(title: 'Introuvable', short: 'int'),
  nonApplicable(title: 'Non applicable', short: 'NA'),
  ;

  final String title;
  final String short;

  const EquipmentScarcity({ required this.title, required this.short });
}

abstract class EquipmentFactoryImplementation {
  EquipmentModel? model(String id);
  Equipment? forge(String id, Map<String, dynamic>? json);
}

class EquipmentFactory {
  static final EquipmentFactory instance = EquipmentFactory._create();

  void registerFactory(
      String id,
      EquipmentFactoryImplementation factory
  ) {
    if(!_factories.containsKey(id)) _factories[id] = factory;
  }

  bool hasFactory(String id) => _factories.containsKey(id);

  EquipmentFactoryImplementation? getFactory(String id) {
    return _factories[id];
  }

  Equipment? forgeEquipment(String fullId, { Map<String, dynamic>? json }) {
    var ids = fullId.split(':');
    if (ids.length < 2) return null;

    var factory = EquipmentFactory.instance.getFactory(ids[0]);
    if(factory == null) return null;

    var model = factory.model(ids[1]);
    if(model == null) return null;

    if(json != null && !json.containsKey('uuid')) {
      json['uuid'] = model.unique ? model.uuid : const Uuid().v4().toString();
    }

    var eq = factory.forge(
      ids[1],
      json,
    );

    return eq;
  }

  EquipmentFactory._create();

  final Map<String, EquipmentFactoryImplementation> _factories = {};
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EquipmentAvailability {
  EquipmentAvailability({
    required this.scarcity,
    required this.price,
  });

  static final EquipmentAvailability empty = EquipmentAvailability(
      scarcity: EquipmentScarcity.nonApplicable,
      price: 0
  );

  EquipmentScarcity scarcity;
  int price;

  factory EquipmentAvailability.fromJson(Map<String, dynamic> json) =>
      _$EquipmentAvailabilityFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EquipmentAvailabilityToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EquipmentSpecialCapability {
  EquipmentSpecialCapability({ required this.description });

  String description;

  static EquipmentSpecialCapability fromJson(Map<String, dynamic> j) =>
      _$EquipmentSpecialCapabilityFromJson(j);

  Map<String, dynamic> toJson() =>
      _$EquipmentSpecialCapabilityToJson(this);
}

abstract class EquipmentModel extends ResourceBaseClass {
  EquipmentModel({
    required this.uuid,
    required super.name,
    this.unique = false,
    required super.source,
    super.location,
    required this.weight,
    required this.creationDifficulty,
    required this.creationTime,
    required this.villageAvailability,
    required this.cityAvailability,
    List<EquipmentSpecialCapability>? special,
  })
    : special = special ?? <EquipmentSpecialCapability>[];

  String uuid;
  bool unique;
  double weight;
  int creationDifficulty;
  int creationTime;
  EquipmentAvailability villageAvailability;
  EquipmentAvailability cityAvailability;
  List<EquipmentSpecialCapability> special;

  @override String get id => uuid;
}

abstract class EquipableItemModel extends EquipmentModel {
  EquipableItemModel({
    required super.uuid,
    required super.name,
    super.unique,
    required super.source,
    super.location,
    required super.weight,
    required super.creationDifficulty,
    required super.creationTime,
    required super.villageAvailability,
    required super.cityAvailability,
    required this.slot,
    required this.handiness,
    this.layer = EquipableItemLayer.normal,
    required super.special,
  });

  EquipableItemSlot slot;
  int handiness;
  EquipableItemLayer layer;
}

abstract class Equipment {
  Equipment({
    required this.model,
  });

  String type();
  String uuid();

  EquipmentModel model;
  String get name => model.name;
  double get weight => model.weight;

  @mustCallSuper
  void restoreFromJson(Map<String, dynamic> json) {
    // no-op
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weight': weight,
      'type': type(),
      'uuid': uuid(),
    };
  }
}

abstract class EquipableItem extends Equipment {
  EquipableItem({
    required super.model,
    EquipableItemSlot? equipedOn,
  })
    : equipedOnNotifier = ValueNotifier<EquipableItemSlot?>(equipedOn);

  EquipableItemSlot? get equipedOn => equipedOnNotifier.value;
  set equipedOn(EquipableItemSlot? target) => equipedOnNotifier.value = target;
  ValueNotifier<EquipableItemSlot?> equipedOnNotifier;

  Map<Ability,int> equipRequirements();

  @mustCallSuper
  void equiped(SupportsEquipableItem owner, EquipableItemSlot target) {
    equipedOnNotifier.value = target;
  }

  @mustCallSuper
  void unequiped(SupportsEquipableItem owner) {
    equipedOnNotifier.value = null;
  }

  @override
  void restoreFromJson(Map<String, dynamic> json) {
    super.restoreFromJson(json);

    if(json.containsKey('equiped_on') && json['equiped_on'] != null) {
      equipedOn = EquipableItemSlot.values.byName(json['equiped_on']);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...(super.toJson()),
      'equiped_on': equipedOn?.name,
    };
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, createFactory: false)
abstract mixin class SupportsEquipableItem {
  bool meetsEquipableRequirements(EquipableItem item);
  String unmetEquipableRequirementsDescription(EquipableItem item);

  bool canEquip({ required EquipableItem item, required EquipableItemSlot target }) {
    bool can = true;

    for(var realBp in EquipableItemSlot.slotsFor((item.model as EquipableItemModel).slot)) {
      if(realBp == EquipableItemSlot.hands) {
        var eit = item.model as EquipableItemModel;

        if(eit.handiness == 2) {
          can =
            target == EquipableItemSlot.hands
            && isSlotFree(
                EquipableItemSlot.dominantHand,
                (item.model as EquipableItemModel).layer
            )
            && isSlotFree(
                EquipableItemSlot.weakHand,
                (item.model as EquipableItemModel).layer
            );
        }
        else if(eit.handiness == 1) {
          if(target == EquipableItemSlot.dominantHand) {
            can = isSlotFree(
                EquipableItemSlot.dominantHand,
                (item.model as EquipableItemModel).layer
            );
          }
          else if(target == EquipableItemSlot.weakHand) {
            can = isSlotFree(
                EquipableItemSlot.weakHand,
                (item.model as EquipableItemModel).layer
            );
          }
          else {
            can = false;
          }
        }
      }
      else {
        can = isSlotFree(
            realBp,
            (item.model as EquipableItemModel).layer
        );
      }

      if(!can) {
        break;
      }
    }

    return can;
  }

  bool isEquiped(EquipableItem item) {
    for(var bp in equiped.keys) {
      for(var layer in equiped[bp]!.keys) {
        if(equiped[bp]![layer] == item) {
          return true;
        }
      }
    }
    return false;
  }

  void equip({ required EquipableItem item, required EquipableItemSlot target }) {
    if(canEquip(item: item, target: target)) {
      var eit = item.model as EquipableItemModel;

      for(var realBp in EquipableItemSlot.slotsFor(eit.slot)) {
        if(realBp == EquipableItemSlot.hands) {
          if(eit.handiness == 2) {
            if (equiped[realBp] == null) {
              equiped[realBp] = <EquipableItemLayer, EquipableItem>{};
            }
            equiped[realBp]![eit.layer] = item;
          }
          else if(eit.handiness == 1) {
            if (equiped[target] == null) {
              equiped[target] = <EquipableItemLayer, EquipableItem>{};
            }
            equiped[target]![eit.layer] = item;
          }
        }
        else {
          if (equiped[realBp] == null) {
            equiped[realBp] = <EquipableItemLayer, EquipableItem>{};
          }
          equiped[realBp]![eit.layer] = item;
        }
      }

      item.equiped(this, target);
    }
  }

  void replaceEquiped({ required EquipableItem item, required EquipableItemSlot target }) {
    var eit = item.model as EquipableItemModel;
    var currentlyEquipedItems = <EquipableItem>[];

    if(target == EquipableItemSlot.dominantHand || target == EquipableItemSlot.weakHand) {
      if(equiped.containsKey(target) && equiped[target]![eit.layer] != null) {
        currentlyEquipedItems.add(equiped[target]![eit.layer]!);
      }
    }

    for(var realBp in EquipableItemSlot.slotsFor(eit.slot)) {
      if(target == EquipableItemSlot.hands) {
        for(var bp in [EquipableItemSlot.dominantHand, EquipableItemSlot.weakHand]) {
          if(equiped.containsKey(bp) && equiped[bp]![eit.layer] != null) {
            currentlyEquipedItems.add(equiped[bp]![eit.layer]!);
          }
        }
      }
      else if(equiped.containsKey(realBp) && equiped[realBp]![eit.layer] != null) {
        currentlyEquipedItems.add(equiped[realBp]![eit.layer]!);
      }
    }

    for(var currentlyEquipedItem in currentlyEquipedItems) {
      if(currentlyEquipedItem.equipedOn == null) {
        continue;
      }
      unequip(currentlyEquipedItem);
    }

    equip(item: item, target: target);
  }

  void unequip(EquipableItem item) {
    if(isEquiped(item)) {
      for(var bp in equiped.keys) {
        equiped[bp]!.removeWhere((k, v) => v == item);
      }

      item.unequiped(this);
      item.equipedOn = null;
    }
  }

  List<EquipableItem> equipedForSlot(EquipableItemSlot slot) {
    var ret = <EquipableItem>[];
    for(var layer in equiped[slot]?.keys ?? <EquipableItemLayer>[]) {
      ret.add(equiped[slot]![layer]!);
    }
    return ret;
  }

  @JsonKey(includeToJson: false, includeFromJson: false)
  Map<EquipableItemSlot, Map<EquipableItemLayer, EquipableItem>> equiped =
    <EquipableItemSlot, Map<EquipableItemLayer, EquipableItem>>{};

  bool isSlotFree(EquipableItemSlot slot, EquipableItemLayer layer) {
    if(!equiped.containsKey(slot)) return true;
    if(!equiped[slot]!.containsKey(layer)) return true;
    return false;
  }

  Map<String, dynamic> toJson() => _$SupportsEquipableItemToJson(this);
}

class EntityEquipment with IterableMixin<Equipment>, ChangeNotifier {
  EntityEquipment(List<Equipment>? equipment)
    : _all = equipment ?? <Equipment>[];

  @override
  Iterator<Equipment> get iterator => _all.iterator;

  void add(Equipment e) {
    _all.add(e);
    notifyListeners();
  }

  void remove(Equipment e) {
    _all.remove(e);
    notifyListeners();
  }

  static EntityEquipment fromJson(List<dynamic> json) {
    var equipment = <Equipment>[];
    var uuids = <String>{};

    for(var j in json) {
      var e = j as Map<String, dynamic>;

      if(!e.containsKey('uuid')) {
        e['uuid'] = const Uuid().v4().toString();
      }
      else if(uuids.contains(e['uuid'] as String)) {
        continue;
      }

      var eq = EquipmentFactory.instance.forgeEquipment(e['type'], json: e);

      if (eq != null) {
        eq.restoreFromJson(e);
        equipment.add(eq);
        uuids.add(eq.uuid());
      }
    }

    return EntityEquipment(equipment);
  }

  static List<Map<String, dynamic>> toJson(EntityEquipment ee) {
    List<Map<String, dynamic>> ret = [];

    for(var eq in ee) {
      ret.add(eq.toJson());
    }

    return ret;
  }

  final List<Equipment> _all;
}