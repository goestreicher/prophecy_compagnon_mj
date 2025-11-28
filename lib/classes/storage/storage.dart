import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

import 'storable.dart';
import 'storage_engine.dart';
import 'engines/hive.dart';

typedef StoreAdapterFactory = ObjectStoreAdapter Function();

class DataStorage {
  static DataStorage get instance => _instance ??= DataStorage._ctor();

  String get uriScheme => _engine.uriScheme();
  String get uriHost => _engine.uriHost();

  Future<void> init() async {
    await _engine.init();
  }

  Future<List<String>> keys<T>(String category) async {
    return _engine.keys(category);
  }

  Future<String> get(String category, String key) async {
    return await _engine.get(category, key);
  }

  Future<void> save(String category, String key, String object) async {
    await _engine.save(category, key, object);
  }

  Future<void> delete(String category, String key) async {
    await _engine.delete(category, key);
  }

  Future<Uint8List> export() async {
    var archive = Archive();

    for(var factory in _adapters.values) {
      var category = factory().storeCategory();
      for(var key in await keys(category)) {
        var archiveFile = ArchiveFile.bytes(
          '$category/$key',
          utf8.encode(await get(category, key))
        );
        archive.addFile(archiveFile);
      }
    }

    return ZipEncoder().encodeBytes(archive);
  }

  Future<void> import(Uint8List bytes) async {
    for(var category in _adapters.keys) {
      _engine.purge(category);
    }

    var archive = ZipDecoder().decodeBytes(bytes);

    for(var file in archive) {
      if(file.isFile) {
        var category = p.dirname(file.name);
        var key = p.basename(file.name);
        if(_adapters.containsKey(category)) {
          save(category, key, utf8.decode(file.content));
        }
      }
    }
  }

  static void registerStoreAdapter(
    String category,
    StoreAdapterFactory factory,
  ) {
    _adapters[category] = factory;
  }

  DataStorage._ctor()
    : _engine = HiveStorageEngine();

  final StorageEngine _engine;
  static DataStorage? _instance;
  static final Map<String, StoreAdapterFactory> _adapters =
      <String, StoreAdapterFactory>{};
}