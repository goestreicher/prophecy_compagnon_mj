import 'package:hive_flutter/adapters.dart';

import '../storage_engine.dart';

class HiveStorageEngine implements StorageEngine {
  HiveStorageEngine();

  @override
  Future<void> init() async {
    await Hive.initFlutter();
  }

  @override
  Future<List<String>> keys(String category) async {
    var box = await Hive.openLazyBox('${category}Box');
    return box.keys.toList().cast<String>();
  }

  @override
  Future<String?> get(String category, String key) async {
    var box = await Hive.openLazyBox('${category}Box');
    return await box.get(key);
  }

  @override
  Future<void> save(String category, String key, String data) async {
    var box = await Hive.openLazyBox('${category}Box');
    await box.put(key, data);
  }

  @override
  Future<void> delete(String category, String key) async {
    var box = await Hive.openLazyBox('${category}Box');
    await box.delete(key);
  }
}