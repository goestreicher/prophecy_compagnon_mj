import 'package:flutter/material.dart';

enum DefenseType {
  dodge(title: 'Esquive'),
  block(title: 'Parade'),
  blockShield(title: 'Parade (bouclier)'),
  ;

  final String title;

  const DefenseType({ required this.title });
}

class DefenseAction {
  DefenseAction({ required this.actionRank, required this.type });
  int actionRank;
  DefenseType type;
}

class DefenseActionSelectDialog extends StatefulWidget {
  const DefenseActionSelectDialog({
    super.key,
    required this.entityName,
    required this.ranks,
    required this.canBlock,
    required this.canBlockShield,
  });

  final String entityName;
  final List<int> ranks;
  final bool canBlock;
  final bool canBlockShield;

  @override
  State<DefenseActionSelectDialog> createState() => _DefenseActionSelectDialogState();
}

class _DefenseActionSelectDialogState extends State<DefenseActionSelectDialog> {
  final TextEditingController rankController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  DefenseType? defenseType;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return AlertDialog(
      title: Text("Action de défense - ${widget.entityName}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                'Action rang #',
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: DropdownMenu(
                  controller: rankController,
                  requestFocusOnTap: true,
                  expandedInsets: EdgeInsets.zero,
                  dropdownMenuEntries: widget.ranks
                    .map((int r) => DropdownMenuEntry(
                      value: r,
                      label: r.toString()
                  ))
                  .toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Text(
                'Type de défense',
              ),
              const SizedBox(width: 8.0),
              const Spacer(),
              Expanded(
                child: DropdownMenu(
                  controller: typeController,
                  requestFocusOnTap: true,
                  onSelected: (DefenseType? t) {
                    defenseType = t;
                  },
                  dropdownMenuEntries: [
                    DropdownMenuEntry(
                        value: DefenseType.dodge,
                        label: DefenseType.dodge.title,
                    ),
                    DropdownMenuEntry(
                      value: DefenseType.block,
                      label: DefenseType.block.title,
                      enabled: widget.canBlock,
                    ),
                    DropdownMenuEntry(
                      value: DefenseType.blockShield,
                      label: DefenseType.blockShield.title,
                      enabled: widget.canBlockShield,
                    ),
                  ]
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Pas de défense'),
                ),
                const SizedBox(width: 12.0),
                ElevatedButton(
                  onPressed: () {
                    if(rankController.text.isEmpty) return;
                    if(defenseType == null) return;

                    var rank = int.tryParse(rankController.text);
                    if(rank == null) return;

                    Navigator.of(context).pop(
                      DefenseAction(
                        actionRank: rank,
                        type: defenseType!,
                      )
                    );
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