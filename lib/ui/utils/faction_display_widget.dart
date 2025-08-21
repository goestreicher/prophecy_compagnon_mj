import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../classes/faction.dart';
import '../../classes/object_location.dart';
import '../../classes/object_source.dart';
import '../utils/faction_edit_dialog.dart';

class FactionDisplayWidget extends StatelessWidget {
  const FactionDisplayWidget({
    super.key,
    required this.faction,
    required this.onEdited,
    required this.onDelete,
    this.modifyIfSourceMatches,
  });

  final Faction faction;
  final void Function(Faction) onEdited;
  final void Function(Faction) onDelete;
  final ObjectSource? modifyIfSourceMatches;

  Future<List<Map<String, dynamic>>> _export(Faction f) async {
    var ret = <Map<String, dynamic>>[];
    ret.add(f.toJson());
    for(var child in Faction.withParent(f.id)) {
      ret.addAll(await _export(child));
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    bool canEdit = modifyIfSourceMatches != null
      ? faction.source == modifyIfSourceMatches
      : faction.source == ObjectSource.local;

    var actionButtons = <Widget>[];

    if(faction.location.type != ObjectLocationType.assets) {
      actionButtons.add(IconButton(
        onPressed: () async {
          var j = await _export(faction);
          var jStr = json.encode(j);
          await FilePicker.platform.saveFile(
            fileName: 'faction_${faction.id}.json',
            bytes: utf8.encode(jStr),
          );
        },
        icon: const Icon(Icons.download),
      ));
    }

    if(canEdit) {
      actionButtons.addAll([
        IconButton(
          onPressed: () {
            onDelete(faction);
          },
          icon: const Icon(Icons.delete),
        ),
        const SizedBox(width: 12.0),
        IconButton(
          onPressed: () async {
            var child = await showDialog<Faction>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => FactionEditDialog(faction: faction),
            );
            if(child == null) return;
            onEdited(faction);
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
                  faction.name,
                  style: theme.textTheme.headlineMedium,
                ),
                Spacer(),
                ...actionButtons,
              ],
            ),
            const SizedBox(height: 16.0),
            if(faction.leaders.isNotEmpty)
              Text(
                'Dirigeant${faction.leaders.length > 1 ? "s" : ""}',
                style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            for(var leader in faction.leaders)
              Text(
                '${leader.name}, ${leader.title}'
              ),
            if(faction.leaders.isNotEmpty)
              const SizedBox(height: 16.0),
            if(faction.members.isNotEmpty)
              Text(
                'Membres',
                style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            for(var member in faction.members)
              Text(
                  '${member.name}, ${member.title}'
              ),
            if(faction.members.isNotEmpty)
              const SizedBox(height: 16.0),
            MarkdownBody(data: faction.description),
          ],
        ),
      ),
    );
  }
}