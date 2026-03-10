import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

import 'entity/abilities.dart';
import 'resource_base_class.dart';

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

typedef EquipmentFactoryFunction = Equipment? Function(String, Map<String, dynamic>?);

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

  @override
  void restoreFromJson(Map<String, dynamic> json) {
    super.restoreFromJson(json);

    if(json.containsKey('equiped_on')) {
      equipedOn = EquipableItemTarget.values.byName(json['equiped_on']);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...(super.toJson()),
      'body_part': bodyPart.name,
      'handiness': handiness,
      'equiped_on': equipedOn.name,
    };
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