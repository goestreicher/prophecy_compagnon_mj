import 'dart:async';
import 'dart:collection';

class ResourceMemoryCacheEntry<T> {
  ResourceMemoryCacheEntry({ required this.entry, required this.timestamp });

  T entry;
  int timestamp;
}

class ResourceMemoryCache<T> {
  ResourceMemoryCache({ this.entryTtl = 600 })
    : purged = false
  {
    _purgeTimer = Timer.periodic(
      const Duration(minutes: 1),
      (Timer timer) => _purgeCache(),
    );
  }

  int entryTtl;
  bool purged;

  bool get isEmpty => _cache.isEmpty;
  Iterable<String> get keys =>
      _cache.keys;
  Iterable<T> get values =>
      _cache.values.map((ResourceMemoryCacheEntry<T> v) => v.entry);

  bool contains(String key) => _cache.containsKey(key);

  T? entry(String key) {
    if(_cache.containsKey(key)) {
      int now = (DateTime.timestamp().millisecondsSinceEpoch ~/ (60 * 1000)) * 60;
      _ttlTouch(key, _cache[key]!.timestamp, now);
    }
    return _cache[key]?.entry;
  }

  void add(String key, T entry) {
    // Register entries with a 1-minute precision
    int ts = (DateTime.timestamp().millisecondsSinceEpoch ~/ (60 * 1000)) * 60;

    if(_cache.containsKey(key)) {
      _ttlTouch(key, _cache[key]!.timestamp, ts);
    }
    else {
      _cache[key] = ResourceMemoryCacheEntry(entry: entry, timestamp: ts);
      _ttlAdd(key, ts);
    }
  }

  void del(String key) {
    if(_cache.containsKey(key)) _ttlDel(key, _cache[key]!.timestamp);
    _cache.remove(key);
  }

  void _ttlTouch(String key, int oldTs, int newTs) {
    _ttlDel(key, oldTs);
    _ttlAdd(key, newTs);
  }

  void _ttlAdd(String key, int ts) {
    var keys = _ttls.putIfAbsent(ts, () => <String>{});
    keys.add(key);
  }

  void _ttlDel(String key, int ts) {
    _ttls[ts]?.remove(key);
  }

  void _purgeCache() {
    int now = (DateTime.timestamp().millisecondsSinceEpoch ~/ (60 * 1000)) * 60;
    int ts = now - entryTtl;
    int? ttlKey = _ttls.lastKeyBefore(ts);
    Set<int> expiredTimestamps = <int>{};
    Set<String> expiredKeys = <String>{};

    while(ttlKey != null) {
      expiredTimestamps.add(ttlKey);
      expiredKeys.addAll(_ttls[ttlKey]!);
      ts = ttlKey;
      ttlKey = _ttls.lastKeyBefore(ts);
    }

    purged = expiredKeys.isNotEmpty;
    for(var ts in expiredTimestamps) {
      _ttls.remove(ts);
    }
    for(var key in expiredKeys) {
      _cache.remove(key);
    }
  }

  // ignore:unused_field
  late final Timer _purgeTimer;
  final Map<String, ResourceMemoryCacheEntry<T>> _cache = <String, ResourceMemoryCacheEntry<T>>{};
  final SplayTreeMap<int, Set<String>> _ttls = SplayTreeMap<int, Set<String>>();
}