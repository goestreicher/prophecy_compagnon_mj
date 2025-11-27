import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../classes/magic.dart';
import '../../classes/magic_spell.dart';
import '../utils/spell/display_widget.dart';
import '../utils/spell/list_filter_widget.dart';
import '../utils/spell/list_widget.dart';

class SpellsListPage extends StatefulWidget {
  const SpellsListPage({ super.key, this.selected });

  final String? selected;

  @override
  State<SpellsListPage> createState() => _SpellsListPageState();
}

class _SpellsListPageState extends State<SpellsListPage> {
  bool isWorking = false;
  MagicSpellFilter filter = MagicSpellFilter();
  Future<void>? spellsFuture;
  List<MagicSpell> spells = <MagicSpell>[];
  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.selected;
  }

  void resetSpellsList() {
    spellsFuture = null;
    spells.clear();
  }

  Future<void> updateSpellsList() async {
    if(filter.sphere == null) {
      spells.clear();
    }
    else {
      spells = MagicSpell.filteredList(filter).toList();
    }

    spells.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    if(spells.isEmpty && spellsFuture == null) {
      spellsFuture = updateSpellsList();
    }

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0.0),
              child: Wrap(
                spacing: 16.0,
                runSpacing: 8.0,
                children: [
                  SpellListFilterWidget(
                      filter: filter,
                      onFilterChanged: (MagicSpellFilter f) {
                        setState(() {
                          filter = f;
                          resetSpellsList();
                          selected = null;
                        });
                      }
                  ),
                  // MenuAnchor(
                  //   alignmentOffset: const Offset(0, 4),
                  //   builder: (BuildContext context, MenuController controller, Widget? child) {
                  //     return IconButton.filled(
                  //       icon: const Icon(Icons.add),
                  //       iconSize: 24.0,
                  //       padding: const EdgeInsets.all(4.0),
                  //       tooltip: 'Créer / Importer',
                  //       onPressed: () {
                  //         if(controller.isOpen) {
                  //           controller.close();
                  //         }
                  //         else {
                  //           controller.open();
                  //         }
                  //       },
                  //     );
                  //   },
                  //   menuChildren: [
                  //     MenuItemButton(
                  //       child: const Row(
                  //         children: [
                  //           Icon(Icons.create),
                  //           SizedBox(width: 4.0),
                  //           Text('Nouveau sort'),
                  //         ],
                  //       ),
                  //       onPressed: () {
                  //         // TODO
                  //         // context.go('/spells/create');
                  //       },
                  //     ),
                  //     MenuItemButton(
                  //       child: const Row(
                  //         children: [
                  //           Icon(Icons.publish),
                  //           SizedBox(width: 4.0),
                  //           Text('Importer un sort'),
                  //         ],
                  //       ),
                  //       onPressed: () async {
                  //         // TODO
                  //         // var result = await FilePicker.platform.pickFiles(
                  //         //   type: FileType.custom,
                  //         //   allowedExtensions: ['json'],
                  //         //   withData: true,
                  //         // );
                  //         // if(!context.mounted) return;
                  //         // if(result == null) return;
                  //         //
                  //         // try {
                  //         //   setState(() {
                  //         //     isWorking = true;
                  //         //   });
                  //         //
                  //         //   var jsonStr = const Utf8Decoder().convert(result.files.first.bytes!);
                  //         //   var j = json.decode(jsonStr);
                  //         //   var spell = await MagicSpell.import(j);
                  //         //
                  //         //   setState(() {
                  //         //     selected = spell.id;
                  //         //     isWorking = false;
                  //         //     resetSpellsList();
                  //         //   });
                  //         // } catch (e) {
                  //         //   setState(() {
                  //         //     isWorking = false;
                  //         //   });
                  //         //
                  //         //   if(!context.mounted) return;
                  //         //
                  //         //   displayErrorDialog(
                  //         //       context,
                  //         //       "Échec de l'import",
                  //         //       e.toString()
                  //         //   );
                  //         // }
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          for(var sphere in MagicSphere.values)
                            _SphereSelectionButton(
                              sphere: sphere,
                              selected: filter.sphere == sphere,
                              onPressed: () {
                                if(filter.sphere == sphere) return;
                                setState(() {
                                  filter.sphere = sphere;
                                  resetSpellsList();
                                  selected = null;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  if(filter.sphere != null)
                    Expanded(
                      child: FutureBuilder(
                        future: spellsFuture,
                        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return ErrorWidget(snapshot.error!);
                          }

                          if(spells.isEmpty) {
                            return Center(
                              child: Text(
                                'Aucun sort trouvé',
                              )
                            );
                          }

                          return SpellsListWidget(
                            spells: spells,
                            selected: selected,
                            onSelected: (String? id) {
                              if(id == null && GoRouter.of(context).state.fullPath!.endsWith('/:uuid')) {
                                context.replace('/spells');
                              }

                              setState(() {
                                selected = id;
                              });
                            },
                            // onEditRequested: (String id) async {
                              // TODO
                              // context.go('/spells/$id/edit');
                            // },
                            // onCloneRequested: (String id) async {
                              // TODO
                              // context.go('/spells/clone/$id');
                            // },
                            // onDeleteRequested: (String id) async {
                              // TODO
                              // try {
                              //   await MagicSpell.deleteLocalModel(id);
                              //   setState(() {
                              //     selected = null;
                              //     resetSpellsList();
                              //   });
                              // }
                              // catch(e) {
                              //   if(!context.mounted) return;
                              //   displayErrorDialog(
                              //       context,
                              //       "Suppression impossible",
                              //       e.toString()
                              //   );
                              // }
                            // },
                            // restrictModificationToSourceTypes: [
                            //   ObjectSourceType.original
                            // ],
                          );
                        }
                      ),
                    ),
                  if(selected != null)
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
                          child: SpellDisplayWidget(
                            id: selected!,
                          ),
                        ),
                      ),
                    ),
                ],
              )
            ),
          ],
        ),
        if(isWorking)
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
        if(isWorking)
          const Center(
            child: CircularProgressIndicator()
          ),
      ],
    );
  }
}

class _SphereSelectionButton extends StatelessWidget {
  const _SphereSelectionButton({
    required this.sphere,
    required this.onPressed,
    this.selected = false,
  });

  final MagicSphere sphere;
  final void Function() onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: selected ? theme.colorScheme.surface : null,
        boxShadow: selected ?
        [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.5),
            spreadRadius: 0.5,
            blurRadius: 1.0,
            offset: const Offset(1, 1),
          ),
        ] :
        null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => onPressed(),
            child: Image.asset(
              'assets/images/magic/sphere-${sphere.name}-color.png',
              width: 64.0,
            )
          ),
          const SizedBox(height: 8.0),
          Text(
            sphere.title,
            style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}