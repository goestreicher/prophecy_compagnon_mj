import 'package:json_annotation/json_annotation.dart';

import 'magic.dart';

mixin MagicUser {
  int magicSkill(MagicSkill skill) => _magicSkills[skill]!;
  void setMagicSkill(MagicSkill skill, int value) => _magicSkills[skill] = value;

  int magicSphere(MagicSphere sphere) => _magicSpheres[sphere]!;
  void setMagicSphere(MagicSphere sphere, int value) {
    setMagicSpherePool(sphere, magicSpherePool(sphere) + value - magicSphere(sphere));
    _magicSpheres[sphere] = value;
  }

  int magicSpherePool(MagicSphere sphere) => _magicSpherePools[sphere]!;
  void setMagicSpherePool(MagicSphere sphere, int value) => _magicSpherePools[sphere] = value;

  List<MagicSpell> spells(MagicSphere sphere) {
    var ret = <MagicSpell>[];
    if(magicSpells.containsKey(sphere)) {
      for(var name in magicSpells[sphere]!) {
        ret.add(MagicSpell.byName(name)!);
      }
    }
    return ret;
  }
  void addSpell(MagicSpell spell) {
    if(!magicSpells.containsKey(spell.sphere)) {
      magicSpells[spell.sphere] = <String>[];
    }
    magicSpells[spell.sphere]!.add(spell.name);
  }
  void deleteSpellByName(String name) {
    for(var sphere in magicSpells.keys) {
      magicSpells[sphere]!.remove(name);
    }
  }
  void deleteSpell(MagicSpell spell) {
    if(!magicSpells.containsKey(spell.sphere)) {
      return;
    }
    magicSpells[spell.sphere]!.remove(spell.name);
  }

  @JsonKey(defaultValue: <MagicSphere, List<String>>{})
    Map<MagicSphere, List<String>> magicSpells = <MagicSphere, List<String>>{};

  @JsonKey(defaultValue: 0)
    int magicPool = 0;

  final Map<MagicSkill, int> _magicSkills = <MagicSkill, int>{
    MagicSkill.instinctive: 0,
    MagicSkill.invocatoire: 0,
    MagicSkill.sorcellerie: 0,
  };

  final Map<MagicSphere, int> _magicSpheres = <MagicSphere, int>{
    MagicSphere.pierre: 0,
    MagicSphere.feu: 0,
    MagicSphere.oceans: 0,
    MagicSphere.metal: 0,
    MagicSphere.nature: 0,
    MagicSphere.reves: 0,
    MagicSphere.cite: 0,
    MagicSphere.vents: 0,
    MagicSphere.ombre: 0,
  };

  final Map<MagicSphere, int> _magicSpherePools = <MagicSphere, int>{
    MagicSphere.pierre: 0,
    MagicSphere.feu: 0,
    MagicSphere.oceans: 0,
    MagicSphere.metal: 0,
    MagicSphere.nature: 0,
    MagicSphere.reves: 0,
    MagicSphere.cite: 0,
    MagicSphere.vents: 0,
    MagicSphere.ombre: 0,
  };
}