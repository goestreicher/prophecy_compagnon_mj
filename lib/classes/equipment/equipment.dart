import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import '../entity/abilities.dart';
import '../resource_base_class.dart';
import 'enums.dart';

part 'equipment.g.dart';

abstract class EquipmentFactoryImplementation {
  EquipmentModel? fromJson(Map<String, dynamic> json);
  EquipmentModel? model(String id);
  Equipment? forge(String id, Map<String, dynamic>? json);
  Future<void> saveLocalModel(EquipmentModel model);
  Future<void> deleteLocalModel(EquipmentModel model);
  Future<void> reloadFromStore(String uuid);
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
    var ids = id.split(':');
    if(ids.length < 2) {
      return _factories[id];
    }
    else {
      return _factories[ids[0]];
    }
  }

  EquipmentModel? fromJson(Map<String, dynamic> json) {
    if(!json.containsKey('factory')) return null;

    var factory = getFactory(json['factory']);
    if(factory == null) return null;

    return factory.fromJson(json);
  }

  EquipmentModel? getModel(String id) {
    var ids = id.split(':');
    if (ids.length < 2) return null;

    var factory = EquipmentFactory.instance.getFactory(ids[0]);
    if(factory == null) return null;

    return factory.model(ids[1]);
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
  EquipmentSpecialCapability({
    this.title,
    required this.description,
  });

  @JsonKey(includeIfNull: false)
  String? title;
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
    this.description = '',
    required this.weight,
    required this.creationDifficulty,
    required this.creationTime,
    required this.villageAvailability,
    required this.cityAvailability,
    this.supportsMetal = false,
    this.intrinsicResistance,
    List<EquipmentSpecialCapability>? special,
  })
    : special = special ?? <EquipmentSpecialCapability>[];

  String uuid;
  bool unique;
  String description;
  double weight;
  int creationDifficulty;
  int creationTime;
  EquipmentAvailability villageAvailability;
  EquipmentAvailability cityAvailability;
  bool supportsMetal;
  @JsonKey(includeIfNull: false)
  EquipmentQuality? intrinsicResistance;
  List<EquipmentSpecialCapability> special;

  String get factory;

  Map<String, dynamic> toJson();

  @override
  String get id => '$factory:$uuid';

  int price(EquipmentAvailabilityZone where) {
    if(where == EquipmentAvailabilityZone.village) {
      return villageAvailability.price;
    }
    else {
      return cityAvailability.price;
    }
  }
}

abstract class EquipableItemModel extends EquipmentModel {
  EquipableItemModel({
    required super.uuid,
    required super.name,
    super.unique,
    required super.source,
    super.location,
    super.description,
    required super.weight,
    required super.creationDifficulty,
    required super.creationTime,
    required super.villageAvailability,
    required super.cityAvailability,
    required this.slot,
    required this.handiness,
    this.layer = EquipableItemLayer.normal,
    super.supportsMetal,
    super.intrinsicResistance,
    required super.special,
  });

  EquipableItemSlot slot;
  int handiness;
  EquipableItemLayer layer;
}

abstract class Equipment {
  Equipment({
    required this.model,
    this.alias,
    this.quality = EquipmentQuality.normal,
    this.metal = EquipmentMetal.none,
    this.inStore = false,
  }) {
    if(model.supportsMetal && metal == EquipmentMetal.none) {
      metal = EquipmentMetal.iron;
    }
  }

  String uuid();

  String type() => '${model.factory}:${model.id}';

  EquipmentModel model;
  String? alias;
  EquipmentQuality quality;
  EquipmentMetal metal;
  bool inStore;

  String get name => alias ?? model.name;

  String get description => model.description;

  double get weight => model.weight * metal.weightModifier;

  EquipmentQuality get resistance => model.intrinsicResistance ?? metal.intrinsicResistance;

  int price(EquipmentAvailabilityZone where) =>
    (
      model.price(where)
      * (weight - model.weight * (metal.priceModifier ?? 0))
      * quality.priceMultiplier
    ).round();

  @mustCallSuper
  void restoreFromJson(Map<String, dynamic> json) {
    if(json['alias'] != null && (json['alias']! as String).isNotEmpty) {
      alias = json['alias']!;
    }

    if(json['quality'] != null) {
      quality = EquipmentQuality.values.byName(json['quality']);
    }

    if(json['metal'] != null && model.supportsMetal) {
      var m = EquipmentMetal.values.byName(json['metal']);
      metal = m == EquipmentMetal.none
        ? EquipmentMetal.iron
        : m;
    }

    if(json['in_store'] != null) {
      inStore = json['in_store'] as bool;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'alias': alias,
      'type': type(),
      'uuid': uuid(),
      'quality': quality.name,
      'metal': metal.name,
      'in_store': inStore,
    };
  }
}

abstract class EquipableItem extends Equipment {
  EquipableItem({
    required super.model,
    super.alias,
    super.quality,
    super.metal,
    EquipableItemSlot? equipedOn,
    super.inStore,
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
        if(equiped[bp]![layer]!.contains(item)) {
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
            if(equiped[realBp] == null) {
              equiped[realBp] = <EquipableItemLayer, List<EquipableItem>>{};
            }
            if(equiped[realBp]![eit.layer] == null) {
              equiped[realBp]![eit.layer] = <EquipableItem>[];
            }
            if(!equiped[realBp]![eit.layer]!.contains(item)) {
              equiped[realBp]![eit.layer]!.add(item);
            }
          }
          else if(eit.handiness == 1) {
            if(equiped[target] == null) {
              equiped[target] = <EquipableItemLayer, List<EquipableItem>>{};
            }
            if(equiped[target]![eit.layer] == null) {
              equiped[target]![eit.layer] = <EquipableItem>[];
            }
            if(!equiped[target]![eit.layer]!.contains(item)) {
              equiped[target]![eit.layer]!.add(item);
            }
          }
        }
        else {
          if (equiped[realBp] == null) {
            equiped[realBp] = <EquipableItemLayer, List<EquipableItem>>{};
          }
          if(equiped[realBp]![eit.layer] == null) {
            equiped[realBp]![eit.layer] = <EquipableItem>[];
          }
          if(!equiped[realBp]![eit.layer]!.contains(item)) {
            equiped[realBp]![eit.layer]!.add(item);
          }
        }
      }

      item.equiped(this, target);
    }
  }

  void replaceEquiped({ required EquipableItem item, required EquipableItemSlot target }) {
    var eit = item.model as EquipableItemModel;
    var itemsToDesequip = <EquipableItem>[];

    if(target == EquipableItemSlot.dominantHand || target == EquipableItemSlot.weakHand) {
      if(equiped.containsKey(target) && equiped[target]![eit.layer] != null) {
        itemsToDesequip.addAll(equiped[target]![eit.layer]!);
      }
    }

    for(var realBp in EquipableItemSlot.slotsFor(eit.slot)) {
      if(target == EquipableItemSlot.hands) {
        for(var bp in [EquipableItemSlot.dominantHand, EquipableItemSlot.weakHand]) {
          if(equiped.containsKey(bp) && equiped[bp]![eit.layer] != null) {
            itemsToDesequip.addAll(equiped[bp]![eit.layer]!);
          }
        }
      }
      else if(
          equiped.containsKey(realBp)
          && equiped[realBp]![eit.layer] != null
          && equiped[realBp]![eit.layer]!.length >= realBp.slots
      ) {
        itemsToDesequip.add(equiped[realBp]![eit.layer]![0]);
      }
    }

    for(var currentlyEquipedItem in itemsToDesequip) {
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
        for(var layer in equiped[bp]!.values) {
          layer.removeWhere((e) => e == item);
        }
        equiped[bp]!.removeWhere((k, v) => v.isEmpty);
      }

      item.unequiped(this);
      item.equipedOn = null;
    }
  }

  List<EquipableItem> equipedForSlot(EquipableItemSlot slot) {
    var ret = <EquipableItem>[];
    for(var layer in equiped[slot]?.keys ?? <EquipableItemLayer>[]) {
      ret.addAll(equiped[slot]![layer]!);
    }
    return ret;
  }

  bool isSlotFree(EquipableItemSlot slot, EquipableItemLayer layer) {
    if(!equiped.containsKey(slot)) return true;
    if(!equiped[slot]!.containsKey(layer)) return true;
    if(equiped[slot]![layer]!.length < slot.slots) return true;
    return false;
  }

  @JsonKey(includeToJson: false, includeFromJson: false)
  Map<EquipableItemSlot, Map<EquipableItemLayer, List<EquipableItem>>> equiped =
    <EquipableItemSlot, Map<EquipableItemLayer, List<EquipableItem>>>{};

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

  void removeWhere(bool Function(Equipment) where) {
    _all.removeWhere(where);
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