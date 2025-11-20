import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'entity/abilities.dart';

part 'equipment.g.dart';

enum EquipableItemBodyPart {
  none,
  body,
  hand,
  feet,
}

enum EquipableItemTarget {
  none,
  body,
  dominantHand,
  weakHand,
  bothHands,
  feet,
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

class EquipmentFactory {
  static final EquipmentFactory instance = EquipmentFactory._create();

  void registerFactory(String id, Equipment? Function(String,String) factory) {
    if(!_factories.containsKey(id)) _factories[id] = factory;
  }

  bool hasFactory(String id) => _factories.containsKey(id);

  Equipment? Function(String,String)? getFactory(String id) {
    return _factories[id];
  }

  Equipment? forgeEquipment(String fullId, { String uuid = '' }) {
    var ids = fullId.split(':');
    if (ids.length < 2) return null;
    var factory = EquipmentFactory.instance.getFactory(ids[0]);
    if (factory == null) return null;
    var eq = factory(ids[1], uuid.isNotEmpty ? uuid : const Uuid().v4().toString());
    return eq;
  }

  EquipmentFactory._create();

  final Map<String, Equipment? Function(String,String)> _factories = {};
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

abstract class EquipmentModel {
  EquipmentModel({
    required this.name,
    required this.weight,
    required this.creationDifficulty,
    required this.creationTime,
    required this.villageAvailability,
    required this.cityAvailability,
  });

  String get uuid;

  String name;
  double weight;
  int creationDifficulty;
  int creationTime;
  EquipmentAvailability villageAvailability;
  EquipmentAvailability cityAvailability;
}

abstract class Equipment {
  Equipment({
    required this.name,
    required this.weight
  });

  String type();
  String uuid();

  String name;
  double weight;
}

abstract class EquipableItem extends Equipment {
  EquipableItem({
    required super.name,
    required super.weight,
    required this.bodyPart,
    required this.handiness,
    EquipableItemTarget equipedOn = EquipableItemTarget.none,
  })
      : equipedOnNotifier = ValueNotifier<EquipableItemTarget>(equipedOn);

  final EquipableItemBodyPart bodyPart;
  final int handiness;
  EquipableItemTarget get equipedOn => equipedOnNotifier.value;
  set equipedOn(EquipableItemTarget target) => equipedOnNotifier.value = target;
  ValueNotifier<EquipableItemTarget> equipedOnNotifier;

  Map<Ability,int> equipRequirements();

  @mustCallSuper
  void equiped(SupportsEquipableItem owner, EquipableItemTarget target) {
    equipedOnNotifier.value = target;
  }

  @mustCallSuper
  void unequiped(SupportsEquipableItem owner) {
    equipedOnNotifier.value = EquipableItemTarget.none;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, createFactory: false)
abstract mixin class SupportsEquipableItem {
  bool meetsEquipableRequirements(EquipableItem item);
  String unmetEquipableRequirementsDescription(EquipableItem item);

  bool canEquip(EquipableItem item, { required EquipableItemTarget target }) {
    bool can = false;

    if(item.bodyPart == EquipableItemBodyPart.none) {
      can = (target == EquipableItemTarget.none);
    }
    else if(item.bodyPart == EquipableItemBodyPart.body) {
      can = (target == EquipableItemTarget.body) && (bodyEquiped == null);
    }
    else if(item.bodyPart == EquipableItemBodyPart.hand) {
      // TODO: manage handiness set to zero
      //    See comment in equip()
      if(item.handiness == 2) {
        can = (target == EquipableItemTarget.bothHands)
              && (dominantHandEquiped == null)
              && (weakHandEquiped == null);
      }
      else if(item.handiness == 1) {
        if(target == EquipableItemTarget.dominantHand) {
          can = (dominantHandEquiped == null);
        } else if(target == EquipableItemTarget.weakHand) {
          can = (weakHandEquiped == null);
        }
      }
    }

    return can;
  }

  bool isEquiped(EquipableItem item)
    => (bodyEquiped == item)
        || (dominantHandEquiped == item)
        || (weakHandEquiped == item);

  void equip(EquipableItem item, { required EquipableItemTarget target }) {
    if(canEquip(item, target: target)) {
      if(item.bodyPart == EquipableItemBodyPart.body) {
        bodyEquiped = item;
      }
      else if(item.bodyPart == EquipableItemBodyPart.hand) {
        // TODO: manage 'handiness' set to zero
        //   Create a special item that wraps the item with a bigger handiness
        //   and manage it this way?
        if(target == EquipableItemTarget.bothHands) {
          dominantHandEquiped = item;
          weakHandEquiped = item;
        }
        else if(target == EquipableItemTarget.dominantHand) {
          dominantHandEquiped = item;
        }
        else {
          weakHandEquiped = item;
        }
      }

      item.equiped(this, target);
      equiped.add(item);
    }
  }

  void replaceEquiped(EquipableItem item, { required EquipableItemTarget target }) {
    if(item.bodyPart == EquipableItemBodyPart.body) {
      if(bodyEquiped != null) {
        unequip(bodyEquiped!);
      }
      equip(item, target: target);
    }
    else if(item.bodyPart == EquipableItemBodyPart.hand) {
      if(item.handiness == 2) {
        if(dominantHandEquiped != null ) {
          unequip(dominantHandEquiped!);
        }
        if(weakHandEquiped != null) {
          unequip(weakHandEquiped!);
        }
      }
      else if(item.handiness == 1) {
        if(target == EquipableItemTarget.dominantHand && dominantHandEquiped != null) {
          unequip(dominantHandEquiped!);
        }
        else if(target == EquipableItemTarget.weakHand && weakHandEquiped != null) {
          unequip(weakHandEquiped!);
        }
        
        if(target == EquipableItemTarget.dominantHand && weakHandEquiped == item) {
          unequip(weakHandEquiped!);
        }
        else if(target == EquipableItemTarget.weakHand && dominantHandEquiped == item) {
          unequip(dominantHandEquiped!);
        }
      }
      // TODO: manage handiness set to zero
      equip(item, target: target);
    }
    else {
      if(equiped.contains(item)) {
        unequip(item);
      }
    }
  }

  void unequip(EquipableItem item) {
    if(isEquiped(item)) {
      if(bodyEquiped == item) bodyEquiped = null;
      if(dominantHandEquiped == item) dominantHandEquiped = null;
      if(weakHandEquiped == item) weakHandEquiped = null;

      item.unequiped(this);
      item.equipedOn = EquipableItemTarget.none;
      equiped.remove(item);
    }
  }

  @JsonKey(includeToJson: false, includeFromJson: false)
  EquipableItem? bodyEquiped;
  @JsonKey(includeToJson: false, includeFromJson: false)
  EquipableItem? dominantHandEquiped;
  @JsonKey(includeToJson: false, includeFromJson: false)
  EquipableItem? weakHandEquiped;
  @JsonKey(includeToJson: false, includeFromJson: false)
  List<EquipableItem> equiped = <EquipableItem>[];

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

      var eq = EquipmentFactory.instance.forgeEquipment(e['type'], uuid: e['uuid']);

      if(eq is EquipableItem && j.containsKey('equiped_on')) {
        eq.equipedOn = EquipableItemTarget.values.byName(j['equiped_on']);
      }

      if (eq != null) {
        equipment.add(eq);
        uuids.add(eq.uuid());
      }
    }

    return EntityEquipment(equipment);
  }

  static List<Map<String, dynamic>> toJson(EntityEquipment ee) {
    List<Map<String, dynamic>> ret = [];

    for(var eq in ee) {
      ret.add({
        'type': eq.type(),
        'uuid': eq.uuid(),
        'equiped_on': eq is EquipableItem
          ? eq.equipedOn.name
          : EquipableItemTarget.none.name,
      });
    }

    return ret;
  }

  final List<Equipment> _all;
}