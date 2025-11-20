import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:parchment/codecs.dart';

import '../../../classes/star.dart';
import '../../../classes/star_motivations.dart';
import '../../../classes/star_powers.dart';
import '../markdown_fleather_toolbar.dart';
import '../num_input_widget.dart';
import '../widget_group_container.dart';
import 'companies_display_widget.dart';

class StarEditWidget extends StatefulWidget {
  const StarEditWidget({
    super.key,
    required this.star,
    required this.onEditDone,
  });

  final Star star;
  final void Function(bool) onEditDone;

  @override
  State<StarEditWidget> createState() => _StarEditWidgetState();
}

class _StarEditWidgetState extends State<StarEditWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  late final FleatherController descriptionController;
  late final FocusNode descriptionFocusNode;
  final Map<MotivationType, TextEditingController> valueControllers = <MotivationType, TextEditingController>{};
  final Map<MotivationType, TextEditingController> circlesControllers = <MotivationType, TextEditingController>{};

  @override
  void initState() {
    super.initState();

    nameController.text = widget.star.name;

    descriptionFocusNode = FocusNode();
    ParchmentDocument document = ParchmentMarkdownCodec().decode(widget.star.description);
    descriptionController = FleatherController(document: document);

    for(var m in MotivationType.values) {
      valueControllers[m] = TextEditingController();
      circlesControllers[m] = TextEditingController();
    }
  }

  @override
  void dispose() {
    descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 1000.0,
          ),
          child: Form(
            key: formKey,
            child: Column(
              spacing: 12.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined),
                      onPressed: () {
                        widget.onEditDone(false);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: () {
                        if(formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          widget.onEditDone(true);
                        }
                      }
                    )
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.0,
                  children: [
                    Expanded(
                      child: WidgetGroupContainer(
                        title: Text(
                          'Caractéristiques',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Column(
                          spacing: 12.0,
                          children: [
                            Row(
                              spacing: 12.0,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: nameController,
                                    decoration: const InputDecoration(
                                      label: Text('Nom'),
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (String? value) {
                                      if(value == null || value.isEmpty) {
                                        return 'Valeur manquante';
                                      }
                                      return null;
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    onSaved: (String? value) =>
                                      widget.star.name = nameController.text,
                                  ),
                                ),
                                DropdownMenuFormField(
                                  initialSelection: widget.star.envergure,
                                  requestFocusOnTap: true,
                                  label: const Text('Envergure'),
                                  inputDecorationTheme: InputDecorationTheme(
                                    border: OutlineInputBorder(),
                                  ),
                                  dropdownMenuEntries: StarReach.values
                                    .map(
                                      (StarReach r) => DropdownMenuEntry(
                                        value: r,
                                        label: '${r.index + 1} : ${r.title}'
                                      )
                                    )
                                    .toList(),
                                  validator: (StarReach? value) {
                                    if(value == null) {
                                      return 'Valeur manquante';
                                    }
                                    return null;
                                  },
                                  onSaved: (StarReach? r) =>
                                    widget.star.envergure = r!,
                                ),
                              ],
                            ),
                            Row(
                              spacing: 24.0,
                              children: [
                                Expanded(
                                  child: Column(
                                    spacing: 12.0,
                                    children: [
                                      Row(
                                        spacing: 12.0,
                                        children: [
                                          Expanded(
                                            child: DropdownMenuFormField(
                                              initialSelection: widget.star.motivations.vertu,
                                              requestFocusOnTap: true,
                                              label: const Text('Vertu'),
                                              expandedInsets: EdgeInsets.zero,
                                              inputDecorationTheme: InputDecorationTheme(
                                                border: OutlineInputBorder(),
                                              ),
                                              dropdownMenuEntries: MotivationVertu.values
                                                .map(
                                                  (MotivationVertu m) => DropdownMenuEntry(
                                                    value: m,
                                                    label: m.title
                                                  )
                                                )
                                                .toList(),
                                              validator: (MotivationVertu? value) {
                                                if(value == null) {
                                                  return 'Valeur manquante';
                                                }
                                                return null;
                                              },
                                              onSelected: (MotivationVertu? m) =>
                                                widget.star.motivations.vertu = m!,
                                            ),
                                          ),
                                          _MotivationValueEditWidget(
                                            star: widget.star,
                                            motivation: MotivationType.vertu,
                                            controller: valueControllers[MotivationType.vertu]!,
                                          ),
                                          if(widget.star is PlayersStar)
                                            _MotivationCirclesEditWidget(
                                              star: (widget.star as PlayersStar),
                                              motivation: MotivationType.vertu,
                                              controller: circlesControllers[MotivationType.vertu]!,
                                              valueController: valueControllers[MotivationType.vertu]!,
                                            ),
                                        ],
                                      ),
                                      Row(
                                        spacing: 12.0,
                                        children: [
                                          Expanded(
                                            child: DropdownMenuFormField(
                                              initialSelection: widget.star.motivations.penchant,
                                              requestFocusOnTap: true,
                                              label: const Text('Penchant'),
                                              expandedInsets: EdgeInsets.zero,
                                              inputDecorationTheme: InputDecorationTheme(
                                                border: OutlineInputBorder(),
                                              ),
                                              dropdownMenuEntries: MotivationPenchant.values
                                                .map(
                                                  (MotivationPenchant m) => DropdownMenuEntry(
                                                    value: m,
                                                    label: m.title
                                                  )
                                                )
                                                .toList(),
                                              validator: (MotivationPenchant? value) {
                                                if(value == null) {
                                                  return 'Valeur manquante';
                                                }
                                                return null;
                                              },
                                              onSaved: (MotivationPenchant? m) =>
                                                widget.star.motivations.penchant = m!,
                                            ),
                                          ),
                                          _MotivationValueEditWidget(
                                            star: widget.star,
                                            motivation: MotivationType.penchant,
                                            controller: valueControllers[MotivationType.penchant]!,
                                          ),
                                          if(widget.star is PlayersStar)
                                            _MotivationCirclesEditWidget(
                                              star: (widget.star as PlayersStar),
                                              motivation: MotivationType.penchant,
                                              controller: circlesControllers[MotivationType.penchant]!,
                                              valueController: valueControllers[MotivationType.penchant]!,
                                            ),
                                        ],
                                      ),
                                      Row(
                                        spacing: 12.0,
                                        children: [
                                          Expanded(
                                            child: DropdownMenuFormField(
                                              initialSelection: widget.star.motivations.ideal,
                                              requestFocusOnTap: true,
                                              label: const Text('Idéal'),
                                              expandedInsets: EdgeInsets.zero,
                                              inputDecorationTheme: InputDecorationTheme(
                                                border: OutlineInputBorder(),
                                              ),
                                              dropdownMenuEntries: MotivationIdeal.values
                                                .map(
                                                  (MotivationIdeal m) => DropdownMenuEntry(
                                                    value: m,
                                                    label: m.title
                                                  )
                                                )
                                                .toList(),
                                              validator: (MotivationIdeal? value) {
                                                if(value == null) {
                                                  return 'Valeur manquante';
                                                }
                                                return null;
                                              },
                                              onSaved: (MotivationIdeal? m) =>
                                                widget.star.motivations.ideal = m!,
                                            ),
                                          ),
                                          _MotivationValueEditWidget(
                                            star: widget.star,
                                            motivation: MotivationType.ideal,
                                            controller: valueControllers[MotivationType.ideal]!,
                                          ),
                                          if(widget.star is PlayersStar)
                                            _MotivationCirclesEditWidget(
                                              star: (widget.star as PlayersStar),
                                              motivation: MotivationType.ideal,
                                              controller: circlesControllers[MotivationType.ideal]!,
                                              valueController: valueControllers[MotivationType.ideal]!,
                                            ),
                                        ],
                                      ),
                                      Row(
                                        spacing: 12.0,
                                        children: [
                                          Expanded(
                                            child: DropdownMenuFormField(
                                              initialSelection: widget.star.motivations.interdit,
                                              requestFocusOnTap: true,
                                              label: const Text('Interdit'),
                                              expandedInsets: EdgeInsets.zero,
                                              inputDecorationTheme: InputDecorationTheme(
                                                border: OutlineInputBorder(),
                                              ),
                                              dropdownMenuEntries: MotivationInterdit.values
                                                .map(
                                                  (MotivationInterdit m) => DropdownMenuEntry(
                                                    value: m,
                                                    label: m.title
                                                  )
                                                )
                                                .toList(),
                                              validator: (MotivationInterdit? value) {
                                                if(value == null) {
                                                  return 'Valeur manquante';
                                                }
                                                return null;
                                              },
                                              onSaved: (MotivationInterdit? m) =>
                                                widget.star.motivations.interdit = m!,
                                            ),
                                          ),
                                          _MotivationValueEditWidget(
                                            star: widget.star,
                                            motivation: MotivationType.interdit,
                                            controller: valueControllers[MotivationType.interdit]!,
                                          ),
                                          if(widget.star is PlayersStar)
                                            _MotivationCirclesEditWidget(
                                              star: (widget.star as PlayersStar),
                                              motivation: MotivationType.interdit,
                                              controller: circlesControllers[MotivationType.interdit]!,
                                              valueController: valueControllers[MotivationType.interdit]!,
                                            ),
                                        ],
                                      ),
                                      Row(
                                        spacing: 12.0,
                                        children: [
                                          Expanded(
                                            child: DropdownMenuFormField(
                                              initialSelection: widget.star.motivations.epreuve,
                                              requestFocusOnTap: true,
                                              label: const Text('Épreuve'),
                                              expandedInsets: EdgeInsets.zero,
                                              inputDecorationTheme: InputDecorationTheme(
                                                border: OutlineInputBorder(),
                                              ),
                                              dropdownMenuEntries: MotivationEpreuve.values
                                                .map(
                                                  (MotivationEpreuve m) => DropdownMenuEntry(
                                                    value: m,
                                                    label: m.title
                                                  )
                                                )
                                                .toList(),
                                              validator: (MotivationEpreuve? value) {
                                                if(value == null) {
                                                  return 'Valeur manquante';
                                                }
                                                return null;
                                              },
                                              onSaved: (MotivationEpreuve? m) =>
                                                widget.star.motivations.epreuve = m!,
                                            ),
                                          ),
                                          _MotivationValueEditWidget(
                                            star: widget.star,
                                            motivation: MotivationType.epreuve,
                                            controller: valueControllers[MotivationType.epreuve]!,
                                          ),
                                          if(widget.star is PlayersStar)
                                            _MotivationCirclesEditWidget(
                                              star: (widget.star as PlayersStar),
                                              motivation: MotivationType.epreuve,
                                              controller: circlesControllers[MotivationType.epreuve]!,
                                              valueController: valueControllers[MotivationType.epreuve]!,
                                            ),
                                        ],
                                      ),
                                      Row(
                                        spacing: 12.0,
                                        children: [
                                          Expanded(
                                            child: DropdownMenuFormField(
                                              initialSelection: widget.star.motivations.destinee,
                                              requestFocusOnTap: true,
                                              label: const Text('Destinée'),
                                              expandedInsets: EdgeInsets.zero,
                                              inputDecorationTheme: InputDecorationTheme(
                                                border: OutlineInputBorder(),
                                              ),
                                              dropdownMenuEntries: MotivationDestinee.values
                                                .map(
                                                  (MotivationDestinee m) => DropdownMenuEntry(
                                                    value: m,
                                                    label: m.title
                                                  )
                                                )
                                                .toList(),
                                              validator: (MotivationDestinee? value) {
                                                if(value == null) {
                                                  return 'Valeur manquante';
                                                }
                                                return null;
                                              },
                                              onSaved: (MotivationDestinee? m) =>
                                                widget.star.motivations.destinee = m!,
                                            ),
                                          ),
                                          _MotivationValueEditWidget(
                                            star: widget.star,
                                            motivation: MotivationType.destinee,
                                            controller: valueControllers[MotivationType.destinee]!,
                                          ),
                                          if(widget.star is PlayersStar)
                                            _MotivationCirclesEditWidget(
                                              star: (widget.star as PlayersStar),
                                              motivation: MotivationType.destinee,
                                              controller: circlesControllers[MotivationType.destinee]!,
                                              valueController: valueControllers[MotivationType.destinee]!,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if(widget.star is PlayersStar)
                              Row(
                                spacing: 12.0,
                                children: [
                                  Text("Points d'expérience"),
                                  SizedBox(
                                    width: 96,
                                    child: NumIntInputWidget(
                                      label: 'Valeur',
                                      collapsed: false,
                                      initialValue: (widget.star as PlayersStar).experience,
                                      minValue: 0,
                                      maxValue: 9999,
                                      onChanged: (int v) {
                                        (widget.star as PlayersStar).experience = v;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        )
                      ),
                    ),
                    Expanded(
                      child: WidgetGroupContainer(
                        title: Text(
                          'Pouvoirs',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Column(
                          spacing: 12.0,
                          children: [
                            if(widget.star.eclat == 0)
                              Center(
                                child: Text(
                                  'Éclat insuffisant',
                                ),
                              ),
                            for(var i = 1; i <= widget.star.eclat; ++i)
                              _StarPowerSelect(
                                eclat: i,
                                selected: widget.star.powers[i],
                                onSelected: (StarPower? p) => p == null
                                  ? widget.star.powers.remove(i)
                                  : widget.star.powers[i] = p,
                              ),
                          ],
                        )
                      ),
                    )
                  ],
                ),
                StarCompaniesDisplayWidget(
                  star: widget.star,
                  edit: true,
                ),
                WidgetGroupContainer(
                  title: Text(
                    'Description',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Column(
                    spacing: 8.0,
                    children: [
                      MarkdownFleatherToolbarFormField(
                        controller: descriptionController,
                        showResourcePicker: true,
                        onSaved: (String value) {
                          widget.star.description = value;
                        },
                      ),
                      SizedBox(
                        height: 300,
                        child: FleatherField(
                          controller: descriptionController,
                          focusNode: descriptionFocusNode,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          expands: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      )
    );
  }
}

class _MotivationValueEditWidget extends StatelessWidget {
  const _MotivationValueEditWidget({
    required this.star,
    required this.motivation,
    required this.controller,
  });

  final Star star;
  final MotivationType motivation;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: NumIntInputWidget(
        label: 'Valeur',
        collapsed: false,
        controller: controller,
        initialValue: star.motivations.getValue(motivation),
        minValue: 0,
        maxValue: 10,
        onChanged: (int v) {
          star.motivations.setValue(motivation, v);
        },
      ),
    );
  }
}

class _MotivationCirclesEditWidget extends StatelessWidget {
  const _MotivationCirclesEditWidget({
    required this.star,
    required this.motivation,
    required this.controller,
    required this.valueController,
  });

  final PlayersStar star;
  final MotivationType motivation;
  final TextEditingController valueController;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      child: NumIntInputWidget(
        label: 'Cercles',
        collapsed: false,
        initialValue: star.getCircles(motivation),
        controller: controller,
        minValue: 0,
        maxValue: 10,
        onChanged: (int v) {
          star.setCircles(motivation, v);
        },
        onOverflow: () {
          var current = star.motivations.getValue(motivation);
          if(current < 10) {
            star.motivations.setValue(motivation, current + 1);
            valueController.text = (current + 1).toString();

            star.setCircles(motivation, 0);
            controller.text = '0';

            return 0;
          }
          else {
            return 10;
          }
        },
        onUnderflow: () {
          var current = star.motivations.getValue(motivation);
          if(current > 1) {
            star.motivations.setValue(motivation, current - 1);
            valueController.text = (current - 1).toString();

            star.setCircles(motivation, 10);
            controller.text = '10';

            return 10;
          }
          else {
            return 0;
          }
        },
      ),
    );
  }
}

class _StarPowerSelect extends StatelessWidget {
  const _StarPowerSelect({
    required this.eclat,
    required this.onSelected,
    this.selected,
  });

  final int eclat;
  final void Function(StarPower?) onSelected;
  final StarPower? selected;

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry<StarPower>> entries = StarPower.values
      .where((StarPower p) => p.eclat.contains(eclat))
      .map((StarPower p) => DropdownMenuEntry(value: p, label: p.title))
      .toList();

    return DropdownMenuFormField(
      initialSelection: selected,
      requestFocusOnTap: true,
      label: Text('Éclat $eclat'),
      expandedInsets: EdgeInsets.zero,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      dropdownMenuEntries: entries,
      validator: (StarPower? value) {
        if(value == null) {
          return 'Valeur manquante';
        }
        return null;
      },
      onSelected: (StarPower? p) => onSelected(p),
    );
  }
}