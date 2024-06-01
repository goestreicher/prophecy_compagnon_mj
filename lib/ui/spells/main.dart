import 'package:flutter/material.dart';

import '../../classes/magic.dart';

class SpellsMainPage extends StatefulWidget {
  const SpellsMainPage({ super.key });

  @override
  State<SpellsMainPage> createState() => _SpellsMainPageState();
}

class _SpellsMainPageState extends State<SpellsMainPage> {
  MagicSphere? _selectedSphere;
  MagicSpell? _selectedSpell;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  'Sphère',
                  style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                for(var sphere in MagicSphere.values)
                  _SphereSelectionButton(
                    sphere: sphere,
                    selected: _selectedSphere == sphere,
                    onPressed: () {
                      if(_selectedSphere == sphere) return;
                      setState(() {
                        _selectedSphere = sphere;
                        _selectedSpell = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
        if(_selectedSphere != null)
          _SphereMagicSpellsListWidget(
            sphere: _selectedSphere!,
            onSelected: (MagicSpell spell) {
              setState(() {
                _selectedSpell = spell;
              });
            },
            selected: _selectedSpell,
          ),
        if(_selectedSpell != null)
          Expanded(child: _MagicSpellDisplayWidget(spell: _selectedSpell!)),
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
              color: theme.colorScheme.primary.withOpacity(0.5),
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

class _SphereMagicSpellsListWidget extends StatefulWidget {
  const _SphereMagicSpellsListWidget({
    required this.sphere,
    required this.onSelected,
    this.selected,
  });

  final MagicSphere sphere;
  final void Function(MagicSpell) onSelected;
  final MagicSpell? selected;

  @override
  State<_SphereMagicSpellsListWidget> createState() => _SphereMagicSpellsListWidgetState();
}

class _SphereMagicSpellsListWidgetState extends State<_SphereMagicSpellsListWidget> {
  final TextEditingController _filterSkillController = TextEditingController();
  MagicSkill? _filterSkill;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            DropdownMenu(
              controller: _filterSkillController,
              initialSelection: _filterSkill,
              label: const Text('Discipline'),
              requestFocusOnTap: true,
              textStyle: theme.textTheme.bodySmall,
              onSelected: (MagicSkill? skill) {
                setState(() {
                  _filterSkill = skill;
                });
              },
              leadingIcon: InkWell(
                onTap: _filterSkill == null ? null : () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _filterSkillController.clear();
                    _filterSkill = null;
                  });
                },
                child: Opacity(
                  opacity: _filterSkill == null ? 0.4 : 1.0,
                  child: const Icon(
                    Icons.cancel,
                    size: 16.0,
                  ),
                )
              ),
              dropdownMenuEntries: MagicSkill.values
                .map((MagicSkill skill) => DropdownMenuEntry(value: skill, label: skill.title))
                .toList(),
            ),
            const SizedBox(height: 4.0),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Niveau 1',
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            for(var spell in MagicSpell.spells(sphere: widget.sphere, level: 1).where((MagicSpell spell) => _filterSkill == null || spell.skill == _filterSkill))
              SizedBox(
                width: 300.0,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  color: widget.selected == spell ?
                    theme.colorScheme.surfaceVariant :
                    null,
                  child: InkWell(
                    onTap: () {
                      widget.onSelected(spell);
                    },
                    child: ListTile(
                      title: Text(
                        spell.name,
                        style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Niveau 2',
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            for(var spell in MagicSpell.spells(sphere: widget.sphere, level: 2).where((MagicSpell spell) => _filterSkill == null || spell.skill == _filterSkill))
              SizedBox(
                width: 300.0,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  color: widget.selected == spell ?
                  theme.colorScheme.surfaceVariant :
                  null,
                  child: InkWell(
                    onTap: () {
                      widget.onSelected(spell);
                    },
                    child: ListTile(
                      title: Text(
                        spell.name,
                        style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Niveau 3',
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            for(var spell in MagicSpell.spells(sphere: widget.sphere, level: 3).where((MagicSpell spell) => _filterSkill == null || spell.skill == _filterSkill))
              SizedBox(
                width: 300.0,
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  color: widget.selected == spell ?
                  theme.colorScheme.surfaceVariant :
                  null,
                  child: InkWell(
                    onTap: () {
                      widget.onSelected(spell);
                    },
                    child: ListTile(
                      title: Text(
                        spell.name,
                        style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ),
              )
          ],
        )
      )
    );
  }
}

class _MagicSpellDisplayWidget extends StatelessWidget {
  const _MagicSpellDisplayWidget({ required this.spell });

  final MagicSpell spell;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 24.0, 12.0, 12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                spell.name,
                style: theme.textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            RichText(
                text: TextSpan(
                    text: 'Discipline : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: spell.skill.title,
                        style: theme.textTheme.bodyLarge,
                      )
                    ]
                )
            ),
            RichText(
                text: TextSpan(
                    text: 'Coût : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: spell.cost.toString(),
                        style: theme.textTheme.bodyLarge,
                      )
                    ]
                )
            ),
            RichText(
                text: TextSpan(
                    text: 'Difficulté : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: spell.difficulty.toString(),
                        style: theme.textTheme.bodyLarge,
                      )
                    ]
                )
            ),
            RichText(
                text: TextSpan(
                    text: "Temps d'incantation : ",
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: '${spell.castingDuration.toString()} ${spell.castingDurationUnit.title}${spell.castingDuration > 1 ? "s" : ""}',
                        style: theme.textTheme.bodyLarge,
                      )
                    ]
                )
            ),
            RichText(
                text: TextSpan(
                    text: 'Complexité : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: spell.complexity.toString(),
                        style: theme.textTheme.bodyLarge,
                      )
                    ]
                )
            ),
            RichText(
                text: TextSpan(
                    text: 'Clés : ',
                    style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: spell.keys.join(', '),
                        style: theme.textTheme.bodyLarge,
                      )
                    ]
                )
            ),
            const SizedBox(height: 8.0),
            Text(
              'Description',
              style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              spell.description,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      )
    );
  }
}