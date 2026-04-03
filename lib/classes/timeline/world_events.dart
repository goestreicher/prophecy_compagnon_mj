import '../calendar.dart';
import '../object_source.dart';
import '../storage/default_assets_store.dart';
import 'event.dart';

class WorldEvents {
  WorldEvents();

  static Iterable<TimelineEvent> forAge(KorAge age) {
    var filter = WorldEventFilter(
      age: age,
    );

    return _events
        .where((TimelineEvent e) => filter.match(e));
  }

  static Iterable<TimelineEvent> matching(WorldEventFilter filter) =>
    _events
      .where((TimelineEvent e) => filter.match(e));

  static Future<void> loadAll() async {
    if(_events.isNotEmpty) return;

    var assetFiles = [
      'events-avant-le-temps.json',
      'events-age-des-fondations.json',
      'events-age-des-conquetes.json',
      'events-age-des-empires.json',
    ];

    for(var f in assetFiles) {
      for(var e in await loadJSONAssetObjectList(f)) {
        var evt = TimelineEvent.fromJson(e);
        _events.add(evt);
      }
    }
  }

  static final List<TimelineEvent> _events = <TimelineEvent>[];
}

abstract class WorldEventFilterComparator {
  bool match<ComparableType>(ComparableType reference, ComparableType value);
}

class WorldEventFilterComparatorEquals implements WorldEventFilterComparator {
  @override
  bool match<ComparableType>(ComparableType reference, ComparableType value) =>
      reference == value;
}

class WorldEventFilter {
  WorldEventFilter({
    this.sourceType,
    this.source,
    this.age,
  });

  ObjectSourceType? sourceType;
  ObjectSource? source;
  KorAge? age;

  bool match(TimelineEvent event) =>
      (sourceType == null || sourceType == event.source.type)
      && (source == null || source == event.source)
      && (age == null || age == event.range.start.age);
}