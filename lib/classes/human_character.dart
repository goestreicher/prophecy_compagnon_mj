import 'package:json_annotation/json_annotation.dart';

import 'entity_base.dart';
import 'combat.dart';
import 'equipment.dart';
import 'exportable_binary_data.dart';
import 'magic.dart';
import 'magic_user.dart';
import 'place.dart';
import 'weapon.dart';
import 'character/base.dart';
import 'character/injury.dart';
import 'character/skill.dart';

part 'human_character.g.dart';

enum DisadvantageType {
  commun(title: 'Commun'),
  rare(title: 'Rare'),
  enfant(title: 'Enfant'),
  ancien(title: 'Ancien');

  final String title;

  const DisadvantageType({ required this.title });
}

enum Disadvantage {
  anomalie(title: 'Anomalie', cost: [2], type: DisadvantageType.commun),
  complexeDInferiorite(title: "Complexe d'infériorité", cost: [3], type: DisadvantageType.commun),
  dette(title: 'Dette', cost: [1,2], type: DisadvantageType.commun),
  echec(title: 'Échec', cost: [3], type: DisadvantageType.commun),
  emotif(title: 'Émotif', cost: [3], type: DisadvantageType.commun),
  ennemi(title: 'Ennemi', cost: [3], type: DisadvantageType.commun),
  faiblesse(title: 'Faiblesse', cost: [2], type: DisadvantageType.commun),
  fragilite(title: 'Fragilité', cost: [2], type: DisadvantageType.commun),
  interdit(title: 'Interdit', cost: [3], type: DisadvantageType.commun),
  maladie(title: 'Maladie', cost: [1,3,5], type: DisadvantageType.commun),
  malchance(title: 'Malchance', cost: [3], type: DisadvantageType.commun),
  manie(title: 'Manie', cost: [1], type: DisadvantageType.commun),
  obsession(title: 'Obsession', cost: [2], type: DisadvantageType.commun),
  phobie(title: 'Phobie', cost: [1,3,5], type: DisadvantageType.commun),
  serment(title: 'Serment', cost: [2], type: DisadvantageType.commun),
  amnesie(title: 'Amnésie', cost: [3], type: DisadvantageType.rare),
  appelDeLaBete(title: 'Appel de la bête', cost: [5], type: DisadvantageType.rare),
  blessure(title: 'Blessure', cost: [5], type: DisadvantageType.rare),
  dependance(title: 'Dépendance', cost: [3], type: DisadvantageType.rare),
  deviance(title: 'Déviance', cost: [3], type: DisadvantageType.rare),
  echecRare(title: 'Échec', cost: [5], type: DisadvantageType.rare),
  ennemiRare(title: 'Ennemi', cost: [5], type: DisadvantageType.rare),
  incompetence(title: 'Incompétence', cost: [5], type: DisadvantageType.rare),
  infirmite(title: 'Infirmité', cost: [1,3,5], type: DisadvantageType.rare),
  maladresse(title: 'Maladresse', cost: [2], type: DisadvantageType.rare),
  marqueAuFer(title: 'Marqué au fer', cost: [3], type: DisadvantageType.rare),
  mauvaisOeil(title: 'Mauvais œil', cost: [3], type: DisadvantageType.rare),
  personneACharge(title: 'Personne à charge', cost: [2], type: DisadvantageType.rare),
  regardDesDragons(title: 'Regard des Dragons', cost: [3,5], type: DisadvantageType.rare),
  troubleMental(title: 'Trouble mental', cost: [3], type: DisadvantageType.rare),
  chetif(title: 'Chétif', cost: [5], type: DisadvantageType.enfant),
  curiosite(title: 'Curiosité', cost: [3], type: DisadvantageType.enfant),
  illusions(title: 'Illusions', cost: [2], type: DisadvantageType.enfant),
  insignifiant(title: 'Insignifiant', cost: [1], type: DisadvantageType.enfant),
  lassitude(title: 'Lassitude', cost: [2], type: DisadvantageType.enfant),
  mensongesInfantiles(title: 'Mensonges infantiles', cost: [1], type: DisadvantageType.enfant),
  naivete(title: 'Naïveté', cost: [2], type: DisadvantageType.enfant),
  revolte(title: 'Révolte', cost: [2], type: DisadvantageType.enfant),
  transfert(title: 'Transfert', cost: [2], type: DisadvantageType.enfant),
  versatilite(title: 'Versatilité', cost: [3], type: DisadvantageType.enfant),
  cardiaque(title: 'Cardiaque', cost: [4], type: DisadvantageType.ancien),
  edente(title: 'Édenté', cost: [3], type: DisadvantageType.ancien),
  grincheux(title: 'Grincheux', cost: [2], type: DisadvantageType.ancien),
  impotent(title: 'Impotent', cost: [4], type: DisadvantageType.ancien),
  maladeImaginaire(title: 'Malade imaginaire', cost: [2], type: DisadvantageType.ancien),
  nostalgieObsessionnelle(title: 'Nostalgie obsessionnelle', cost: [2], type: DisadvantageType.ancien),
  rhumatismes(title: 'Rhumatismes', cost: [3], type: DisadvantageType.ancien),
  senile(title: 'Sénile', cost: [4], type: DisadvantageType.ancien),
  surdite(title: 'Surdité', cost: [3], type: DisadvantageType.ancien),
  vueDefaillante(title: 'Vue défaillante', cost: [2], type: DisadvantageType.ancien)
  ;

  final String title;
  final List<int> cost;
  final DisadvantageType type;

  const Disadvantage({
    required this.title,
    required this.cost,
    required this.type,
  });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterDisadvantage {
  CharacterDisadvantage({
    required this.disadvantage,
    required this.cost,
    required this.details,
  });

  final Disadvantage disadvantage;
  final int cost;
  final String details;

  factory CharacterDisadvantage.fromJson(Map<String, dynamic> json) => _$CharacterDisadvantageFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterDisadvantageToJson(this);
}

enum AdvantageType {
  general(title: 'Général'),
  enfant(title: 'Enfant'),
  ancien(title: 'Ancien');

  final String title;

  const AdvantageType({ required this.title });
}

enum Advantage {
  agilite(title: 'Agilité', cost: [3], type: AdvantageType.general),
  allie(title: 'Allié', cost: [3,5], type: AdvantageType.general),
  ambidextre(title: 'Ambidextre', cost: [3], type: AdvantageType.general),
  armeDuMaitre(title: 'Arme du maître', cost: [2], type: AdvantageType.general),
  augureFavorable(title: 'Augure favorable', cost: [3], type: AdvantageType.general),
  chance(title: 'Chance', cost: [2], type: AdvantageType.general),
  charme(title: 'Charme', cost: [1], type: AdvantageType.general),
  confidences(title: 'Confidences', cost: [3], type: AdvantageType.general),
  corpsAguerri(title: 'Corps aguerri', cost: [3], type: AdvantageType.general),
  droiture(title: 'Droiture', cost: [1], type: AdvantageType.general),
  fortunePersonnelle(title: 'Fortune personnelle', cost: [], type: AdvantageType.general),
  heritageDraconique(title: 'Héritage draconique', cost: [6], type: AdvantageType.general),
  magieNaturelle(title: 'Magie naturelle', cost: [4], type: AdvantageType.general),
  mentor(title: 'Mentor', cost: [4], type: AdvantageType.general),
  prestance(title: 'Prestance', cost: [2], type: AdvantageType.general),
  pressentiment(title: 'Pressentiment', cost: [3], type: AdvantageType.general),
  resistanceALaMagie(title: 'Résistance à la magie', cost: [5], type: AdvantageType.general),
  santeDeFer(title: 'Santé de fer', cost: [4], type: AdvantageType.general),
  sensAccru(title: 'Sens accru', cost: [2], type: AdvantageType.general),
  sensDeLOrientation(title: "Sens de l'orientation", cost: [], type: AdvantageType.general),
  sensEnAlerte(title: 'Sens en alerte', cost: [3], type: AdvantageType.general),
  statutSocial(title: 'Statut social', cost: [2], type: AdvantageType.general),
  chanceInouie(title: 'Chance inouïe', cost: [3], type: AdvantageType.enfant),
  empathieNaturelle(title: 'Empathie naturelle', cost: [4], type: AdvantageType.enfant),
  fetiche(title: 'Fétiche', cost: [1], type: AdvantageType.enfant),
  instinctProtecteur(title: 'Instinct protecteur', cost: [2], type: AdvantageType.enfant),
  precoce(title: 'Précoce', cost: [2], type: AdvantageType.enfant),
  artInterdit(title: 'Art interdit', cost: [3], type: AdvantageType.ancien),
  conviction(title: 'Conviction', cost: [2], type: AdvantageType.ancien),
  culture(title: 'Culture', cost: [3], type: AdvantageType.ancien),
  habileteReconnue(title: 'Habileté reconnue', cost: [5], type: AdvantageType.ancien),
  objetDePredilection(title: 'Object de prédilection', cost: [3], type: AdvantageType.ancien),
  techniquePersonnelle(title: 'Technique personnelle', cost: [5], type: AdvantageType.ancien)
  ;

  final String title;
  final List<int> cost;
  final AdvantageType type;

  const Advantage({ required this.title, required this.cost, required this.type });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterAdvantage {
  CharacterAdvantage({
    required this.advantage,
    required this.cost,
    required this.details,
  });

  final Advantage advantage;
  final int cost;
  final String details;

  factory CharacterAdvantage.fromJson(Map<String, dynamic> json) => _$CharacterAdvantageFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterAdvantageToJson(this);
}

enum Tendency {
  dragon,
  human,
  fatality,
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class TendencyAttribute {
  TendencyAttribute({ required this.value, required this.circles });

  int value;
  int circles;

  factory TendencyAttribute.fromJson(Map<String, dynamic> json) => _$TendencyAttributeFromJson(json);
  Map<String, dynamic> toJson() => _$TendencyAttributeToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterTendencies {
  CharacterTendencies.empty()
    : dragon = TendencyAttribute(value: 0, circles: 0),
      human = TendencyAttribute(value: 0, circles: 0),
      fatality = TendencyAttribute(value: 0, circles: 0);

  CharacterTendencies({
    required this.dragon,
    required this.human,
    required this.fatality,
  });

  TendencyAttribute dragon;
  TendencyAttribute human;
  TendencyAttribute fatality;

  factory CharacterTendencies.fromJson(Map<String, dynamic> json) => _$CharacterTendenciesFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterTendenciesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class HumanCharacter extends EntityBase with MagicUser {
  HumanCharacter(
      {
        super.uuid,
        required super.name,
        super.initiative,
        super.injuryProvider = _humanCharacterDefaultInjuries,
        this.caste = Caste.sansCaste,
        this.casteStatus = CasteStatus.none,
        this.career,
        this.luck = 0,
        this.proficiency = 0,
        this.renown = 0,
        this.age = 25,
        this.height = 1.7,
        super.size,
        super.weight = 60.0,
        Place? origin,
        List<Interdict>? interdicts,
        List<CastePrivilege>? castePrivileges,
        List<CharacterDisadvantage>? disadvantages,
        List<CharacterAdvantage>? advantages,
        CharacterTendencies? tendencies,
        super.description,
        super.image,
        super.icon,
      })
    : origin = origin ?? Place.empireDeSolyr,
      interdicts = interdicts ?? <Interdict>[],
      castePrivileges = castePrivileges ?? <CastePrivilege>[],
      disadvantages = disadvantages ?? <CharacterDisadvantage>[],
      advantages = advantages ?? <CharacterAdvantage>[],
      tendencies = tendencies ?? CharacterTendencies.empty()
  {
    _initialize();
  }

  Caste caste;
  CasteStatus casteStatus;
  @JsonKey(defaultValue: null)
    Career? career;
  int age;
  double height;
  Place origin;
  int luck;
  int proficiency;
  int renown;
  @JsonKey(defaultValue: <Interdict>[])
    List<Interdict> interdicts;
  @JsonKey(defaultValue: <CastePrivilege>[])
    List<CastePrivilege> castePrivileges;
  List<CharacterDisadvantage> disadvantages;
  List<CharacterAdvantage> advantages;
  CharacterTendencies tendencies;

  static bool _staticInitialized = false;
  static late final Weapon _naturalWeaponFists;
  static late final Weapon _naturalWeaponFeet;

  void _initialize() {
    _initializeStatic();

    addNaturalWeapon(WeaponRange.contact, _naturalWeaponFists);
    addNaturalWeapon(WeaponRange.contact, _naturalWeaponFeet);
  }

  static void _initializeStatic() {
    if(_staticInitialized) return;
    _staticInitialized = true;

    var contactRange = AttributeBasedCalculator(
        static: 0.4,
        multiply: 1,
        add: 0,
        dice: 0);

    var sk = SpecializedSkill.create(
        'corpsACorps:naturalWeaponFists',
        Skill.corpsACorps,
        title: 'Coup de poing');
    var wm = WeaponModel(
        name: 'Poings',
        id: 'poings',
        skill: sk,
        weight: 0.0,
        bodyPart: EquipableItemBodyPart.hand,
        hands: 0,
        requirements: [],
        initiative: {
          WeaponRange.contact: 2,
          WeaponRange.melee: 0,
        },
        damage: AttributeBasedCalculator(
          static: 0.0,
          multiply: 1,
          add: 0,
          dice: 1
        ),
        rangeEffective: contactRange,
        rangeMax: contactRange);
    _naturalWeaponFists = wm.instantiate();

    sk = SpecializedSkill.create(
        'corpsACorps:naturalWeaponFeet',
        Skill.corpsACorps,
        title: 'Coup de pied');
    wm = WeaponModel(
        name: 'Pieds',
        id: 'pieds',
        skill: sk,
        weight: 0.0,
        bodyPart: EquipableItemBodyPart.feet,
        hands: 0,
        requirements: [],
        initiative: {
          WeaponRange.contact: 2,
          WeaponRange.melee: 0,
        },
        damage: AttributeBasedCalculator(
            static: 0.0,
            multiply: 1,
            add: 2,
            dice: 1
        ),
        rangeEffective: contactRange,
        rangeMax: contactRange);
    _naturalWeaponFeet = wm.instantiate();
  }

  @override
  void saveNonExportableJson(Map<String, dynamic> json) {
    super.saveNonExportableJson(json);

    json['magic_skills'] = Map<String, int>.fromEntries(
      MagicSkill.values.map(
        (MagicSkill s) => MapEntry<String, int>(s.name, magicSkill(s))
      )
    );

    json['magic_spheres'] = Map<String, int>.fromEntries(
      MagicSphere.values.map(
        (MagicSphere s) => MapEntry<String, int>(s.name, magicSphere(s))
      )
    );

    json['magic_sphere_pools'] = Map<String, int>.fromEntries(
        MagicSphere.values.map(
                (MagicSphere s) => MapEntry<String, int>(s.name, magicSpherePool(s))
        )
    );
  }

  @override
  void loadNonRestorableJson(Map<String, dynamic> json) {
    super.loadNonRestorableJson(json);

    if(json.containsKey('magic_skills') && json['magic_skills']! is Map) {
      for(var s in json['magic_skills']!.keys) {
        setMagicSkill(MagicSkill.values.byName(s), json['magic_skills']![s]!);
      }
    }

    if(json.containsKey('magic_spheres') && json['magic_spheres']! is Map) {
      for(var s in json['magic_spheres']!.keys) {
        setMagicSphere(MagicSphere.values.byName(s), json['magic_spheres']![s]!);
      }
    }

    if(json.containsKey('magic_sphere_pools') && json['magic_sphere_pools']! is Map) {
      for(var s in json['magic_sphere_pools']!.keys) {
        setMagicSpherePool(MagicSphere.values.byName(s), json['magic_sphere_pools']![s]!);
      }
    }
  }

  @override
  Map<String, dynamic> toJson() {
    var j = _$HumanCharacterToJson(this);
    saveNonExportableJson(j);
    return j;
  }

  factory HumanCharacter.fromJson(Map<String, dynamic> json) {
    HumanCharacter c = _$HumanCharacterFromJson(json);
    c.loadNonRestorableJson(json);
    return c;
  }
}

InjuryManager _humanCharacterDefaultInjuries(EntityBase? entity, InjuryManager? source) =>
    InjuryManager.simple(injuredCeiling: 40, injuredCount: 3, deathCount: 1, source: source);

InjuryManager fullCharacterDefaultInjuries(EntityBase? entity, InjuryManager? source) {
  if(entity == null) return _humanCharacterDefaultInjuries(entity, source);

  int scratchCount = 0;
  int lightCount = 0;
  int graveCount = 0;
  int fatalCount = 0;
  int sum = entity.ability(Ability.resistance) + entity.ability(Ability.volonte);

  if(sum < 5) {
    scratchCount = 2;
    lightCount = 1;
    graveCount = 1;
    fatalCount = 1;
  }
  else if(sum < 10) {
    scratchCount = 3;
    lightCount = 2;
    graveCount = 1;
    fatalCount = 1;
  }
  else if(sum < 15) {
    scratchCount = 3;
    lightCount = 2;
    graveCount = 2;
    fatalCount = 1;
  }
  else if(sum < 20) {
    scratchCount = 3;
    lightCount = 3;
    graveCount = 2;
    fatalCount = 2;
  }
  else {
    scratchCount = 3;
    lightCount = 4;
    graveCount = 3;
    fatalCount = 2;
  }

  return InjuryManager.human(
    scratchCount: scratchCount,
    lightCount: lightCount,
    graveCount: graveCount,
    fatalCount: fatalCount,
    source: source,
  );
}