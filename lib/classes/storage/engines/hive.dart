import 'package:hive_flutter/adapters.dart';

import '../exceptions.dart';
import '../storage_engine.dart';

class HiveStorageEngine implements StorageEngine {
  HiveStorageEngine();

  @override
  String uriScheme() => 'hive';

  @override
  String uriHost() => 'localdb';

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
  Future<String> get(String category, String key) async {
    var box = await Hive.openLazyBox('${category}Box');
    var res = await box.get(key);
    if(res == null) throw KeyNotFoundException(category, key);
    return res;
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

  @override
  Future<void> purge(String category) async {
    var box = await Hive.openLazyBox('${category}Box');
    await box.clear();
  }
}