import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../classes/character/base.dart';
import '../../../../classes/character/injury.dart';
import '../../../../classes/human_character.dart';
import '../change_stream.dart';
import '../widget_group_container.dart';

class CharacterEditInjuriesFormField extends FormField<InjuryManager> {
  CharacterEditInjuriesFormField({
    super.key,
    required HumanCharacter character,
    required StreamController<CharacterChange> changeStreamController,
    FormFieldSetter<InjuryManager>? onSaved,
  })
  : super(
    initialValue: InjuryManager.getInjuryManagerForAbilities(
        resistance: character.ability(Ability.resistance),
        volonte: character.ability(Ability.volonte),
        source: character.injuries,
      ),
    autovalidateMode: AutovalidateMode.disabled,
    builder: (FormFieldState<InjuryManager> state) {
      return CharacterEditInjuriesWidget(
        character: character,
        changeStreamController: changeStreamController,
        initialManager: state.value,
        onChanged: (InjuryManager m) {
          state.didChange(m);
        },
      );
    }
  );
}

class CharacterEditInjuriesWidget extends StatefulWidget {
  const CharacterEditInjuriesWidget({
    super.key,
    required this.character,
    required this.changeStreamController,
    this.initialManager,
    this.onChanged,
  });

  final HumanCharacter character;
  final StreamController<CharacterChange> changeStreamController;
  final InjuryManager? initialManager;
  final void Function(InjuryManager)? onChanged;

  @override
  State<CharacterEditInjuriesWidget> createState() => _CharacterEditInjuriesWidgetState();
}

class _CharacterEditInjuriesWidgetState extends State<CharacterEditInjuriesWidget> {
  late int currentResistance;
  late int currentVolonte;
  late InjuryManager currentManager;

  @override
  void initState() {
    super.initState();

    currentResistance = widget.character.ability(Ability.resistance);
    currentVolonte = widget.character.ability(Ability.volonte);
    currentManager = widget.initialManager ?? widget.character.injuries;

    widget.changeStreamController.stream.listen((CharacterChange change) {
      if(
          change.item == CharacterChangeItem.ability
          && change.value != null
          && change.value is CharacterAbilityChangeValue
      ) {
        var v = change.value as CharacterAbilityChangeValue;
        if(v.ability == Ability.resistance) {
          currentResistance = v.value;
          updateInjuryManager();
        }
        else if(v.ability == Ability.volonte) {
          currentVolonte = v.value;
          updateInjuryManager();
        }
      }
    });
  }

  void updateInjuryManager() {
    setState(() {
      currentManager = InjuryManager.getInjuryManagerForAbilities(
        resistance: currentResistance,
        volonte: currentVolonte,
        source: currentManager,
      );
    });
    widget.onChanged?.call(currentManager);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    List<Widget> levelWidgets = <Widget>[];
    for(var level in currentManager.levels()) {
      levelWidgets.add(
          _InjuryLevelInputWidget(
            level: level,
            count: currentManager.count(level),
            increase: () {
              setState(() {
                currentManager.setDamage(level.start + 1);
              });
            },
            decrease: () {
              setState(() {
                currentManager.heal(level);
              });
            },
          )
      );
    }

    return WidgetGroupContainer(
      title: Text(
        'Blessures',
        style: theme.textTheme.bodyMedium!.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...levelWidgets,
        ],
      ),
    );
  }
}

class _InjuryLevelInputWidget extends StatelessWidget {
  const _InjuryLevelInputWidget({
    required this.level,
    required this.count,
    required this.increase,
    required this.decrease,
    this.circlesDiameter = 16.0,
  });

  final InjuryLevel level;
  final int count;
  final void Function() increase;
  final void Function() decrease;
  final double circlesDiameter;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    List<Widget> circles = <Widget>[];
    var colored = 0;

    for(var i = 0; i < level.capacity; ++i) {
      if(colored < count) {
        circles.add(
            Container(
              margin: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
              width: circlesDiameter,
              height: circlesDiameter,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(circlesDiameter / 2),
              ),
            )
        );
        ++colored;
      }
      else {
        circles.add(
            Container(
              margin: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
              width: circlesDiameter,
              height: circlesDiameter,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceBright,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(circlesDiameter / 2),
              ),
            )
        );
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 80.0,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              level.title,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        IconButton(
          icon: const Icon(Icons.remove),
          style: IconButton.styleFrom(
            minimumSize: const Size.square(28.0),
            maximumSize: const Size.square(28.0),
            iconSize: 12.0,
          ),
          onPressed: () => decrease(),
        ),
        const SizedBox(width: 4.0),
        ...circles,
        const SizedBox(width: 4.0),
        IconButton(
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(
            minimumSize: const Size.square(28.0),
            maximumSize: const Size.square(28.0),
            iconSize: 12.0,
          ),
          onPressed: () => increase(),
        ),
      ],
    );
  }
}