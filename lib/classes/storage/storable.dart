import 'dart:convert';

import 'package:prophecy_compagnon_mj/classes/storage/exceptions.dart';

import 'storage.dart';

abstract class ObjectStoreAdapter<T> {
  bool nullOnKeyNotFound() => true;
  String storeCategory();
  Future<T> fromStoreRepresentation(String representation);
  String key(T object);
  Future<String> toStoreRepresentation(T object);

  Future<void> willSave(T object) async {}
  Future<void> willDelete(T object) async {}

  Future<List<T>> getAll() async {
    var ret = <T>[];
    for(var key in await DataStorage.instance.keys(storeCategory())) {
      var object = await get(key);
      if(object != null) {
        ret.add(object);
      }
    }
    return ret;
  }

  Future<T?> get(String key) async {
    var representation = await getRaw(key);
    return representation == null ? null : fromStoreRepresentation(representation);
  }

  Future<String?> getRaw(String key) async {
    try {
      return await DataStorage.instance.get(storeCategory(), key);
    }
    on KeyNotFoundException catch(e) {
      if(nullOnKeyNotFound()) return null;
      rethrow;
    }
  }

  Future<void> save(T object) async {
    await willSave(object);
    var k = key(object);
    var representation = await toStoreRepresentation(object);
    await DataStorage.instance.save(storeCategory(), k, representation);
  }

  Future<void> delete(T object) async {
    var k = key(object);
    await willDelete(object);
    await DataStorage.instance.delete(storeCategory(), k);
  }
}

abstract class JsonStoreAdapter<T> extends ObjectStoreAdapter<T> {
  Future<T> fromJsonRepresentation(Map<String, dynamic> j);
  Future<Map<String, dynamic>> toJsonRepresentation(T object);

  @override
  Future<T> fromStoreRepresentation(String representation) async {
    var j = json.decode(representation) as Map<String, dynamic>;
    return await fromJsonRepresentation(j);
  }

  @override
  Future<String> toStoreRepresentation(T object) async {
    return json.encode(await toJsonRepresentation(object));
  }
}