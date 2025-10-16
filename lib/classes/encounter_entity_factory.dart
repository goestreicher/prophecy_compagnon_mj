import 'entity_base.dart';

mixin EncounterEntityModel {
  String displayName();
  bool isUnique();
  List<EntityBase> instantiate({ int count = 1 });
}

class EncounterEntityFactory {
  static final EncounterEntityFactory instance = EncounterEntityFactory._create();

  void registerFactory(
    String id,
    Future<EncounterEntityModel?> Function(String) modelFactory,
    Future<Iterable<EntityBase>> Function(String, int) instanceFactory,
  ) {
    _modelFactories[id] = modelFactory;
    _instanceFactories[id] = instanceFactory;
  }

  bool hasFactory(String id) => _instanceFactories.containsKey(id);

  Future<EncounterEntityModel?> Function(String)? getModelFactory(String id) =>
      _modelFactories[id];

  Future<EncounterEntityModel?> getModel(String id) async {
    var split = id.split(':');
    if(split.length < 2) return null;
    if(!_modelFactories.containsKey(split[0])) return null;
    return _modelFactories[split[0]]!(split[1]);
  }

  Future<Iterable<EntityBase>> Function(String, int)? getInstanceFactory(String id) =>
      _instanceFactories[id];

  EncounterEntityFactory._create();

  static final Map<String, Future<Iterable<EntityBase>> Function(String, int)> _instanceFactories = {};
  static final Map<String, Future<EncounterEntityModel?> Function(String)> _modelFactories = {};
}