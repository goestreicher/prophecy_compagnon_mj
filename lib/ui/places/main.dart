import 'package:animated_tree_view/animated_tree_view.dart';
import 'package:float_column/float_column.dart';
import 'package:flutter/material.dart';

import '../../classes/object_source.dart';
import '../../classes/place.dart';
import 'place_edit_dialog.dart';

class PlacesMainPage extends StatefulWidget {
  const PlacesMainPage({ super.key });

  @override
  State<PlacesMainPage> createState() => _PlacesMainPageState();
}

class _PlacesMainPageState extends State<PlacesMainPage> {
  late final TreeNode<Place> tree;
  final TextEditingController sourceTypeController = TextEditingController();
  ObjectSourceType? selectedSourceType;
  final TextEditingController sourceController = TextEditingController();
  ObjectSource? selectedSource;

  Place? selectedPlace;

  void buildSubTree(TreeNode root, Place place) {
    for(var child in Place.withParent(place.id)) {
      var node = TreeNode(key: child.id, data: child);
      root.add(node);
      buildSubTree(node, child);
    }
  }

  @override
  void initState() {
    super.initState();
    tree = TreeNode.root();
    buildSubTree(tree, Place.byId('monde')!);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(right: 8.0),
                  sliver: SliverTreeView.simple(
                    tree: tree,
                    showRootNode: false,
                    onTreeReady: (TreeViewController controller) {
                      controller.expandNode(controller.elementAt('kor'));
                    },
                    expansionIndicatorBuilder: (BuildContext context, node) {
                      return ChevronIndicator.rightDown(
                        tree: node,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(6.0, 0.0, 0.0, 0.0),
                      );
                    },
                    indentation: const Indentation(),
                    builder: (BuildContext context, TreeNode node) {
                      var leftPad = 12.0;
                      if(node.children.isNotEmpty) {
                        leftPad = 24.0;
                      }

                      var place = node.data as Place;

                      return Card(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(leftPad, 0.0, 6.0, 0.0),
                          child: Row(
                            children: [
                              Text(place.name),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.info_outline),
                                iconSize: 18.0,
                                onPressed: () {
                                  setState(() {
                                    selectedPlace = place;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                iconSize: 18.0,
                                tooltip: 'Nouveau lieu',
                                onPressed: () async {
                                  var child = await showDialog<Place>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) =>
                                        PlaceEditDialog(parent: place.id),
                                  );
                                  if(child == null) return;

                                  setState(() {
                                    node.add(TreeNode(key: child.id, data: child));
                                    selectedPlace = child;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                )
              ],
            ),
          ),
          if(selectedPlace != null)
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(4.0, 16.0, 0.0, 16.0),
                child: PlaceDisplayWidget(
                  place: selectedPlace!,
                  onEdited: (Place p) => setState(() {
                    selectedPlace = p;
                  }),
                  onDelete: (Place p) async {
                    var confirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Confirmer la suppression'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Supprimer ce lieux et tous ses enfants ?'),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Supprimer'),
                          ),
                        ]
                      )
                    );
                    if(confirm == null || !confirm) return;

                    Place? current = p;
                    var path = p.id;
                    while(current != null && current.parentId != null && current.parentId != 'monde') {
                      current = Place.byId(current.parentId!);
                      path = '${current!.id}.$path';
                    }
                    var n = tree.elementAt(path);
                    setState(() {
                      selectedPlace = null;
                      n.parent?.remove(n);
                    });

                    await Place.delete(p);
                  },
                ),
              )
            ),
        ],
      )
    );
  }
}

class PlaceDisplayWidget extends StatelessWidget {
  const PlaceDisplayWidget({
    super.key,
    required this.place,
    required this.onEdited,
    required this.onDelete,
  });

  final Place place;
  final void Function(Place) onEdited;
  final void Function(Place) onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var paragraphSpacing = 16.0;
    bool canEdit = place.source == ObjectSource.local;

    var actionButtons = <Widget>[];
    if(canEdit) {
      actionButtons.addAll([
        IconButton(
          onPressed: () {
            onDelete(place);
          },
          icon: const Icon(Icons.delete),
        ),
        const SizedBox(width: 12.0),
        IconButton(
          onPressed: () async {
            var child = await showDialog<Place>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) =>
                  PlaceEditDialog(parent: place.parentId!, place: place),
            );
            if(child == null) return;
            onEdited(place);
          },
          icon: const Icon(Icons.edit),
        ),
      ]);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  place.name,
                  style: theme.textTheme.headlineMedium,
                ),
                Spacer(),
                ...actionButtons,
              ],
            ),
            const SizedBox(height: 16.0),
            FloatColumn(
              children: [
                if(place.map != null)
                  Floatable(
                    float: FCFloat.start,
                    padding: EdgeInsets.only(right: 8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 200, maxHeight: 300),
                      child: FutureBuilder(
                        future: place.map!.load(),
                        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          if(snapshot.hasError) {
                            return Center(child: Text(snapshot.error.toString()));
                          }

                          return Image.memory(
                            place.map!.image!,
                            fit: BoxFit.contain,
                          );
                        }
                      ),
                    ),
                  ),
                WrappableText(
                  text: TextSpan(
                    text: 'Type : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.type.title,
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Régime : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.government ?? 'aucun',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Dirigeant : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.leader ?? 'aucun',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Valeurs : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.motto ?? 'non renseigné',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Climat : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.climate ?? 'non renseigné',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Description : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.general,
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Histoire',
                                  value: place.description.history
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.history = ret;
                            await PlaceStore().save(place);
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Histoire : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.history ?? 'non renseignée',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      ),
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Ethnologie',
                                  value: place.description.ethnology
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.ethnology = ret;
                            await PlaceStore().save(place);
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Ethnologie : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.ethnology ?? 'non renseignée',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Mentalité et société',
                                  value: place.description.society
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.society = ret;
                            await PlaceStore().save(place);
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Mentalité et société : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.society ?? 'non renseigné',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Politique',
                                  value: place.description.politics
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.politics = ret;
                            await PlaceStore().save(place);
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Politique : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.politics ?? 'non renseignée',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Juridique',
                                  value: place.description.judicial
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.judicial = ret;
                            await PlaceStore().save(place);
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Juridique : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.judicial ?? 'non renseigné',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Économie',
                                  value: place.description.economy
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.economy = ret;
                            await PlaceStore().save(place);
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Économie : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.economy ?? 'non renseignée',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
                if(canEdit)
                  Floatable(
                    float: FCFloat.start,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, paragraphSpacing+2.0, 4.0, 0.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            var ret = await showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return _PlaceDescriptionItemEditDialog(
                                  item: 'Militaire',
                                  value: place.description.military
                                );
                              }
                            );
                            if(ret == null) return;
                            place.description.military = ret;
                            await PlaceStore().save(place);
                            onEdited(place);
                          },
                          child: const Icon(Icons.edit, size: 16.0,),
                        ),
                      )
                    )
                  ),
                WrappableText(
                  margin: EdgeInsets.only(top: paragraphSpacing),
                  text: TextSpan(
                    text: 'Militaire : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: place.description.military ?? 'non renseigné',
                        style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
                      )
                    ]
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceDescriptionItemEditDialog extends StatelessWidget {
  _PlaceDescriptionItemEditDialog({ required this.item, this.value });

  final String item;
  final String? value;
  final TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    valueController.text = value ?? '';

    return AlertDialog(
      title: Text(item),
      content: SizedBox(
        width: 600,
        child: Focus(
          child: TextField(
            controller: valueController,
            minLines: 10,
            maxLines: 10,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Annuler'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(valueController.text),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
