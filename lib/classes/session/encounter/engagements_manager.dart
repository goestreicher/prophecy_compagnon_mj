import '../../combat.dart';
import '../../entity_base.dart';
import '../../string_pair_map_key.dart';

class EngagementsManager {
  EngagementsManager(List<(String, String, WeaponRange)>? engagements)
    : _engagements = <StringPairMapKey, WeaponRange>{}
  {
    for(var rec in engagements ?? []) {
      var k = StringPairMapKey(rec.$1, rec.$2);
      _engagements[k] = rec.$3;
    }
  }

  void engage(EntityBase attacker, EntityBase defender, WeaponRange range) {
    var k = StringPairMapKey(attacker.id, defender.id);

    if(!_engagements.containsKey(k) || _engagements[k]!.index > range.index) {
      _engagements[k] = range;
    }
  }

  void disengage(EntityBase attacker, EntityBase defender, { WeaponRange? newRange }) {
    var k = StringPairMapKey(attacker.id, defender.id);
    if(!_engagements.containsKey(k)) return;

    if(newRange != null && newRange.index > _engagements[k]!.index) {
      _engagements[k] = newRange;
    }
    else {
      _engagements.remove(k);
    }
  }

  Iterable<WeaponRange> allFor(EntityBase entity) =>
    _engagements.entries
      .where(
        (MapEntry<StringPairMapKey, WeaponRange> e) =>
            e.key.pair.$1 == entity.id || e.key.pair.$2 == entity.id
      )
      .map((MapEntry<StringPairMapKey, WeaponRange> e) => e.value);

  WeaponRange? smallestFor(EntityBase entity) {
    Iterable<WeaponRange> all = allFor(entity);

    if(all.isEmpty) return null;
    if(all.length == 1) return all.elementAt(0);

    return all.reduce(
      (WeaponRange current, WeaponRange next) =>
        current.index < next.index ? current : next
    );
  }


  final Map<StringPairMapKey, WeaponRange> _engagements;
}