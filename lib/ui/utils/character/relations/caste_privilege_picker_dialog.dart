import 'package:flutter/material.dart';

import '../../../../classes/caste/base.dart';
import '../../../../classes/caste/character_caste.dart';
import '../../../../classes/caste/privileges.dart';

class CastePrivilegePickerDialog extends StatefulWidget {
  const CastePrivilegePickerDialog({
    super.key,
    this.defaultCaste,
    this.limitToDefaultCaste = false,
    this.maxCost,
    this.currentPrivileges = const <CharacterCastePrivilege>[],
  });

  final Caste? defaultCaste;
  final bool limitToDefaultCaste;
  final int? maxCost;
  final List<CharacterCastePrivilege> currentPrivileges;

  @override
  State<CastePrivilegePickerDialog> createState() => _CastePrivilegePickerDialogState();
}

class _CastePrivilegePickerDialogState extends State<CastePrivilegePickerDialog> {
  final TextEditingController casteController = TextEditingController();
  final TextEditingController privilegeController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  Set<CastePrivilege> assignedPrivileges = <CastePrivilege>{};
  Caste? currentCaste;
  final List<CastePrivilege> privilegesForCurrentCaste = <CastePrivilege>[];
  CastePrivilege? viewing;
  CastePrivilege? selected;
  List<int> costs = <int>[];
  int? cost;
  String? details;
  CharacterCastePrivilege? privilege;

  @override
  void initState() {
    super.initState();
    assignedPrivileges = widget.currentPrivileges
        .map((CharacterCastePrivilege p) => p.privilege)
        .toSet();
    currentCaste = widget.defaultCaste;
    _updateForCurrentCaste();
  }

  void _updateForCurrentCaste() {
    selected = null;
    cost = null;
    privilegesForCurrentCaste.clear();
    privilegeController.clear();
    if(currentCaste == null) return;
    privilegesForCurrentCaste.addAll(
      CastePrivilege.values
        .where(
          (CastePrivilege p) =>
            (
              p.caste == currentCaste
              ||  (p.caste == Caste.sansCaste && !widget.limitToDefaultCaste)
            )
            && (
              p.unique == false
              || !assignedPrivileges.contains(p)
            )
            && (
              widget.maxCost == null
              || p.cost.any((int c) => c <= widget.maxCost!)
            )
        )
    );
  }

  bool _canFinish() {
    if(selected == null) return false;
    if(costs.isEmpty) return false;
    if(cost == null && costs.length > 1) return false;
    if(selected!.requireDetails && details == null) return false;

    return true;
  }

  void _prepareFinish() {
    if(!_canFinish()) return;

    privilege = CharacterCastePrivilege(
      privilege: selected!,
      selectedCost: cost ?? costs[0],
      description: details,
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: const Text("Choix du Privilège"),
      content: SizedBox(
        width: 800,
        height: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(selected == null)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.0,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 16.0,
                        children: [
                          if(!widget.limitToDefaultCaste)
                            DropdownMenuFormField(
                              initialSelection: currentCaste,
                              label: const Text('Caste'),
                              requestFocusOnTap: true,
                              expandedInsets: EdgeInsets.zero,
                              onSelected: (Caste? c) {
                                if(c == currentCaste) return;
                                setState(() {
                                  currentCaste = c;
                                  selected = null;
                                  _updateForCurrentCaste();
                                });
                              },
                              dropdownMenuEntries: Caste.values
                                .map(
                                  (Caste c) => DropdownMenuEntry(
                                    value: c,
                                    label: c.title
                                  )
                                  )
                                  .toList(),
                              validator: (Caste? c) {
                                if(c == null) return 'Valeur manquante';
                                return null;
                              },
                            ),
                          Expanded(
                            child: ListView.separated(
                              itemCount: privilegesForCurrentCaste.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(privilegesForCurrentCaste[index].title),
                                  onTap: () => setState(() {
                                    viewing = privilegesForCurrentCaste[index];
                                  }),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) => Divider(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: viewing == null
                          ? SizedBox.shrink()
                          : _PrivilegeSelectionWidget(
                              privilege: viewing!,
                              onSelected: () => setState(() {
                                selected = viewing;
                                costs = selected!.cost
                                  .where((int c) => widget.maxCost == null || c <= widget.maxCost!)
                                  .toList();
      
                                if(_canFinish()) {
                                  _prepareFinish();
                                  Navigator.of(context, rootNavigator: true).pop(privilege!);
                                }
                              }),
                            ),
                    ),
                  ],
                ),
              ),
            if(selected != null && (costs.isNotEmpty || selected!.requireDetails))
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.0,
                  children: [
                    Expanded(
                      child: _PrivilegeSelectionWidget(
                        privilege: selected!,
                        costs: costs,
                        onSelected: () {},
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16.0,
                        children: [
                          Text(
                            'Privilège : ${selected!.title}',
                            style: theme.textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            spacing: 12.0,
                            children: [
                              Text(
                                'Coût',
                                style: theme.textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 80,
                                child: DropdownMenu<int>(
                                  requestFocusOnTap: true,
                                  expandedInsets: EdgeInsets.zero,
                                  textStyle: theme.textTheme.bodySmall,
                                  inputDecorationTheme: const InputDecorationTheme(
                                    border: OutlineInputBorder(),
                                    isCollapsed: true,
                                    constraints: BoxConstraints(maxHeight: 36.0),
                                    contentPadding: EdgeInsets.all(12.0),
                                  ),
                                  dropdownMenuEntries: costs
                                    .where((int c) => widget.maxCost == null || c <= widget.maxCost!)
                                    .map((int c) => DropdownMenuEntry(
                                      value: c, label: c.toString()
                                    ))
                                    .toList(),
                                  onSelected: (int? v) {
                                    setState(() {
                                      cost = v;
                                      _prepareFinish();
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                          if(selected!.requireDetails)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8.0,
                                children: [
                                  Text(
                                    'Détails',
                                    style: theme.textTheme.titleMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        isCollapsed: true,
                                        constraints: BoxConstraints(maxHeight: 36.0),
                                        contentPadding: EdgeInsets.all(12.0),
                                      ),
                                      minLines: 1,
                                      maxLines: 3,
                                      onChanged: (String? v) {
                                        if(v == null || v.isEmpty) return;
                                        setState(() {
                                          details = v;
                                          _prepareFinish();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: privilege == null ? null : () {
            Navigator.of(context, rootNavigator: true).pop(privilege!);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _PrivilegeSelectionWidget extends StatelessWidget {
  const _PrivilegeSelectionWidget({
    required this.privilege,
    this.costs,
    required this.onSelected,
  });

  final CastePrivilege privilege;
  final List<int>? costs;
  final void Function() onSelected;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => onSelected(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8.0,
              children: [
                Text(
                  '${privilege.title} (${(costs ?? privilege.cost).join("/")})',
                  style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  privilege.description,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}