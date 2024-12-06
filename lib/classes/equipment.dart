import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'character/base.dart';

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

abstract class Equipment {
  String type();
  String uuid();
  String name();
  double weight();
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

      item.equiped(this);
      item._equipedOn = target;
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
    var eq = isEquiped(item);

    if(bodyEquiped == item) bodyEquiped = null;
    if(dominantHandEquiped == item) dominantHandEquiped = null;
    if(weakHandEquiped == item) weakHandEquiped = null;

    if(eq) {
      item.unequiped(this);
      item._equipedOn = EquipableItemTarget.none;
      equiped.remove(item);
    }
  }

  @JsonKey(includeToJson: false, includeFromJson: false)
    EquipableItem? bodyEquiped;
  @JsonKey(includeToJson: false, includeFromJson: false)
    EquipableItem? dominantHandEquiped;
  @JsonKey(includeToJson: false, includeFromJson: false)
    EquipableItem? weakHandEquiped;
  // Just here to keep track of equiped items during save / restore
  @JsonKey(includeToJson: true, includeFromJson: false, toJson: equipedToJson)
    List<EquipableItem> equiped = <EquipableItem>[];

  Map<String, dynamic> toJson() => _$SupportsEquipableItemToJson(this);
}

List<Map<String, dynamic>> equipedToJson(List<EquipableItem> items) {
  var ret = <Map<String, dynamic>>[];
  for(var item in items) {
    var i = <String, dynamic>{
      'uuid': item.uuid(),
      'equiped_on': item._equipedOn.name,
    };
    ret.add(i);
  }
  return ret;
}

abstract class EquipableItem extends Equipment {
  EquipableItem({
    required this.bodyPart,
    required this.handiness,
  });

  final EquipableItemBodyPart bodyPart;
  final int handiness;

  List<(Ability,int)> equipRequirements();
  void equiped(SupportsEquipableItem owner);
  void unequiped(SupportsEquipableItem owner);

  EquipableItemTarget _equipedOn = EquipableItemTarget.none;
}