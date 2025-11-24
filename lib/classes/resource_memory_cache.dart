import 'dart:async';
import 'dart:collection';

import 'package:prophecy_compagnon_mj/classes/storage/storable.dart';
import 'package:synchronized/synchronized.dart';

import 'object_location.dart';
import 'resource_base_class.dart';
import 'storage/default_assets_store.dart';

class ResourceMemoryCacheEntry<T> {
  ResourceMemoryCacheEntry({ required this.entry, required this.timestamp });

  T entry;
  int timestamp;
}

class ResourceMemoryCache<Resource extends ResourceBaseClass, Store extends JsonStoreAdapter<Resource>> {
  ResourceMemoryCache({ required this.jsonConverter, required this.store, this.entryTtl = 600 })
    : purged = false
  {
    _purgeTimer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer timer) => _purgeCache(),
    );
  }

  Resource Function(Map<String, dynamic>) jsonConverter;
  Store Function() store;
  int entryTtl;
  bool purged;
  final Lock lock = Lock();

  bool get isEmpty => _entryCache.isEmpty;
  Iterable<String> get keys =>
      _entryCache.keys;
  Iterable<Resource> get values =>
      _entryCache.values.map((ResourceMemoryCacheEntry<Resource> v) => v.entry);

  bool containsCollection(String name) => _collectionCache.containsKey(name);

  Future<Resource?> tryLoad(ObjectLocation location, String id, String Function(Map<String, dynamic>) extractId) async {
    Resource? ret;

    if(location.type == ObjectLocationType.assets) {
      var json = await loadJsonAssetObject(location.collectionUri, id, extractId);
      if(json != null) {
        // ignore:unused_local_variable
        ret = jsonConverter(json);
      }
    }
    else if(location.type == ObjectLocationType.store) {
      // ignore:unused_local_variable
      ret = await store().get(id);
    }

    return ret;
  }
  
  void addCollection(String name) {
    int ts = _getCurrentTS();
    
    if(_collectionCache.containsKey(name)) {
      _collectionTtlTouch(name, _collectionCache[name]!, ts);
    }
    else {
      _collectionTtlAdd(name, ts);
    }

    _collectionCache[name] = ts;
  }

  bool contains(String key) => _entryCache.containsKey(key);

  ObjectLocation? entryLocation(String key) => _entryToLocationCache[key];

  void updateLocation(String key, ObjectLocation loc) =>
    _entryToLocationCache[key] = loc;

  Resource? entry(String key) {
    if(_entryCache.containsKey(key)) {
      int now = _getCurrentTS();
      _entryTtlTouch(key, _entryCache[key]!.timestamp, now);
      _entryCache[key]!.timestamp = now;
    }
    return _entryCache[key]?.entry;
  }

  void add(String key, Resource entry) {
    int ts = _getCurrentTS();
    _entryToLocationCache[key] = entry.location;

    if(_entryCache.containsKey(key)) {
      _entryTtlTouch(key, _entryCache[key]!.timestamp, ts);
      _entryCache[key]!.timestamp = ts;
    }
    else {
      _entryCache[key] = ResourceMemoryCacheEntry(entry: entry, timestamp: ts);
      _entryTtlAdd(key, ts);
    }
  }

  void del(String key) {
    if(_entryCache.containsKey(key)) {
      _entryTtlDel(key, _entryCache[key]!.timestamp);
    }
    _entryToLocationCache.remove(key);
    _entryCache.remove(key);
  }

  // Register entries with a 1-minute precision
  static int _getCurrentTS() =>
      (DateTime.timestamp().millisecondsSinceEpoch ~/ (60 * 1000)) * 60;

  void _collectionTtlTouch(String name, int oldTs, int newTs) {
    _collectionTtlDel(name, oldTs);
    _collectionTtlAdd(name, newTs);
  }

  void _collectionTtlAdd(String name, int ts) {
    var keys = _collectionTtls.putIfAbsent(ts, () => <String>{});
    keys.add(name);
  }

  void _collectionTtlDel(String name, int ts) {
    _collectionTtls[ts]?.remove(name);
  }

  void _entryTtlTouch(String key, int oldTs, int newTs) {
    _entryTtlDel(key, oldTs);
    _entryTtlAdd(key, newTs);
  }

  void _entryTtlAdd(String key, int ts) {
    var keys = _entryTtls.putIfAbsent(ts, () => <String>{});
    keys.add(key);
  }

  void _entryTtlDel(String key, int ts) {
    _entryTtls[ts]?.remove(key);
  }

  void _purgeCache() async {
    await(lock.synchronized(() async {
      int now = _getCurrentTS();
      int ts = now - entryTtl;
      
      int? entryTtlKey = _entryTtls.lastKeyBefore(ts);
      Set<int> entryExpiredTimestamps = <int>{};
      Set<String> entryExpiredKeys = <String>{};
      while(entryTtlKey != null) {
        entryExpiredTimestamps.add(entryTtlKey);
        entryExpiredKeys.addAll(_entryTtls[entryTtlKey]!);
        entryTtlKey = _entryTtls.lastKeyBefore(entryTtlKey);
      }
      
      int? collectionTtlKey = _collectionTtls.lastKeyBefore(ts);
      Set<int> collectionExpiredTimestamps = <int>{};
      Set<String> collectionExpiredKeys = <String>{};
      while(collectionTtlKey != null) {
        collectionExpiredTimestamps.add(collectionTtlKey);
        collectionExpiredKeys.addAll(_collectionTtls[collectionTtlKey]!);
        collectionTtlKey = _collectionTtls.lastKeyBefore(collectionTtlKey);
      }

      purged = entryExpiredKeys.isNotEmpty || collectionExpiredKeys.isNotEmpty;

      for(var ts in collectionExpiredTimestamps) {
        _collectionTtls.remove(ts);
      }
      for(var key in collectionExpiredKeys) {
        _collectionCache.remove(key);
      }

      for(var ts in entryExpiredTimestamps) {
        _entryTtls.remove(ts);
      }
      for(var key in entryExpiredKeys) {
        // Save the last know location in case it was updated since the
        // last call to add() for this entry
        if(_entryCache.containsKey(key)) {
          _entryToLocationCache[key] = _entryCache[key]!.entry.location;
        }
        _entryCache.remove(key);
      }
    }));
  }

  // ignore:unused_field
  late final Timer _purgeTimer;

  final Map<String, int> _collectionCache = <String, int>{};
  final SplayTreeMap<int, Set<String>> _collectionTtls = SplayTreeMap<int, Set<String>>();

  final Map<String, ResourceMemoryCacheEntry<Resource>> _entryCache = <String, ResourceMemoryCacheEntry<Resource>>{};
  final SplayTreeMap<int, Set<String>> _entryTtls = SplayTreeMap<int, Set<String>>();

  final Map<String, ObjectLocation> _entryToLocationCache = <String, ObjectLocation>{};
}