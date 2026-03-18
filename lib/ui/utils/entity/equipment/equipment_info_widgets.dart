import 'package:flutter/material.dart';

import '../../../../classes/equipment/armor.dart';
import '../../../../classes/equipment/cloth.dart';
import '../../../../classes/equipment/jewel.dart';
import '../../../../classes/equipment/misc_gear.dart';
import '../../../../classes/equipment/shield.dart';
import '../../../../classes/equipment/weapon.dart';
import '../../dismissible_dialog.dart';

class WeaponInfoWidget extends StatelessWidget {
  const WeaponInfoWidget({ super.key, required this.weapon });

  final Weapon weapon;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    String damage;
    if((weapon.model as WeaponModel).damage.static != null && (weapon.model as WeaponModel).damage.static! > 0) {
      damage = (weapon.model as WeaponModel).damage.static.toString();
    }
    else {
      var ability = (weapon.model as WeaponModel).damage.ability!.short;
      var buffer = StringBuffer((weapon.model as WeaponModel).damage.multiply > 1
          ? '($ability x ${(weapon.model as WeaponModel).damage.multiply})'
          : ability);
      if((weapon.model as WeaponModel).damage.add > 0) {
        buffer.write(' + ${(weapon.model as WeaponModel).damage.add}');
      }
      if((weapon.model as WeaponModel).damage.dice > 0) {
        buffer.write(' + ${(weapon.model as WeaponModel).damage.dice}D10');
      }
      damage = buffer.toString();
    }

    var infoLine = 'Qualité : ${weapon.quality.title}';
    if(weapon.model.supportsMetal) {
      infoLine += ' / Métal : ${weapon.metal.title}';
    }
    infoLine += ' / Poids : ${weapon.weight.toStringAsFixed(2)} kg';

    var typeLine = 'Compétence : ${(weapon.model as WeaponModel).skill.parent.title}';
    if(weapon.alias != null) {
      typeLine += ' / Spécialisation : ${weapon.model.name}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '\u{2694} ${weapon.name}',
              ),
              if(weapon.model.unique)
                TextSpan(
                  children: [
                    TextSpan(text: ' '),
                    WidgetSpan(
                      child: Tooltip(
                        message: 'Unique',
                        child: Icon(
                          Icons.looks_one_outlined,
                          size: 18,
                        ),
                      ),
                    ),
                  ]
                ),
              if(weapon.description.isNotEmpty)
                TextSpan(
                  children: [
                    TextSpan(text: ' '),
                    WidgetSpan(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              DismissibleDialog<void>(
                                title: weapon.name,
                                content: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 400,
                                    maxWidth: 400,
                                    maxHeight: 400,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      weapon.description,
                                    ),
                                  )
                                )
                              )
                            );
                          },
                          child: Icon(
                            Icons.info_outline,
                            size: 18,
                          ),
                        ),
                      )
                    ),
                  ]
                ),
            ]
          ),
          style: theme.textTheme.titleMedium,
        ),
        Text(
          'Dégats $damage',
          style: theme.textTheme.bodySmall,
        ),
        Text(
          infoLine,
          style: theme.textTheme.bodySmall,
        ),
        Text(
          typeLine,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class ShieldInfoWidget extends StatelessWidget {
  const ShieldInfoWidget({ super.key, required this.shield });
  
  final Shield shield;
  
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var infoLine = 'Qualité : ${shield.quality.title}';
    if(shield.model.supportsMetal) {
      infoLine += ' / Métal : ${shield.metal.title}';
    }
    infoLine += ' / Poids : ${shield.weight.toStringAsFixed(2)} kg';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '\u{1F6E1} ${shield.name}'),
              if(shield.model.unique)
                TextSpan(
                  children: [
                    TextSpan(text: ' '),
                    WidgetSpan(
                      child: Tooltip(
                        message: 'Unique',
                        child: Icon(
                          Icons.looks_one_outlined,
                          size: 18,
                        ),
                      ),
                    ),
                  ]
                ),
              if(shield.description.isNotEmpty)
                TextSpan(
                  children: [
                    TextSpan(text: ' '),
                    WidgetSpan(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              DismissibleDialog<void>(
                                title: shield.name,
                                content: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 400,
                                    maxWidth: 400,
                                    maxHeight: 400,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      shield.description,
                                    ),
                                  )
                                )
                              )
                            );
                          },
                          child: Icon(
                            Icons.info_outline,
                            size: 18,
                          ),
                        ),
                      )
                    ),
                  ]
                ),
            ],
          ),
          style: theme.textTheme.titleMedium,
        ),
        Text(
          'Protection : ${shield.protection()} / Pénalité : ${(shield.model as ShieldModel).penalty}',
          style: theme.textTheme.bodyMedium,
        ),
        Text(
          infoLine,
          style: theme.textTheme.bodySmall,
        ),
        if(shield.alias != null)
          Text(
            shield.model.name,
            style: theme.textTheme.bodySmall,
          ),
      ],
    );
  }
}

class ArmorInfoWidget extends StatelessWidget {
  const ArmorInfoWidget({ super.key, required this.armor });

  final Armor armor;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var infoLine = 'Qualité : ${armor.quality.title}';
    if(armor.model.supportsMetal) {
      infoLine += ' / Métal : ${armor.metal.title}';
    }
    infoLine += ' / Poids : ${armor.weight.toStringAsFixed(2)} kg';

    var typeLine = 'Type : ${(armor.model as ArmorModel).type.title}';
    if(armor.alias != null) {
      typeLine += ' / ${armor.model.name}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '\u{1FA96} ${armor.name}'),
              if(armor.model.unique)
                TextSpan(
                  children: [
                    TextSpan(text: ' '),
                    WidgetSpan(
                      child: Tooltip(
                        message: 'Unique',
                        child: Icon(
                          Icons.looks_one_outlined,
                          size: 18,
                        ),
                      ),
                    ),
                  ]
                ),
              if(armor.description.isNotEmpty)
                TextSpan(
                  children: [
                    TextSpan(text: ' '),
                    WidgetSpan(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              DismissibleDialog<void>(
                                title: armor.name,
                                content: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 400,
                                    maxWidth: 400,
                                    maxHeight: 400,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      armor.description,
                                    ),
                                  )
                                )
                              )
                            );
                          },
                          child: Icon(
                            Icons.info_outline,
                            size: 18,
                          ),
                        ),
                      )
                    ),
                  ]
                ),
            ],
            style: theme.textTheme.titleMedium,
          ),
        ),
        Text(
          'Protection : ${armor.protection()} / Pénalite : ${(armor.model as ArmorModel).penalty}',
          style: theme.textTheme.bodyMedium,
        ),
        Text(
          infoLine,
          style: theme.textTheme.bodySmall,
        ),
        Text(
          typeLine,
          style: theme.textTheme.bodySmall,
        )
      ],
    );
  }
}

class ClothInfoWidget extends StatelessWidget {
  const ClothInfoWidget({ super.key, required this.cloth });

  final Cloth cloth;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var infoLine = 'Qualité : ${cloth.quality.title}';
    if(cloth.model.supportsMetal) {
      infoLine += ' / Métal : ${cloth.metal.title}';
    }
    infoLine += ' / Poids : ${cloth.weight.toStringAsFixed(2)} kg';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: cloth.name),
              if(cloth.model.unique)
                TextSpan(
                    children: [
                      TextSpan(text: ' '),
                      WidgetSpan(
                        child: Tooltip(
                          message: 'Unique',
                          child: Icon(
                            Icons.looks_one_outlined,
                            size: 18,
                          ),
                        ),
                      ),
                    ]
                ),
              if(cloth.description.isNotEmpty)
                TextSpan(
                  children: [
                    TextSpan(text: ' '),
                    WidgetSpan(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              DismissibleDialog<void>(
                                title: cloth.name,
                                content: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 400,
                                    maxWidth: 400,
                                    maxHeight: 400,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      cloth.description,
                                    ),
                                  )
                                )
                              )
                            );
                          },
                          child: Icon(
                            Icons.info_outline,
                            size: 18,
                          ),
                        ),
                      )
                    ),
                  ]
              ),
            ],
          ),
        ),
        Text(
          infoLine,
          style: theme.textTheme.bodySmall,
        ),
        if(cloth.alias != null)
          Text(
            cloth.model.name,
            style: theme.textTheme.bodySmall,
          ),
      ],
    );
  }
}

class JewelInfoWidget extends StatelessWidget {
  const JewelInfoWidget({ super.key, required this.jewel });

  final Jewel jewel;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var infoLine = 'Qualité : ${jewel.quality.title}';
    if(jewel.model.supportsMetal) {
      infoLine += ' / Métal : ${jewel.metal.title}';
    }
    infoLine += ' / Poids : ${jewel.weight.toStringAsFixed(2)} kg';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: jewel.name),
              if(jewel.model.unique)
                TextSpan(
                    children: [
                      TextSpan(text: ' '),
                      WidgetSpan(
                        child: Tooltip(
                          message: 'Unique',
                          child: Icon(
                            Icons.looks_one_outlined,
                            size: 18,
                          ),
                        ),
                      ),
                    ]
                ),
              if(jewel.description.isNotEmpty)
                TextSpan(
                  children: [
                    TextSpan(text: ' '),
                    WidgetSpan(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              DismissibleDialog<void>(
                                title: jewel.name,
                                content: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 400,
                                    maxWidth: 400,
                                    maxHeight: 400,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      jewel.description,
                                    ),
                                  )
                                )
                              )
                            );
                          },
                          child: Icon(
                            Icons.info_outline,
                            size: 18,
                          ),
                        ),
                      )
                    ),
                  ]
                ),
            ],
          ),
          style: theme.textTheme.titleMedium,
        ),
        Text(
          infoLine,
          style: theme.textTheme.bodySmall,
        ),
        if(jewel.alias != null)
          Text(
            jewel.model.name,
            style: theme.textTheme.bodySmall,
          ),
      ],
    );
  }
}

class MiscGearInfoWidget extends StatelessWidget {
  const MiscGearInfoWidget({ super.key, required this.item });

  final MiscGear item;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var infoLine = 'Qualité : ${item.quality.title}';
    if(item.model.supportsMetal) {
      infoLine += ' / Métal : ${item.metal.title}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: item.name),
              if(item.model.unique)
                TextSpan(
                    children: [
                      TextSpan(text: ' '),
                      WidgetSpan(
                        child: Tooltip(
                          message: 'Unique',
                          child: Icon(
                            Icons.looks_one_outlined,
                            size: 18,
                          ),
                        ),
                      ),
                    ]
                ),
              if(item.description.isNotEmpty)
                TextSpan(
                  children: [
                    TextSpan(text: ' '),
                    WidgetSpan(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              DismissibleDialog<void>(
                                title: item.name,
                                content: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 400,
                                    maxWidth: 400,
                                    maxHeight: 400,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      item.description,
                                    ),
                                  )
                                )
                              )
                            );
                          },
                          child: Icon(
                            Icons.info_outline,
                            size: 18,
                          ),
                        ),
                      )
                    ),
                  ]
                ),
            ],
          ),
          style: theme.textTheme.titleMedium,
        ),
        Text(
          infoLine,
          style: theme.textTheme.bodySmall,
        ),
        if(item.alias != null)
          Text(
            item.model.name,
            style: theme.textTheme.bodySmall,
          ),
      ],
    );
  }
}