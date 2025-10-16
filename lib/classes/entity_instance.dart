import 'package:json_annotation/json_annotation.dart';

import 'entity/injury.dart';
import 'entity/abilities.dart';
import 'entity/attributes.dart';
import 'entity/skills.dart';
import 'entity/status.dart';
import 'equipment.dart';
import 'entity_base.dart';
import 'exportable_binary_data.dart';
import 'magic.dart';
import 'magic_user.dart';
import 'object_location.dart';
import 'storage/storable.dart';

part 'entity_instance.g.dart';

class EntityInstanceModelRetriever {
  static final EntityInstanceModelRetriever instance = EntityInstanceModelRetriever._create();

  void registerRetriever(String type, Future<EntityBase?> Function(String) retriever) {
    _retrievers[type] = retriever;
  }

  bool hasRetriever(String type) => _retrievers.containsKey(type);

  Future<EntityBase?> Function(String)? retriever(String type) => _retrievers[type];

  Future<EntityBase?> retrieveModel(String specification) async {
    var ids = specification.split(':');
    if(ids.length != 2) return null;
    if(!hasRetriever(ids[0])) return null;
    return retriever(ids[0])?.call(ids[1]);
  }

  EntityInstanceModelRetriever._create();

  static final Map<String, Future<EntityBase?> Function(String)> _retrievers =
      <String, Future<EntityBase?> Function(String)>{};
}

class EntityInstanceStore extends JsonStoreAdapter<EntityInstance> {
  EntityInstanceStore();

  @override
  String storeCategory() => 'entityInstances';

  @override
  String key(EntityInstance object) => object.id;

  @override
  Future<EntityInstance> fromJsonRepresentation(Map<String, dynamic> j) async {
    var model = EntityInstance.fromJson(j);
    model.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
    return model;
  }

  @override
  Future<Map<String, dynamic>> toJsonRepresentation(EntityInstance object) async {
    var j = object.toJson();
    j.remove('image');
    j.remove('icon');
    return j;
  }

  @override
  Future<void> willSave(EntityInstance object) async {
    // Force-set the location here in case the object is used after being saved,
    // even if the location is not saved in the store (excluded from the
    // JSON representation).
    object.location = ObjectLocation(
      type: ObjectLocationType.store,
      collectionUri: '${getUriBase()}/${storeCategory()}',
    );
  }

  @override
  Future<void> willDelete(EntityInstance object) async {
    // NO-OP
  }
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class EntityInstance extends EntityBase with MagicUser {
  EntityInstance(
    {
      super.uuid,
      super.location = ObjectLocation.memory,
      required super.name,
      super.initiative,
      super.injuryProvider,
      super.size,
      required this.modelSpecification,
    }
  ) {
    EntityInstanceModelRetriever.instance.retrieveModel(modelSpecification)
      .then((EntityBase? m) => model = m!);
  }

  final String modelSpecification;
  @JsonKey(includeFromJson: false, includeToJson: false)
    late final EntityBase model;

  @override
  ExportableBinaryData? get image => model.image;

  @override
  ExportableBinaryData? get icon => model.icon;

  static EntityInstance prepareInstantiation({
    required EntityBase entity,
    required String name,
    required String modelSpecification,
  }) {
    var instance = EntityInstance(
      location: ObjectLocation.memory,
      name: name,
      initiative: entity.initiative,
      injuryProvider: (EntityBase? e, InjuryManager? i) =>
          InjuryManager(
            levels: entity.injuries.manager.levels(),
          ),
      size: entity.size,
      modelSpecification: modelSpecification,
    );

    for(var a in Ability.values) {
      instance.abilities.setAbility(a, entity.abilities.ability(a));
    }
    for(var a in Attribute.values) {
      instance.attributes.setAttribute(a, entity.attributes.attribute(a));
    }
    for(var s in entity.skills.all) {
      var i = instance.skills.add(s.skill);
      i.value = s.value;

      for(var sp in s.specializations) {
        i.addSpecialization(sp.skill).value = sp.value;
      }
    }

    for(var e in entity.equipment) {
      var eq = EquipmentFactory.instance.forgeEquipment(e.type());
      if(eq != null) {
        instance.addEquipment(eq);
      }
    }

    if(entity is MagicUser) {
      for(var s in MagicSkill.values) {
        instance.magic.skills.set(s, entity.magic.skills.get(s));
      }

      instance.magicPool = entity.magicPool;

      for(var s in MagicSphere.values) {
        instance.magic.spheres.set(s, entity.magic.spheres.get(s));
        instance.magic.pools.set(s, entity.magic.pools.get(s));
      }

      for(var s in entity.magic.spells) {
        instance.magic.spells.add(s);
      }
    }

    return instance;
  }

  factory EntityInstance.fromJson(Map<String, dynamic> json) {
    EntityInstance c = _$EntityInstanceFromJson(json);
    c.loadNonRestorableJson(json);
    return c;
  }

  @override
  Map<String, dynamic> toJson() {
    var j = _$EntityInstanceToJson(this);
    saveNonExportableJson(j);
    return j;
  }
}