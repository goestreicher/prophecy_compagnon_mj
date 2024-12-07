import 'storage_engine.dart';
import 'engines/hive.dart';

class DataStorage {
  static DataStorage get instance => _instance ??= DataStorage._ctor();

  Future<void> init() async {
    await _engine.init();
  }

  // DataStorage.instance.keys(ObjectStoreAdapter<ScenarioSummary>());
  Future<List<String>> keys<T>(String category) async {
    return _engine.keys(category);
  }

  Future<String> get<T>(String category, String key) async {
    return await _engine.get(category, key);
  }

  Future<void> save(String category, String key, String object) async {
    await _engine.save(category, key, object);
  }

  Future<void> delete(String category, String key) async {
    await _engine.delete(category, key);
  }

  DataStorage._ctor()
    : _engine = HiveStorageEngine();

  static DataStorage? _instance;
  final StorageEngine _engine;
}