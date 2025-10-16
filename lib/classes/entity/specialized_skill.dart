import 'package:json_annotation/json_annotation.dart';

import '../../text_utils.dart';
import '../caste/base.dart';
import 'skill.dart';

part 'specialized_skill.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, constructor: 'create')
class SpecializedSkill {
  factory SpecializedSkill(String id) {
    _initializeGlobalSpecializedSkills();
    if(_instances.containsKey(id)) {
      return _instances[id]!;
    }
    throw UnsupportedError('No such skill $id');
  }

  factory SpecializedSkill.create({
    required Skill parent,
    required String name,
    bool reserved = false,
    String? reservedPrefix,
    List<Caste> reservedCastes = const <Caste>[],
  }) {
    _initializeGlobalSpecializedSkills();

    var cId = _getId(parent, name, reserved: reserved, reservedPrefix: reservedPrefix);
    if(_instances.containsKey(cId)) {
      return _instances[cId]!;
    }

    SpecializedSkill s = SpecializedSkill._internal(
      parent: parent,
      name: name,
      reserved: reserved,
      reservedPrefix: reservedPrefix,
      reservedCastes: reservedCastes,
    );

    _instances[cId] = s;
    return s;
  }

  SpecializedSkill._internal({
    required this.parent,
    required this.name,
    this.reserved = false,
    this.reservedPrefix,
    this.reservedCastes = const <Caste>[],
  });

  static List<SpecializedSkill> withParent(
    Skill parent,
    {
      includeReserved = false,
      Caste? includeForCaste
    }
  ) {
    _initializeGlobalSpecializedSkills();
    return _instances.values
        .where(
            (SpecializedSkill s) => (
            (!s.reserved || includeReserved) && s.parent == parent)
            && (includeForCaste == null || s.reservedCastes.contains(includeForCaste))
        )
        .toList();
  }

  static bool exists(String id) {
    _initializeGlobalSpecializedSkills();
    return _instances.containsKey(id);
  }

  static SpecializedSkill? byId(String id) {
    _initializeGlobalSpecializedSkills();
    return _instances[id];
  }

  static SpecializedSkill? byName(Skill parent, String name, { includeReserved = false }) {
    _initializeGlobalSpecializedSkills();
    SpecializedSkill? ret;
    for(SpecializedSkill sp in _instances.values) {
      if((!sp.reserved || includeReserved) && sp.parent == parent && sp.name == name) {
        ret = sp;
      }
    }
    return ret;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  String get id => _getId(parent, name, reserved: reserved, reservedPrefix: reservedPrefix);
  final Skill parent;
  final String name;
  bool reserved;
  String? reservedPrefix;
  List<Caste> reservedCastes;

  static final Map<String, SpecializedSkill> _instances = <String, SpecializedSkill>{};
  static bool _globalSpecializedSkillsInitialized = false;

  static String _getId(Skill parent, String name, { bool reserved = false, String? reservedPrefix }) =>
      '${reserved ? "reserved:" : ""}${reservedPrefix ?? ""}${parent.toString()}:${sentenceToCamelCase(transliterateFrenchToAscii(name))}';

  static void _initializeGlobalSpecializedSkills() {
    if(SpecializedSkill._globalSpecializedSkillsInitialized) return;
    SpecializedSkill._globalSpecializedSkillsInitialized = true;

    // TODO: add useful and known specializations here
    // ignore:unused_local_variable
    var s = SpecializedSkill.create(
      parent: Skill.artisanat,
      name: "Artisanat élémentaire",
      reservedCastes: [Caste.artisan],
    );

    s = SpecializedSkill.create(
      parent: Skill.vieEnCite,
      name: "Marché noir",
      reservedCastes: [Caste.commercant],
    );

    s = SpecializedSkill.create(
      parent: Skill.esquive,
      name: "Repli",
      reservedCastes: [Caste.commercant],
    );

    s = SpecializedSkill.create(
      parent: Skill.deguisement,
      name: "Usurpation",
      reservedCastes: [Caste.commercant],
    );

    s = SpecializedSkill.create(
      parent: Skill.vieEnCite,
      name: "Instinct citadin (Mage des Cités)",
      reservedCastes: [Caste.mage],
    );

    s = SpecializedSkill.create(
      parent: Skill.lireEtEcrire,
      name: "Cryptographie",
      reservedCastes: [Caste.erudit],
    );

    s = SpecializedSkill.create(
      parent: Skill.artisanat,
      name: "Ingénierie navale",
      reservedCastes: [Caste.erudit],
    );

    s = SpecializedSkill.create(
      parent: Skill.orientation,
      name: "Navigation",
      reservedCastes: [Caste.erudit],
    );

    s = SpecializedSkill.create(
      parent: Skill.diplomatie,
      name: "Ambassade maritime (Mage des Océans)",
      reservedCastes: [Caste.mage],
    );

    s = SpecializedSkill.create(
      parent: Skill.medecine,
      name: "Médecine animale",
      reservedCastes: [Caste.prodige],
    );

    s = SpecializedSkill.create(
      parent: Skill.medecine,
      name: "Médecine de Heyra (Mage de la Nature)",
      reservedCastes: [Caste.mage],
    );

    s = SpecializedSkill.create(
      parent: Skill.strategie,
      name: "Manœuvre",
      reservedCastes: [Caste.protecteur],
    );

    s = SpecializedSkill.create(
      parent: Skill.discretion,
      name: "Camouflage",
      reservedCastes: [Caste.voyageur],
    );

    s = SpecializedSkill.create(
      parent: Skill.equitation,
      name: "Tir monté",
      reservedCastes: [Caste.voyageur],
    );
  }

  factory SpecializedSkill.fromJson(Map<String, dynamic> json) =>
      _$SpecializedSkillFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SpecializedSkillToJson(this);

  @override
  bool operator==(Object other) =>
      other is SpecializedSkill && name == other.name;

  @override
  int get hashCode => name.hashCode;
}