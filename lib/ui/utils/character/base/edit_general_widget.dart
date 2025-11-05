import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../classes/calendar.dart';
import '../../../../classes/human_character.dart';
import '../../../../classes/non_player_character.dart';
import '../../../../classes/object_location.dart';
import '../../../../classes/place.dart';
import '../../../../classes/player_character.dart';
import '../../widget_group_container.dart';

class CharacterEditGeneralWidget extends StatelessWidget {
  const CharacterEditGeneralWidget({
    super.key,
    required this.character,
  });

  final HumanCharacter character;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Général',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 12.0,
        children: [
          if(character is PlayerCharacter)
            Row(
              spacing: 12.0,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: (character as PlayerCharacter).player,
                    decoration: const InputDecoration(
                      label: Text('Joueur'),
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    style: theme.textTheme.bodySmall,
                    validator: (String? value) {
                      if(value == null || value.isEmpty) {
                        return 'Valeur manquante';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (String value) => (character as PlayerCharacter).player = value,
                  ),
                ),
                Expanded(
                  child: DropdownMenuFormField<Augure>(
                    enabled: false,
                    initialSelection: (character as PlayerCharacter).augure,
                    requestFocusOnTap: true,
                    label: const Text('Augure'),
                    expandedInsets: EdgeInsets.zero,
                    textStyle: theme.textTheme.bodySmall,
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(),
                      isCollapsed: true,
                      constraints: BoxConstraints(maxHeight: 36.0),
                      contentPadding: EdgeInsets.all(12.0),
                    ),
                    dropdownMenuEntries: Augure.values
                      .map(
                        (Augure augure) => DropdownMenuEntry<Augure>(
                          value: augure,
                          label: augure.title
                        )
                      )
                      .toList(),
                    validator: (Augure? augure) {
                      if(augure == null) {
                        return 'Valeur manquante';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSelected: (Augure? augure) {
                      if(augure == null) return;
                      // If at some point I decide that the augure can be changed
                      //(widget.character as PlayerCharacter).augure = augure;
                    },
                  ),
                ),
              ],
            ),
          Row(
            spacing: 12.0,
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: character.name,
                  decoration: const InputDecoration(
                    label: Text('Nom'),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  style: theme.textTheme.bodySmall,
                  validator: (String? value) {
                    if(value == null || value.isEmpty) {
                      return 'Valeur manquante';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String value) => character.name = value,
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: character.origin.place,
                  builder: (BuildContext context, AsyncSnapshot<Place?> snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Chargement...');
                    }

                    var origin = snapshot.hasData && snapshot.data != null
                      ? snapshot.data!
                      : Place.unknown;

                    return FutureBuilder(
                      future: Place.withParent('e8c6ea13-f27c-4f12-8865-477305c61617'),
                      builder: (BuildContext context, AsyncSnapshot<List<Place>> snapshot) {
                        Widget? trailing;
                        var places = <Place>[
                          Place.unknown,
                        ];

                        if(snapshot.connectionState == ConnectionState.waiting) {
                          trailing = CircularProgressIndicator();
                        }

                        if(snapshot.hasError) {
                          trailing = Icon(Icons.warning);
                        }

                        if(snapshot.hasData && snapshot.data != null) {
                          places.addAll(snapshot.data!);
                        }

                        places.sort((Place a, Place b) => a.name.compareTo(b.name));

                        return DropdownMenuFormField<Place>(
                          initialSelection: origin,
                          requestFocusOnTap: true,
                          label: const Text("Pays d'origine"),
                          expandedInsets: EdgeInsets.zero,
                          textStyle: theme.textTheme.bodySmall,
                          trailingIcon: trailing,
                          inputDecorationTheme: const InputDecorationTheme(
                            border: OutlineInputBorder(),
                            isCollapsed: true,
                            constraints: BoxConstraints(maxHeight: 36.0),
                            contentPadding: EdgeInsets.all(12.0),
                          ),
                          dropdownMenuEntries: places
                            .where((Place p) => p.location.type == ObjectLocationType.assets)
                            .map((Place p) => DropdownMenuEntry(value: p, label: p.name))
                            .toList(),
                          validator: (Place? place) {
                            if(place == null) {
                              return 'Valeur manquante';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onSelected: (Place? place) {
                            if(place == null) return;
                            character.origin = CharacterOrigin(
                              uuid: place.uuid,
                              place: place,
                            );
                          },
                        );
                      }
                    );
                  }
                ),
              ),
            ],
          ),
          Row(
            spacing: 8.0,
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: character.age.toString(),
                  decoration: const InputDecoration(
                    label: Text('Âge'),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  style: theme.textTheme.bodySmall,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (String? value) {
                    if(value == null || value.isEmpty) return 'Valeur manquante';
                    int? input = int.tryParse(value);
                    if(input == null) return 'Pas un nombre';
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String value) => character.age = int.parse(value),
                ),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: character.height.toStringAsFixed(2),
                  decoration: const InputDecoration(
                    label: Text('Taille (m)'),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  style: theme.textTheme.bodySmall,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                  ],
                  validator: (String? value) {
                    if(value == null || value.isEmpty) return 'Valeur manquante';
                    double? input = double.tryParse(value);
                    if(input == null) return 'Pas un nombre';
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String value) => character.height = double.parse(value),
                ),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: character.weight.toStringAsFixed(2),
                  decoration: const InputDecoration(
                    label: Text('Poids (kg)'),
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  style: theme.textTheme.bodySmall,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[.0-9]')),
                  ],
                  validator: (String? value) {
                    if(value == null || value.isEmpty) return 'Valeur manquante';
                    double? input = double.tryParse(value);
                    if(input == null) return 'Pas un nombre';
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String? value) => character.weight = double.parse(value!),
                ),
              ),
              if(character is NonPlayerCharacter)
                Row(
                  spacing: 4.0,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: (character as NonPlayerCharacter).uniqueNotifier,
                      builder: (BuildContext context, bool unique, _) {
                        return Switch(
                          value: unique,
                          onChanged: (bool value) {
                            (character as NonPlayerCharacter).unique = value;
                          },
                        );
                      }
                    ),
                    Text(
                      'Unique',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
            ],
          ),
        ],
      )
    );
  }
}