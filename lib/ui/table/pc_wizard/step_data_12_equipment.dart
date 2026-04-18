import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

import '../../../classes/caste/base.dart';
import '../../../classes/entity/skill.dart';
import '../../../classes/equipment/armor.dart';
import '../../../classes/equipment/enums.dart';
import '../../../classes/equipment/equipment.dart';
import '../../../classes/equipment/weapon.dart';
import 'model.dart';
import 'step_data.dart';

class PlayerCharacterWizardStepDataEquipment extends PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepDataEquipment({
    this.equipment,
    this.money,
  })
    : currentEquipment = <Equipment?>[],
      super(title: 'Équipement')
  {
    currentMoney = money;
  }

  List<Equipment>? equipment;
  late List<Equipment?> currentEquipment;
  int? money;
  late int? currentMoney;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget overviewWidget(BuildContext context) {
    return Text('Équipement');
  }

  @override
  List<Widget> stepWidget(BuildContext context) {
    var model = context.read<PlayerCharacterWizardModel>();

    return [
      sliverWrap(
        [
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 32.0,
              children: [
                Text(
                  "Chaque personnage débute l'aventure avec un équipement de base, souvent bien usagé et dont il est familier.\nIl commence aussi avec un peu d’argent, souvent les modestes économies d’une vie au jour le jour. Bien sûr, il sera possible de modifier cet équipement selon l’argent de base du personnage, en revendant certains objets et en achetant de meilleures pièces d’équipement. L’Avantage Fortune personnelle deviendra ici des plus utiles.",
                ),
                if(_starterMoney[model.caste]! > 0)
                  _MoneyWidget(
                    dice: _starterMoney[model.caste]!,
                    amount: currentMoney,
                    onChanged: (int v) {
                      currentMoney = v;
                      changed = changed || currentMoney != money;
                    },
                  ),
                _EquipmentWidget(
                  available: _starterEquipment[model.caste!]!,
                  equipment: currentEquipment,
                  onChanged: (List<Equipment?> l) {
                    currentEquipment = l;
                    changed = true;
                  }
                )
              ],
            ),
          )
        ]
      )
    ];
  }

  @override
  bool validate(PlayerCharacterWizardModel model, BuildContext context) {
    var ret = formKey.currentState!.validate();
    if(!ret) return ret;

    var hasNull = currentEquipment.any((Equipment? e) => e == null);
    if(hasNull) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Étape incomplète'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.0,
            children: [
              Text(
                "Certains équipements n'ont pas été choisis",
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('OK'),
            )
          ]
        )
      );

      ret = false;
    }

    return true;
  }

  @override
  void init(PlayerCharacterWizardModel model) {
    if(currentEquipment.isEmpty) {
      for (var a in _starterEquipment[model.caste!]!) {
        if(a is _StarterEquipmentByID) {
          currentEquipment.add(a.toEquipment());
        }
        else {
          currentEquipment.add(null);
        }
      }
    }
  }

  @override
  void reset(PlayerCharacterWizardModel model) {
    equipment = null;
    currentEquipment = <Equipment?>[];
    model.equipment = null;

    money = null;
    currentMoney = null;
    model.money = null;
  }

  @override
  void clear() {
    currentEquipment = equipment ?? <Equipment?>[];
    currentMoney = money;
  }

  @override
  void save(PlayerCharacterWizardModel model) {
    equipment = currentEquipment
      .where((Equipment? e) => e != null)
      .map((Equipment? e) => e!)
      .toList();
    var modelEquipment = <Equipment>[];
    for(var (idx, starter) in _starterEquipment[model.caste!]!.indexed) {
      modelEquipment.add(currentEquipment[idx]!);
      if(starter.quantity > 1 && starter is _StarterEquipmentByID) {
        modelEquipment.addAll(
          List.generate(
            starter.quantity - 1,
            (int i) => EquipmentFactory.instance.forgeEquipment(starter.id)!,
          )
        );
      }
    }
    model.equipment = modelEquipment;

    money = currentMoney ?? 0;
    model.money = money;
  }
}

class _MoneyWidget extends StatefulWidget {
  const _MoneyWidget({
    required this.dice,
    this.amount,
    required this.onChanged,
  });

  final int dice;
  final int? amount;
  final void Function(int) onChanged;

  @override
  State<_MoneyWidget> createState() => _MoneyWidgetState();
}

class _MoneyWidgetState extends State<_MoneyWidget> {
  late int? amount;

  @override
  void initState() {
    super.initState();

    amount = widget.amount;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 12.0,
      children: [
        Text(
          "Argent de départ",
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        if(amount != null)
          Text(
            "$amount Dracs de bronze",
          ),
        if(amount == null)
          Row(
            spacing: 8.0,
            children: [
              Text(
                "${widget.dice}D10",
              ),
              IconButton(
                onPressed: () {
                  var sum = 0;
                  for(var i = 0; i < widget.dice; ++i) {
                    sum += Random().nextInt(10) + 1;
                  }
                  setState(() {
                    amount = sum;
                  });
                  widget.onChanged(sum);
                },
                icon: const Icon(Symbols.casino),
                iconSize: 18.0,
                padding: const EdgeInsets.all(4.0),
                constraints: const BoxConstraints(),
              ),
              Text(
                "Dracs de bronze",
              ),
            ],
          )
      ],
    );
  }
}

class _EquipmentWidget extends StatefulWidget {
  const _EquipmentWidget({
    required this.equipment,
    required this.onChanged,
    required this.available,
  });

  final List<Equipment?> equipment;
  final void Function(List<Equipment?>) onChanged;
  final List<_StarterEquipment> available;

  @override
  State<_EquipmentWidget> createState() => _EquipmentWidgetState();
}

class _EquipmentWidgetState extends State<_EquipmentWidget> {
  late List<Equipment?> currentEquipment;

  @override
  void initState() {
    super.initState();

    currentEquipment = List.from(widget.equipment);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if(widget.equipment.length != widget.available.length) {
      throw(
        ArgumentError(
          'Equipment count and available count differ: ${widget.equipment.length} / ${widget.available.length}'
        )
      );
    }

    var starterWidgets = <Widget>[];
    for(var (idx, starter) in widget.available.indexed) {
      starterWidgets.add(
        _StarterEquipmentWidget(
          starter: starter,
          instance: currentEquipment[idx],
          onChanged: (Equipment? eq) {
            setState(() {
              currentEquipment[idx] = eq;
            });
            widget.onChanged(currentEquipment);
          },
        )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.0,
      children: [
        Text(
          "Équipement de départ",
          style: theme.textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        ...starterWidgets
      ],
    );
  }
}

class _StarterEquipmentWidget extends StatelessWidget {
  const _StarterEquipmentWidget({
    required this.starter,
    this.instance,
    required this.onChanged,
  });

  final _StarterEquipment starter;
  final Equipment? instance;
  final void Function(Equipment?) onChanged;

  @override
  Widget build(BuildContext context) {
    Widget? effectiveWidget;

    if(starter is _StarterEquipmentByID) {
      if(instance != null) {
        effectiveWidget = _StarterEquipmentByIDWidget(
            starter: starter as _StarterEquipmentByID,
            instance: instance!,
        );
      }
      else {
        effectiveWidget = Text(
          'Starter equipment with only ID must always be instanciated'
        );
      }
    }
    else if(starter is _StarterEquipmentWeapon) {
      effectiveWidget = _StarterEquipmentWeaponWidget(
        starter: starter as _StarterEquipmentWeapon,
        instance: instance,
        onChanged: onChanged,
      );
    }
    else if(starter is _StarterEquipmentArmor) {
      effectiveWidget = _StarterEquipmentArmorWidget(
        starter: starter as _StarterEquipmentArmor,
        instance: instance,
        onChanged: onChanged,
      );
    }
    else {
      throw(ArgumentError('Invalid starter widget type: ${starter.runtimeType.toString()}'));
    }

    return effectiveWidget;
  }
}

class _StarterEquipmentByIDWidget extends StatelessWidget {
  const _StarterEquipmentByIDWidget({
    required this.starter,
    required this.instance,
  });

  final _StarterEquipmentByID starter;
  final Equipment instance;

  @override
  Widget build(BuildContext context) {
    return Text(
      '\u2022 ${instance.name} x ${starter.quantity}',
    );
  }
}

class _StarterEquipmentWeaponWidget extends StatefulWidget {
  const _StarterEquipmentWeaponWidget({
    required this.starter,
    this.instance,
    required this.onChanged,
  });
  
  final _StarterEquipmentWeapon starter;
  final Equipment? instance;
  final void Function(Equipment?) onChanged;

  @override
  State<_StarterEquipmentWeaponWidget> createState() => _StarterEquipmentWeaponWidgetState();
}

class _StarterEquipmentWeaponWidgetState extends State<_StarterEquipmentWeaponWidget> {
  Skill? currentSkill;
  WeaponModel? currentModel;
  
  @override
  void initState() {
    super.initState();
    
    if(widget.starter.skills.length == 1) {
      currentSkill = widget.starter.skills[0];
    }
  }
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if(widget.instance != null && widget.instance is Weapon) {
      var m = widget.instance!.model as WeaponModel;
      return Row(
        spacing: 12.0,
        children: [
          Text(
            '\u2022 ${m.skill.parent.title} : ${m.name}',
          ),
          IconButton(
            onPressed: () {
              setState(() {
                currentModel = null;
                currentSkill = null;
              });
              widget.onChanged(null);
            },
            icon: const Icon(Icons.cancel_outlined),
            iconSize: 18.0,
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(),
          ),
        ],
      );
    }

    return Row(
      spacing: 12.0,
      children: [
        Text(
          'Arme',
          style: theme.textTheme.bodyMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        if(widget.starter.skills.length > 1)
          SizedBox(
            width: 250,
            child: DropdownMenuFormField<Skill>(
              initialSelection: currentSkill,
              requestFocusOnTap: true,
              expandedInsets: EdgeInsets.zero,
              label: const Text('Type'),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                isCollapsed: true,
                constraints: BoxConstraints(maxHeight: 36.0),
                contentPadding: EdgeInsets.all(12.0),
              ),
              dropdownMenuEntries: widget.starter.skills
                  .map((Skill s) => DropdownMenuEntry(value: s, label: s.title))
                  .toList(),
              onSelected: (Skill? v) {
                if(v == null) return;
                setState(() {
                  currentSkill = v;
                });
              },
              autovalidateMode: AutovalidateMode.onUserInteractionIfError,
              validator: (Skill? v) {
                if(v == null) return 'Valeur manquante';
                return null;
              },
            ),
          ),
        if(currentSkill != null)
          SizedBox(
            width: 250,
            child: DropdownMenuFormField<WeaponModel>(
              initialSelection: currentModel,
              requestFocusOnTap: true,
              expandedInsets: EdgeInsets.zero,
              label: const Text('Arme'),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                isCollapsed: true,
                constraints: BoxConstraints(maxHeight: 36.0),
                contentPadding: EdgeInsets.all(12.0),
              ),
              dropdownMenuEntries: WeaponModel.idsBySkill(currentSkill!)
                .map((String id) => WeaponModel.get(id))
                .where((WeaponModel? m) => !(m?.unique ?? true) && (m?.handiness ?? 0) > 0)
                .map((WeaponModel? m) => DropdownMenuEntry(value: m!, label: m.name))
                .toList(),
              onSelected: (WeaponModel? m) {
                if(m == null) return;
                setState(() {
                  currentModel = m;
                });
              },
              autovalidateMode: AutovalidateMode.onUserInteractionIfError,
              validator: (WeaponModel? m) {
                if(m == null) return 'Valeur manquante';
                return null;
              },
            ),
          ),
        IconButton(
          onPressed: currentModel == null ? null : () {
            var e = EquipmentFactory.instance.forgeEquipment(currentModel!.id);
            widget.onChanged(e);
          },
          icon: const Icon(Icons.check_circle_outline),
          iconSize: 18.0,
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

class _StarterEquipmentArmorWidget extends StatefulWidget {
  const _StarterEquipmentArmorWidget({
    required this.starter,
    this.instance,
    required this.onChanged,
  });

  final _StarterEquipmentArmor starter;
  final Equipment? instance;
  final void Function(Equipment?) onChanged;

  @override
  State<_StarterEquipmentArmorWidget> createState() => _StarterEquipmentArmorWidgetState();
}

class _StarterEquipmentArmorWidgetState extends State<_StarterEquipmentArmorWidget> {
  ArmorType? currentType;
  ArmorModel? currentModel;

  @override
  void initState() {
    super.initState();

    if(widget.starter.armorTypes.length == 1) {
      currentType = widget.starter.armorTypes[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if(widget.instance != null && widget.instance is Armor) {
      var m = widget.instance!.model as ArmorModel;
      return Row(
        spacing: 12.0,
        children: [
          Text(
            '\u2022 ${m.type.title} : ${m.name}',
          ),
          IconButton(
            onPressed: () {
              setState(() {
                currentModel = null;
                currentType = null;
              });
              widget.onChanged(null);
            },
            icon: const Icon(Icons.cancel_outlined),
            iconSize: 18.0,
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(),
          ),
        ],
      );
    }

    return Row(
      spacing: 12.0,
      children: [
        Text(
          'Armure',
          style: theme.textTheme.bodyMedium!
            .copyWith(fontWeight: FontWeight.bold),
        ),
        if(widget.starter.armorTypes.length > 1)
          SizedBox(
            width: 250,
            child: DropdownMenuFormField<ArmorType>(
              initialSelection: currentType,
              requestFocusOnTap: true,
              expandedInsets: EdgeInsets.zero,
              label: const Text('Type'),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                isCollapsed: true,
                constraints: BoxConstraints(maxHeight: 36.0),
                contentPadding: EdgeInsets.all(12.0),
              ),
              dropdownMenuEntries: widget.starter.armorTypes
                .map((ArmorType t) => DropdownMenuEntry(value: t, label: t.title))
                .toList(),
              onSelected: (ArmorType? v) {
                if(v == null) return;
                setState(() {
                  currentType = v;
                });
              },
              autovalidateMode: AutovalidateMode.onUserInteractionIfError,
              validator: (ArmorType? v) {
                if(v == null) return 'Valeur manquante';
                return null;
              },
            ),
          ),
        if(currentType != null)
          SizedBox(
            width: 250,
            child: DropdownMenuFormField<ArmorModel>(
              initialSelection: currentModel,
              requestFocusOnTap: true,
              expandedInsets: EdgeInsets.zero,
              label: const Text('Armure'),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
                isCollapsed: true,
                constraints: BoxConstraints(maxHeight: 36.0),
                contentPadding: EdgeInsets.all(12.0),
              ),
              dropdownMenuEntries: ArmorModel.idsByType(currentType!)
                .map((String id) => ArmorModel.get(id))
                .where((ArmorModel? m) => !(m?.unique ?? true))
                .map((ArmorModel? m) => DropdownMenuEntry(value: m!, label: m.name))
                .toList(),
              onSelected: (ArmorModel? m) {
                if(m == null) return;
                setState(() {
                  currentModel = m;
                });
              },
              autovalidateMode: AutovalidateMode.onUserInteractionIfError,
              validator: (ArmorModel? m) {
                if(m == null) return 'Valeur manquante';
                return null;
              },
            ),
          ),
        IconButton(
          onPressed: currentModel == null ? null : () {
            var e = EquipmentFactory.instance.forgeEquipment(currentModel!.id);
            widget.onChanged(e);
          },
          icon: const Icon(Icons.check_circle_outline),
          iconSize: 18.0,
          padding: const EdgeInsets.all(4.0),
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

class _StarterEquipment {
  const _StarterEquipment({
    this.alias,
    this.quantity = 1,
  });

  final String? alias;
  final int quantity;
}

class _StarterEquipmentByID extends _StarterEquipment {
  const _StarterEquipmentByID({
    super.alias,
    super.quantity,
    required this.id,
  });

  final String id;

  Equipment toEquipment() {
    var e = EquipmentFactory.instance.forgeEquipment(id)!;
    e.alias = alias;
    return e;
  }
}

class _StarterEquipmentWeapon extends _StarterEquipment {
  const _StarterEquipmentWeapon({
    required this.scarcity,
    required this.skills,
  });

  final EquipmentScarcity scarcity;
  final List<Skill> skills;
}

class _StarterEquipmentArmor extends _StarterEquipment {
  const _StarterEquipmentArmor({
    required this.scarcity,
    required this.armorTypes,
  });

  final EquipmentScarcity scarcity;
  final List<ArmorType> armorTypes;
}

const _starterEquipment = <Caste, List<_StarterEquipment>> {
  Caste.artisan: [
    _StarterEquipmentWeapon(
      scarcity: EquipmentScarcity.peuCommun,
      skills: [
        Skill.armesArticulees,
        Skill.armesContondantes,
        Skill.armesDeChoc,
        Skill.armesDoubles,
        Skill.armesTranchantes,
        Skill.armesDeJet,
        Skill.corpsACorps,
      ]
    ),
    _StarterEquipmentArmor(
      scarcity: EquipmentScarcity.peuCommun,
      armorTypes: [
        ArmorType.light,
        ArmorType.medium,
      ]
    ),
    _StarterEquipmentByID(
      // Sac de voyage
      id: 'misc-gear:14d42bdc-403b-4a02-9e65-bf9f4b6750a2',
    ),
    _StarterEquipmentByID(
      alias: "Carnet de croquis",
      id: 'misc-gear:849d426a-9abb-4683-9036-65b5e4c4532e',
    ),
    _StarterEquipmentByID(
      // Briquet à amadou
      id: 'misc-gear:1de0f7bf-11ef-4ee6-a61d-0e83a975a2f1',
    ),
    _StarterEquipmentByID(
      // Corde
      id: 'misc-gear:f55eadde-e5b7-423d-be6d-b2cba5dbf9d1',
      quantity: 3,
    ),
    _StarterEquipmentByID(
      // Couchage
      id: 'misc-gear:a124f36b-cab3-457f-8f79-411c2ead9533',
    ),
    _StarterEquipmentByID(
      // Fiole d'huile
      id: 'misc-gear:d6f12518-f669-473b-95ff-bcf8988885d8',
      quantity: 2,
    ),
    _StarterEquipmentByID(
      // Gamelle
      id: 'misc-gear:1509883a-672e-43e6-944c-1ce8a1a32f9d',
    ),
    _StarterEquipmentByID(
      // Lampe à huile
      id: 'misc-gear:2369f61c-7ff3-4930-b611-af70abe3f3ed',
    ),
    _StarterEquipmentByID(
      // Pierre à aiguiser
      id: 'misc-gear:46d4566e-53bc-434c-bd10-38512e27a176',
    ),
    _StarterEquipmentByID(
      // Poncho de cuir
      id: 'cloth:9180c8fd-cb81-4d0f-a016-20601353ca9d',
    ),
    _StarterEquipmentByID(
      // Toile huilée
      id: 'misc-gear:a976d1e2-6533-451d-97f5-57f0ed79b4b7',
    ),
    _StarterEquipmentByID(
      // Torche
      id: 'misc-gear:8132df76-1c87-400e-a9e9-b66c56c6c58b',
      quantity: 4,
    ),
    _StarterEquipmentByID(
      // Musette
      id: 'misc-gear:14571d3c-a950-46b9-a5f5-14ab88fb5b12',
    ),
    _StarterEquipmentByID(
      alias: "Outils de travail",
      id: 'misc-gear:e25dd96f-3eff-4c1d-b3c0-aab68e1857c5',
    ),
    _StarterEquipmentByID(
      alias: "Vêtements de travail",
      id: 'cloth:af828561-f86d-4f7a-8c31-8a58505338fb',
    ),
    _StarterEquipmentByID(
      // Tenue de rechange
      id: 'cloth:af828561-f86d-4f7a-8c31-8a58505338fb',
    ),
    _StarterEquipmentByID(
      alias: "Bonne paire de chausses",
      id: 'cloth:b4b92c47-53b8-490a-aeb8-418dc55976b1',
    ),
  ],
  Caste.combattant: [
    _StarterEquipmentWeapon(
      scarcity: EquipmentScarcity.introuvable,
      skills: [
        Skill.corpsACorps,
      ]
    ),
    _StarterEquipmentWeapon(
      scarcity: EquipmentScarcity.peuCommun,
      skills: [
        Skill.armesArticulees,
        Skill.armesContondantes,
        Skill.armesDeChoc,
        Skill.armesDeJet,
        Skill.armesDoubles,
        Skill.armesTranchantes,
      ]
    ),
    _StarterEquipmentWeapon(
      scarcity: EquipmentScarcity.peuCommun,
      skills: [
        Skill.armesArticulees,
        Skill.armesContondantes,
        Skill.armesDeChoc,
        Skill.armesDeJet,
        Skill.armesDoubles,
        Skill.armesTranchantes,
      ]
    ),
    _StarterEquipmentArmor(
      scarcity: EquipmentScarcity.peuCommun,
      armorTypes: [
        ArmorType.light,
        ArmorType.medium,
      ]
    ),
    _StarterEquipmentByID(
      // Sac de campagne
      id: 'misc-gear:68894892-5ced-4765-9113-e8fa8d1c930f',
    ),
    _StarterEquipmentByID(
      // Briquet à amadou
      id: 'misc-gear:1de0f7bf-11ef-4ee6-a61d-0e83a975a2f1',
    ),
    _StarterEquipmentByID(
      // Corde
      id: 'misc-gear:f55eadde-e5b7-423d-be6d-b2cba5dbf9d1',
      quantity: 3,
    ),
    _StarterEquipmentByID(
      // Couchage
      id: 'misc-gear:a124f36b-cab3-457f-8f79-411c2ead9533',
    ),
    _StarterEquipmentByID(
      // Fiole d'huile
      id: 'misc-gear:d6f12518-f669-473b-95ff-bcf8988885d8',
    ),
    _StarterEquipmentByID(
      // Gamelle
      id: 'misc-gear:1509883a-672e-43e6-944c-1ce8a1a32f9d',
    ),
    _StarterEquipmentByID(
      // Lampe à huile
      id: 'misc-gear:2369f61c-7ff3-4930-b611-af70abe3f3ed',
    ),
    _StarterEquipmentByID(
      // Pierre à aiguiser
      id: 'misc-gear:46d4566e-53bc-434c-bd10-38512e27a176',
    ),
    _StarterEquipmentByID(
      // Poncho de cuir
      id: 'cloth:9180c8fd-cb81-4d0f-a016-20601353ca9d',
    ),
    _StarterEquipmentByID(
      // Toile huilée
      id: 'misc-gear:a976d1e2-6533-451d-97f5-57f0ed79b4b7',
    ),
    _StarterEquipmentByID(
      // Torche
      id: 'misc-gear:8132df76-1c87-400e-a9e9-b66c56c6c58b',
      quantity: 4,
    ),
    _StarterEquipmentByID(
      // Vêtements de voyage
      id: 'cloth:f403c6ac-887a-4346-9152-44a53eb152c6',
    ),
    _StarterEquipmentByID(
      alias: "Bonne paire de brodequins",
      id: 'cloth:b4b92c47-53b8-490a-aeb8-418dc55976b1',
    ),
  ],
  Caste.commercant: [
    _StarterEquipmentWeapon(
      scarcity: EquipmentScarcity.peuCommun,
      skills: [
        Skill.armesArticulees,
        Skill.armesContondantes,
        Skill.armesDeChoc,
        Skill.armesDeJet,
        Skill.armesDoubles,
        Skill.armesTranchantes,
        Skill.corpsACorps,
      ]
    ),
    _StarterEquipmentArmor(
      scarcity: EquipmentScarcity.peuCommun,
      armorTypes: [
        ArmorType.light,
        ArmorType.medium,
      ]
    ),
    _StarterEquipmentByID(
      // Sac de voyage
      id: 'misc-gear:14d42bdc-403b-4a02-9e65-bf9f4b6750a2',
    ),
    _StarterEquipmentByID(
      alias: "Accessoires en rapport avec mon domaine commercial",
      id: 'misc-gear:e25dd96f-3eff-4c1d-b3c0-aab68e1857c5',
    ),
    _StarterEquipmentByID(
      alias: "Babioles facilement négociables (3D10 db)",
      id: 'misc-gear:e25dd96f-3eff-4c1d-b3c0-aab68e1857c5',
    ),
    _StarterEquipmentByID(
      // Briquet à amadou
      id: 'misc-gear:1de0f7bf-11ef-4ee6-a61d-0e83a975a2f1',
    ),
    _StarterEquipmentByID(
      alias: "Livre de comptes",
      id: 'misc-gear:e410469f-f1b6-478e-834f-65cfde430844',
    ),
    _StarterEquipmentByID(
      // Vêtements de voyage
      id: 'cloth:ac2ec1b8-7c76-4335-94ce-9c9443691804',
    ),
    _StarterEquipmentByID(
      alias: "Vêtements d'apparat",
      id: 'cloth:af828561-f86d-4f7a-8c31-8a58505338fb',
    ),
    _StarterEquipmentByID(
      alias: "Bonnes bottes",
      id: 'cloth:b4b92c47-53b8-490a-aeb8-418dc55976b1',
    ),
    _StarterEquipmentByID(
      // Ceinture à poches
      id: 'cloth:1ff5ea2b-5a22-43c8-9513-a062fe1bef6d',
    ),
  ],
  Caste.erudit: [
    _StarterEquipmentWeapon(
      scarcity: EquipmentScarcity.peuCommun,
      skills: [
        Skill.corpsACorps,
      ]
    ),
    _StarterEquipmentByID(
      // Sac de voyage
      id: 'misc-gear:14d42bdc-403b-4a02-9e65-bf9f4b6750a2',
    ),
    _StarterEquipmentByID(
      // Briquet à amadou
      id: 'misc-gear:1de0f7bf-11ef-4ee6-a61d-0e83a975a2f1',
    ),
    _StarterEquipmentByID(
      // Encrier
      id: 'misc-gear:1a7f0453-ca8e-41d7-9650-598271a64b1e',
    ),
    _StarterEquipmentByID(
      alias: "Instruments et objets nécessaires à mes travaux",
      id: 'misc-gear:e25dd96f-3eff-4c1d-b3c0-aab68e1857c5',
    ),
    _StarterEquipmentByID(
      // Livre de papier vierge
      id: 'misc-gear:e410469f-f1b6-478e-834f-65cfde430844',
    ),
    _StarterEquipmentByID(
      // Papyrus
      id: 'misc-gear:dafb70b2-b0c4-4210-b941-7a3db04275c4',
      quantity: 3,
    ),
    _StarterEquipmentByID(
      // Plume
      id: 'misc-gear:dd837a84-acd8-4ce7-95bb-32f945f218b6',
      quantity: 3,
    ),
    _StarterEquipmentByID(
      // Pierre à aiguiser
      id: 'misc-gear:46d4566e-53bc-434c-bd10-38512e27a176',
    ),
    _StarterEquipmentByID(
      // Poncho de cuir
      id: 'cloth:9180c8fd-cb81-4d0f-a016-20601353ca9d',
    ),
    _StarterEquipmentByID(
      // Vêtements de voyage
      id: 'cloth:ac2ec1b8-7c76-4335-94ce-9c9443691804',
    ),
    _StarterEquipmentByID(
      alias: "Bonne paire de chausses",
      id: 'cloth:b4b92c47-53b8-490a-aeb8-418dc55976b1',
    ),
  ],
  Caste.mage: [
    _StarterEquipmentWeapon(
      scarcity: EquipmentScarcity.introuvable,
      skills: [
        Skill.corpsACorps,
      ]
    ),
    _StarterEquipmentWeapon(
      scarcity: EquipmentScarcity.peuCommun,
      skills: [
        Skill.armesArticulees,
        Skill.armesContondantes,
        Skill.armesDeChoc,
        Skill.armesDeJet,
        Skill.armesDoubles,
        Skill.armesTranchantes,
      ]
    ),
    _StarterEquipmentArmor(
      scarcity: EquipmentScarcity.peuCommun,
      armorTypes: [
        ArmorType.light,
      ]
    ),
    _StarterEquipmentByID(
      // Sac de voyage
      id: 'misc-gear:14d42bdc-403b-4a02-9e65-bf9f4b6750a2',
    ),
    _StarterEquipmentByID(
      alias: "Accessoires pour pratiquer un art que je maîtrise",
      id: 'misc-gear:e25dd96f-3eff-4c1d-b3c0-aab68e1857c5',
    ),
    _StarterEquipmentByID(
      alias: "Bloc de craie",
      id: 'misc-gear:dd837a84-acd8-4ce7-95bb-32f945f218b6',
      quantity: 3,
    ),
    _StarterEquipmentByID(
      alias: "Clé destructible pour lancer un des sorts de base",
      id: 'misc-gear:9055f731-43a1-434d-a4aa-e1b1e72d8d1f',
      quantity: 3,
    ),
    _StarterEquipmentByID(
      alias: "Clé permanente",
      id: 'misc-gear:9055f731-43a1-434d-a4aa-e1b1e72d8d1f',
    ),
    _StarterEquipmentByID(
      // Fiole d'encre
      id: 'misc-gear:878b1aea-de94-484a-ad45-c1ffea9e7596',
    ),
    _StarterEquipmentByID(
      // Pinceaux
      id: 'misc-gear:9e534ed9-7e72-421a-a7a1-549c4561b78b',
    ),
    _StarterEquipmentByID(
      // Vêtements de voyage
      id: 'cloth:ac2ec1b8-7c76-4335-94ce-9c9443691804',
    ),
    _StarterEquipmentByID(
      // Sandales
      id: 'cloth:0612c2f2-4ac1-42ef-b300-d4274439662c',
    ),
  ],
  Caste.prodige: [
    _StarterEquipmentByID(
      // M'jarh
      id: 'cloth:73be4953-5463-4bad-9771-710976e6d7e1',
    ),
    _StarterEquipmentByID(
      // Shaaduk't
      id: 'weapon:e6fd17f2-bb8d-4559-8525-d9c15536325f',
    ),
    _StarterEquipmentByID(
      // Sac de voyage
      id: 'misc-gear:14d42bdc-403b-4a02-9e65-bf9f4b6750a2',
    ),
    _StarterEquipmentByID(
      // Gamelle
      id: 'misc-gear:1509883a-672e-43e6-944c-1ce8a1a32f9d',
    ),
    _StarterEquipmentByID(
      alias: "Accessoires pour pratiquer mon art (pochette à herbes, matériel de scribe, nécessaire de soins, etc.)",
      id: 'misc-gear:e25dd96f-3eff-4c1d-b3c0-aab68e1857c5',
    ),
  ],
  Caste.protecteur: [
    _StarterEquipmentWeapon(
      scarcity: EquipmentScarcity.peuCommun,
      skills: [
        Skill.armesArticulees,
        Skill.armesContondantes,
        Skill.armesDeChoc,
        Skill.armesDeJet,
        Skill.armesDoubles,
        Skill.armesTranchantes,
      ]
    ),
    _StarterEquipmentArmor(
      scarcity: EquipmentScarcity.peuCommun,
      armorTypes: [
        ArmorType.light,
        ArmorType.medium,
        ArmorType.heavy,
      ]
    ),
    _StarterEquipmentByID(
      // Bouclier-dragon
      id: 'shield:ca8ceb16-4d83-44ee-9eec-11fe90140a6e',
    ),
    _StarterEquipmentByID(
      // Sac de campagne
      id: 'misc-gear:68894892-5ced-4765-9113-e8fa8d1c930f',
    ),
    _StarterEquipmentByID(
      // Briquet à amadou
      id: 'misc-gear:1de0f7bf-11ef-4ee6-a61d-0e83a975a2f1',
    ),
    _StarterEquipmentByID(
      // Corde
      id: 'misc-gear:f55eadde-e5b7-423d-be6d-b2cba5dbf9d1',
      quantity: 3,
    ),
    _StarterEquipmentByID(
      // Couchage
      id: 'misc-gear:a124f36b-cab3-457f-8f79-411c2ead9533',
    ),
    _StarterEquipmentByID(
      // Fiole d'huile
      id: 'misc-gear:d6f12518-f669-473b-95ff-bcf8988885d8',
    ),
    _StarterEquipmentByID(
      // Gamelle
      id: 'misc-gear:1509883a-672e-43e6-944c-1ce8a1a32f9d',
    ),
    _StarterEquipmentByID(
      // Lampe à huile
      id: 'misc-gear:2369f61c-7ff3-4930-b611-af70abe3f3ed',
    ),
    _StarterEquipmentByID(
      // Pierre à aiguiser
      id: 'misc-gear:46d4566e-53bc-434c-bd10-38512e27a176',
    ),
    _StarterEquipmentByID(
      // Poncho de cuir
      id: 'cloth:9180c8fd-cb81-4d0f-a016-20601353ca9d',
    ),
    _StarterEquipmentByID(
      // Toile huilée
      id: 'misc-gear:a976d1e2-6533-451d-97f5-57f0ed79b4b7',
    ),
    _StarterEquipmentByID(
      // Torche
      id: 'misc-gear:8132df76-1c87-400e-a9e9-b66c56c6c58b',
      quantity: 2,
    ),
    _StarterEquipmentByID(
      // Vêtements de voyage
      id: 'cloth:f403c6ac-887a-4346-9152-44a53eb152c6',
    ),
    _StarterEquipmentByID(
      alias: "Tabard portant un blason",
      id: 'cloth:1be987e8-6807-410e-b221-19e742fc0c1c',
    ),
    _StarterEquipmentByID(
      alias: "Bonne paire de brodequins",
      id: 'cloth:b4b92c47-53b8-490a-aeb8-418dc55976b1',
    ),
  ],
  Caste.voyageur: [
    _StarterEquipmentWeapon(
      scarcity: EquipmentScarcity.introuvable,
      skills: [
        Skill.corpsACorps,
      ]
    ),
    _StarterEquipmentWeapon(
      scarcity: EquipmentScarcity.rare,
      skills: [
        Skill.armesDeJet,
        Skill.armesAProjectiles,
      ]
    ),
    _StarterEquipmentArmor(
      scarcity: EquipmentScarcity.peuCommun,
      armorTypes: [
        ArmorType.light,
        ArmorType.medium,
      ]
    ),
    _StarterEquipmentByID(
      // Sac de voyage
      id: 'misc-gear:14d42bdc-403b-4a02-9e65-bf9f4b6750a2',
    ),
    _StarterEquipmentByID(
      alias: "Carnet de voyage",
      id: 'misc-gear:849d426a-9abb-4683-9036-65b5e4c4532e',
    ),
    _StarterEquipmentByID(
      // Briquet à amadou
      id: 'misc-gear:1de0f7bf-11ef-4ee6-a61d-0e83a975a2f1',
    ),
    _StarterEquipmentByID(
      // Corde
      id: 'misc-gear:f55eadde-e5b7-423d-be6d-b2cba5dbf9d1',
      quantity: 3,
    ),
    _StarterEquipmentByID(
      // Couchage
      id: 'misc-gear:a124f36b-cab3-457f-8f79-411c2ead9533',
    ),
    _StarterEquipmentByID(
      // Fiole d'huile
      id: 'misc-gear:d6f12518-f669-473b-95ff-bcf8988885d8',
      quantity: 2,
    ),
    _StarterEquipmentByID(
      // Gamelle
      id: 'misc-gear:1509883a-672e-43e6-944c-1ce8a1a32f9d',
    ),
    _StarterEquipmentByID(
      // Grappin
      id: 'misc-gear:4466e883-654a-425e-8688-dab029b0bff6',
    ),
    _StarterEquipmentByID(
      // Lampe à huile
      id: 'misc-gear:2369f61c-7ff3-4930-b611-af70abe3f3ed',
    ),
    _StarterEquipmentByID(
      // Pierre à aiguiser
      id: 'misc-gear:46d4566e-53bc-434c-bd10-38512e27a176',
    ),
    _StarterEquipmentByID(
      // Piton
      id: 'misc-gear:40daea0f-59f6-4bb1-bbe5-706c91628b74',
    ),
    _StarterEquipmentByID(
      // Poncho de cuir
      id: 'cloth:9180c8fd-cb81-4d0f-a016-20601353ca9d',
    ),
    _StarterEquipmentByID(
      // Sifflet
      id: 'misc-gear:03e74cec-17b1-410a-8a69-a4a787426d72',
    ),
    _StarterEquipmentByID(
      // Toile huilée
      id: 'misc-gear:a976d1e2-6533-451d-97f5-57f0ed79b4b7',
    ),
    _StarterEquipmentByID(
      // Torche
      id: 'misc-gear:8132df76-1c87-400e-a9e9-b66c56c6c58b',
      quantity: 4,
    ),
    _StarterEquipmentByID(
      // Musette
      id: 'misc-gear:14571d3c-a950-46b9-a5f5-14ab88fb5b12',
    ),
    _StarterEquipmentByID(
      alias: "Outils de travail",
      id: 'misc-gear:e25dd96f-3eff-4c1d-b3c0-aab68e1857c5',
    ),
    _StarterEquipmentByID(
      // Tenue de rechange
      id: 'cloth:af828561-f86d-4f7a-8c31-8a58505338fb',
    ),
    _StarterEquipmentByID(
      // Vêtements de voyage
      id: 'cloth:ac2ec1b8-7c76-4335-94ce-9c9443691804',
    ),
    _StarterEquipmentByID(
      alias: "Bonnes bottes",
      id: 'cloth:b4b92c47-53b8-490a-aeb8-418dc55976b1',
    ),
  ],
};

const _starterMoney = <Caste, int>{
  Caste.artisan: 8,
  Caste.combattant: 6,
  Caste.commercant: 10,
  Caste.erudit: 10,
  Caste.mage: 5,
  Caste.prodige: 0,
  Caste.protecteur: 3,
  Caste.voyageur: 4,
};