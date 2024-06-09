import 'dart:convert';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';

import '../../classes/creature.dart';
import '../../classes/equipment.dart';
import '../utils/ability_list_display_widget.dart';
import '../utils/attribute_list_display_widget.dart';
import '../utils/injuries_display_widget.dart';
import '../utils/single_line_input_dialog.dart';

class CreatureDisplayWidget extends StatelessWidget {
  const CreatureDisplayWidget({
    super.key,
    required this.creature,
    required this.onEditRequested,
    required this.onCloneEditRequested,
    required this.onDelete,
  });

  final CreatureModel creature;
  final void Function() onEditRequested;
  final void Function(CreatureModel) onCloneEditRequested;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    List<String> equipment = <String>[];
    for(var e in creature.equipment) {
      var eq = EquipmentFactory.instance.forgeEquipment(e);
      if(eq != null ) {
        equipment.add(eq.name());
      }
    }

    var armorDescription = creature.naturalArmor.toString();
    if(creature.naturalArmorDescription.isNotEmpty) {
      armorDescription += ' (${creature.naturalArmorDescription})';
    }

    Map<String, int> weapons = <String, int>{};
    for(var w in creature.naturalWeapons) {
      weapons[w.name] = w.damage;
    }

    Map<String, int> skills = <String, int>{};
    for(var s in creature.skills) {
      if(s.value > 0) {
        skills[s.skill.title] = s.value;
      }
      for(var sp in s.specializations.keys) {
        skills['${s.skill.title} (${sp.title})'] = s.specializations[sp]!;
      }
    }
    var skillsOrder = skills.keys.toList()..sort((a, b) => a.compareTo(b));

    return Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        creature.name,
                        softWrap: true,
                        style: theme.textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: !creature.editable ?
                      'Modification impossible (créature par défaut)' :
                      'Modifier',
                      onPressed: !creature.editable ? null : () => onEditRequested(),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.content_copy_outlined),
                      tooltip: 'Cloner',
                      onPressed: () async {
                        var name = await showDialog(
                          context: context,
                          builder: (BuildContext context) => SingleLineInputDialog(
                            title: 'Nom de la créature',
                            hintText: 'Nom',
                            formKey: GlobalKey<FormState>(),
                          ),
                        );
                        if(!context.mounted) return;
                        if(name == null) return;

                        var jsonObj = creature.toJson();
                        jsonObj['name'] = name;
                        // The round-trip through json.encode and json.decode seems necessary
                        // to ensure that the full object in converted, otherwise List elements
                        // are not correctly converted to JSON
                        onCloneEditRequested(
                            CreatureModel.fromJson(
                                json.decode(json.encode(jsonObj))
                            )
                        );
                      },
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: !creature.editable ?
                      'Suppression impossible (créature par défaut)' :
                      'Supprimer',
                      onPressed: !creature.editable ? null : () => onDelete(),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.download),
                      tooltip: 'Télécharger (JSON)',
                      onPressed: () async {
                        var jsonStr = json.encode(creature.toJson());
                        await FileSaver.instance.saveFile(
                          name: 'creature-${creature.id}.json',
                          bytes: utf8.encode(jsonStr),
                        );
                      },
                    ),
                  ]
              ),
              const SizedBox(height: 16.0),
              RichText(
                  text: TextSpan(
                      text: 'Taille : ',
                      style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: creature.size,
                          style: theme.textTheme.bodyLarge,
                        )
                      ]
                  )
              ),
              RichText(
                  text: TextSpan(
                      text: 'Poids : ',
                      style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: creature.weight,
                          style: theme.textTheme.bodyLarge,
                        )
                      ]
                  )
              ),
              RichText(
                  text: TextSpan(
                      text: 'Habitat : ',
                      style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: creature.biome,
                          style: theme.textTheme.bodyLarge,
                        )
                      ]
                  )
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const SizedBox(width: 16.0),
                  AbilityListDisplayWidget(abilities: creature.abilities),
                  const SizedBox(width: 32.0),
                  AttributeListDisplayWidget(attributes: creature.attributes),
                ],
              ),
              const SizedBox(height: 8.0),
              RichText(
                  text: TextSpan(
                      text: 'Initiative : ',
                      style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: creature.initiative.toString(),
                          style: theme.textTheme.bodyLarge,
                        )
                      ]
                  )
              ),
              RichText(
                  text: TextSpan(
                      text: 'Armure : ',
                      style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: armorDescription,
                          style: theme.textTheme.bodyLarge,
                        )
                      ]
                  )
              ),
              const SizedBox(height: 8.0),
              Text(
                'Compétences',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              for(var skill in skillsOrder)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  child: Text('$skill ${skills[skill]}'),
                ),
              if(creature.naturalWeapons.isNotEmpty)
                const SizedBox(height: 8.0),
              if(creature.naturalWeapons.isNotEmpty)
                Text(
                  'Armes naturelles',
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
              for(var w in creature.naturalWeapons)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  child: Text('${w.name} (${w.skill}), Dommages ${w.damage}'),
                ),
              const SizedBox(height: 8.0),
              Text(
                'Seuils de blessure',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                child: InjuriesDisplayWidget(injuries: creature.injuries),
              ),
              if(equipment.isNotEmpty)
                const SizedBox(height: 8.0),
              if(equipment.isNotEmpty)
                Text(
                  'Équipement',
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
              for(var e in equipment)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  child: Text(e),
                ),
              if(creature.specialCapability.isNotEmpty)
                const SizedBox(height: 8.0),
              if(creature.specialCapability.isNotEmpty)
                Text(
                  'Capacité spéciale',
                  style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
              if(creature.specialCapability.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                  child: Text(creature.specialCapability),
                ),
              const SizedBox(height: 8.0),
              Text(
                'Description',
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                creature.description,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        )
    );
  }
}