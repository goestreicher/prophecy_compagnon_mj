import 'package:json_annotation/json_annotation.dart';

import '../../text_utils.dart';

part 'place.g.dart';

enum PlaceType {
  monde(title: 'Monde'),
  continent(title: 'Continent'),
  nation(title: 'Nation'),
  archiduche(title: 'Archiduché'),
  principaute(title: 'Principauté'),
  duche(title: 'Duché'),
  marche(title: 'Marche'),
  comte(title: 'Comté'),
  baronnie(title: 'Baronnie'),
  citeLibre(title: 'Cité Libre'),
  capitale(title: 'Capitale'),
  cite(title: 'Cité'),
  ville(title: 'Ville'),
  village(title: 'Village'),
  ;

  final String title;

  const PlaceType({ required this.title });
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Place {
  factory Place({
    Place? parent,
    required PlaceType type,
    required String name,
    bool isDefault = false,
  }) {
    _doStaticinit();
    var id = sentenceToCamelCase(transliterateFrenchToAscii(name));
    if(!_instances.containsKey(id)) {
      var place = Place._create(
        parent: parent,
        type: type,
        name: name,
        isDefault: isDefault,
      );
      _instances[id] = place;
    }
    return _instances[id]!;
  }
  
  Place._create({
    this.parent,
    required this.type,
    required this.name,
    this.isDefault = false,
  });

  static Place monde = Place(
      parent: null,
      type: PlaceType.monde,
      name: 'Monde',
      isDefault: true,
  );
  static Place kor = Place(
    parent: Place.monde,
    type: PlaceType.continent,
    name: 'Kor',
    isDefault: true,
  );
  static Place archipelDePyr = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Archipel de Pyr',
    isDefault: true,
  );
  static Place citeDeGriff = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Cité de Griff',
    isDefault: true,
  );
  static Place empireDeSolyr = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Empire de Solyr',
    isDefault: true,
  );
  static Place empireNesora = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Empire Nésora',
    isDefault: true,
  );
  static Place empireZul = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Empire Zûl',
    isDefault: true,
  );
  static Place foretDeSolor = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Forêt de Solor',
    isDefault: true,
  );
  static Place foretMere = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Forêt Mère',
    isDefault: true,
  );
  static Place jaspor = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Jaspor',
    isDefault: true,
  );
  static Place kali = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Kali',
    isDefault: true,
  );
  static Place kar = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Kar',
    isDefault: true,
  );
  static Place kern = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Kern',
    isDefault: true,
  );
  static Place lacsSanglants = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Lacs Sanglants',
    isDefault: true,
  );
  static Place marchesAlyzees = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Marches Alyzées',
    isDefault: true,
  );
  static Place pomyrie = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Pomyrie',
    isDefault: true,
  );
  static Place principauteDeMarne = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Principauté de Marne',
    isDefault: true,
  );
  static Place royaumeDesFleurs = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Royaume des Fleurs',
    isDefault: true,
  );
  static Place terresGalyrs = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Terres Galyrs',
    isDefault: true,
  );
  static Place ysmir = Place(
    parent: Place.kor,
    type: PlaceType.nation,
    name: 'Ysmir',
    isDefault: true,
  );

  String get id => sentenceToCamelCase(transliterateFrenchToAscii(name));
  final Place? parent;
  final PlaceType type;
  final String name;
  final bool isDefault;

  static List<Place> values() {
    _doStaticinit();
    return _instances.values.toList();
  }

  static List<Place> byType(PlaceType type) {
    _doStaticinit();
    return _instances.values
        .where((Place p) => p.type == type)
        .toList();
  }

  static final Map<String, Place> _instances = <String, Place>{};
  static bool _staticInitDone = false;

  static void _doStaticinit() {
    if(_staticInitDone) return;
    _staticInitDone = true;
    // ignore: unused_local_variable
    var p = Place.monde;
    p = Place.kor;
    p = Place.archipelDePyr;
    p = Place.citeDeGriff;
    p = Place.empireDeSolyr;
    p = Place.empireNesora;
    p = Place.empireZul;
    p = Place.foretDeSolor;
    p = Place.foretMere;
    p = Place.jaspor;
    p = Place.kali;
    p = Place.kar;
    p = Place.kern;
    p = Place.lacsSanglants;
    p = Place.marchesAlyzees;
    p = Place.pomyrie;
    p = Place.principauteDeMarne;
    p = Place.royaumeDesFleurs;
    p = Place.terresGalyrs;
    p = Place.ysmir;
  }

  factory Place.fromJson(Map<String, dynamic> json) {
    if(json.containsKey('id') && _instances.containsKey(json['id']!) && _instances[json['id']]!.isDefault) {
      return _instances[json['id']]!;
    } else {
      return _$PlaceFromJson(json);
    }
  }

  Map<String, dynamic> toJson() {
    if(isDefault) {
      return {'id': id};
    }
    else {
      return _$PlaceToJson(this);
    }
  }
}
