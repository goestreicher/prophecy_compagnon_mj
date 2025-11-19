import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

part 'abilities.g.dart';

enum Ability {
  force(title: "Force", short: 'FOR'),
  intelligence(title: "Intelligence", short: 'INT'),
  coordination(title: "Coordination", short: 'COO'),
  presence(title: "Présence", short: 'PRÉ'),
  resistance(title: "Résistance", short: 'RÉS'),
  volonte(title: "Volonté", short: 'VOL'),
  perception(title: "Perception", short: 'PER'),
  empathie(title: "Empathie", short: 'EMP');

  const Ability({
    required this.title,
    required this.short,
  });

  final String title;
  final String short;
}

class AbilityStreamChange {
  AbilityStreamChange({ required this.ability, required this.value });

  Ability ability;
  int value;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true, constructor: 'empty')
class EntityAbilities {
  EntityAbilities({ required Map<Ability, int> abilities })
    : _abilities = Map.from(abilities);

  EntityAbilities.empty()
    : _abilities = <Ability, int>{for(var a in Ability.values) a: 0};

  @JsonKey(includeFromJson: false, includeToJson: false)
  StreamController<AbilityStreamChange> streamController =
      StreamController<AbilityStreamChange>.broadcast();

  Map<Ability, int> get all => _abilities;

  int get force => ability(Ability.force);
  set force(int v) => setAbility(Ability.force, v);

  int get intelligence => ability(Ability.intelligence);
  set intelligence(int v) => setAbility(Ability.intelligence, v);

  int get coordination => ability(Ability.coordination);
  set coordination(int v) => setAbility(Ability.coordination, v);

  int get presence => ability(Ability.presence);
  set presence(int v) => setAbility(Ability.presence, v);

  int get resistance => ability(Ability.resistance);
  set resistance(int v) => setAbility(Ability.resistance, v);

  int get volonte => ability(Ability.volonte);
  set volonte(int v) => setAbility(Ability.volonte, v);

  int get perception => ability(Ability.perception);
  set perception(int v) => setAbility(Ability.perception, v);

  int get empathie => ability(Ability.empathie);
  set empathie(int v) => setAbility(Ability.empathie, v);

  int ability(Ability a) => _abilities[a] ?? 0;

  void setAbility(Ability a, int v) {
    _abilities[a] = v;
    streamController.add(AbilityStreamChange(ability: a, value: v));
  }

  final Map<Ability, int> _abilities;

  factory EntityAbilities.fromJson(Map<String, dynamic> json) =>
      _$EntityAbilitiesFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EntityAbilitiesToJson(this);
}