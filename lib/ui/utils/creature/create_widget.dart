import 'package:flutter/material.dart';

import '../../../classes/creature.dart';
import '../../../classes/object_source.dart';
import 'create_form.dart';
import 'edit_widget.dart';

class CreatureCreateWidget extends StatefulWidget {
  const CreatureCreateWidget({
    super.key,
    required this.onCreatureCreated,
    this.source,
    this.cloneFrom,
  });

  final void Function(Creature?) onCreatureCreated;
  final ObjectSource? source;
  final String? cloneFrom;

  @override
  State<CreatureCreateWidget> createState() => _CreatureCreateWidgetState();
}

class _CreatureCreateWidgetState extends State<CreatureCreateWidget> {
  Creature? from;
  Creature? creature;

  @override
  Widget build(BuildContext context) {
    if(widget.cloneFrom != null && from == null) {
      return FutureBuilder(
        future: Creature.get(widget.cloneFrom!),
        builder: (BuildContext context, AsyncSnapshot<Creature?> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }

          if(!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('Créature source non trouvée'),
            );
          }

          from = snapshot.data!;
          return getCreatureCreateForm();
        }
      );
    }

    if(creature == null) {
      return getCreatureCreateForm();
    }

    return CreatureEditWidget(
      creature: creature!,
      onEditDone: (bool result) async {
        if(result) {
          await Creature.saveLocalModel(creature!);
        }
        else {
          Creature.removeFromCache(creature!.id);
          creature = null;
        }

        widget.onCreatureCreated(creature);
      }
    );
  }

  Widget getCreatureCreateForm() {
    return Center(
      child: SizedBox(
        width: 400,
        child: SizedBox(
          child: CreatureCreateForm(
            source: widget.source ?? ObjectSource.local,
            cloneFrom: from,
            onCreatureCreated: (Creature? c) {
              if(c == null) {
                widget.onCreatureCreated(null);
              }
              else {
                setState(() {
                  creature = c;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}