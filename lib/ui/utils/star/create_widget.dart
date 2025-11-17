import 'package:flutter/material.dart';

import '../../../classes/object_source.dart';
import '../../../classes/star.dart';
import '../../../classes/star_motivations.dart';
import 'edit_widget.dart';

class StarCreateWidget extends StatefulWidget {
  const StarCreateWidget({
    super.key,
    required this.onStarCreated,
    this.source,
    this.cloneFrom,
  });

  final void Function(Star?) onStarCreated;
  final ObjectSource? source;
  final String? cloneFrom;

  @override
  State<StarCreateWidget> createState() => _StarCreateWidgetState();
}

class _StarCreateWidgetState extends State<StarCreateWidget> {
  Star? from;
  Star? star;

  @override
  Widget build(BuildContext context) {
    if(widget.cloneFrom != null && from == null) {
      return FutureBuilder(
        future: Star.get(widget.cloneFrom!),
        builder: (BuildContext context, AsyncSnapshot<Star?> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }

          if(!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('Étoile source non trouvée'),
            );
          }

          from = snapshot.data!;
          return getStarCreateForm();
        }
      );
    }

    if(star == null) {
      return getStarCreateForm();
    }

    return StarEditWidget(
      star: star!,
      onEditDone: (bool result) async {
        if(result) {
          await Star.saveLocalModel(star!);
        }
        else {
          Star.removeFromCache(star!.id);
          star = null;
        }

        widget.onStarCreated(star);
      }
    );
  }

  Widget getStarCreateForm() {
    return Center(
      child: SizedBox(
        width: 400,
        child: SizedBox(
          child: _StarCreateForm(
            source: widget.source ?? ObjectSource.local,
            cloneFrom: from,
            onStarCreated: (Star? s) {
              if(s == null) {
                widget.onStarCreated(null);
              }
              else {
                setState(() {
                  star = s;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}

class _StarCreateForm extends StatefulWidget {
  const _StarCreateForm({
    required this.source,
    required this.onStarCreated,
    this.cloneFrom,
  });

  final ObjectSource source;
  final void Function(Star?) onStarCreated;
  final Star? cloneFrom;

  @override
  State<_StarCreateForm> createState() => _StarCreateFormState();
}

class _StarCreateFormState extends State<_StarCreateForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.cloneFrom != null
        ? '${widget.cloneFrom!.name} (clone)'
        : '';
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12.0,
        children: [
          TextFormField(
            controller: nameController,
            autofocus: true,
            decoration: InputDecoration(
              label: const Text('Nom'),
            ),
            validator: (String? value) {
              if(value == null || value.isEmpty) {
                return 'La valeur est obligatoire';
              }

              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.onStarCreated(null);
                  },
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () async {
                    if(!formKey.currentState!.validate()) {
                      return;
                    }

                    Star star;

                    if(widget.cloneFrom == null) {
                      star = Star(
                        source: widget.source,
                        name: nameController.text,
                        envergure: StarReach.level0,
                        motivations: StarMotivations.empty(),
                      );
                    }
                    else {
                      star = Star(
                        source: widget.source,
                        name: nameController.text,
                        envergure: widget.cloneFrom!.envergure,
                        motivations: widget.cloneFrom!.motivations.clone(),
                      );
                    }

                    widget.onStarCreated(star);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: const Text('OK'),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}