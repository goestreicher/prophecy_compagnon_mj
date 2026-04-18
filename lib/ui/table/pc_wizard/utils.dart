import 'package:flutter/material.dart';

import '../../../classes/entity/skill.dart';
import '../../../classes/magic.dart';

class IntValueDragData {
  const IntValueDragData({
    required this.value,
    this.onAcceptedByAnotherTarget,
  });
  final int value;
  final void Function()? onAcceptedByAnotherTarget;
}

const intValueDraggablePillWidth = 50.0;
const intValueDraggablePillHeight = 35.0;

class IntValuePill extends StatelessWidget {
  const IntValuePill({
    super.key,
    required this.value,
  });

  final int value;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SizedBox(
      width: intValueDraggablePillWidth,
      height: intValueDraggablePillHeight,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Center(
          child: Text(
            value.toString(),
            style: theme.textTheme.bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class IntValueEmptyPill extends StatelessWidget {
  const IntValueEmptyPill({ super.key });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: intValueDraggablePillWidth,
      height: intValueDraggablePillHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.black12,
        ),
      ),
    );
  }
}

class IntValueDraggablePill extends StatelessWidget {
  const IntValueDraggablePill({
    super.key,
    required this.value,
    this.onAcceptedByOtherTarget,
  });

  final int value;
  final void Function()? onAcceptedByOtherTarget;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<IntValueDragData>(
      delay: Duration(milliseconds: 100),
      data: IntValueDragData(
        value: value,
        onAcceptedByAnotherTarget: onAcceptedByOtherTarget,
      ),
      feedback: IntValuePill(value: value),
      childWhenDragging: IntValueEmptyPill(),
      child: IntValuePill(value: value),
    );
  }
}

class IntValueDragTarget extends StatefulWidget {
  const IntValueDragTarget({
    super.key,
    this.initialValue,
    required this.onValueAccepted,
    required this.onValueRemoved,
  });

  final int? initialValue;
  final void Function(int) onValueAccepted;
  final void Function(int) onValueRemoved;

  @override
  State<IntValueDragTarget> createState() => _IntValueDragTargetState();
}

class _IntValueDragTargetState extends State<IntValueDragTarget> {
  int? value;

  @override
  void initState() {
    super.initState();

    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    var finalWidget = Row(
      spacing: 4.0,
      children: [
        Container(
          width: intValueDraggablePillWidth,
          height: intValueDraggablePillHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.black12,
          ),
          child: value == null
            ? SizedBox.shrink()
            : IntValueDraggablePill(
                value: value!,
                onAcceptedByOtherTarget: () {
                  widget.onValueRemoved(value!);
                  setState(() {
                    value = null;
                  });
                },
              ),
        ),
        if(value != null)
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                widget.onValueRemoved(value!);
                setState(() {
                  value = null;
                });
              },
              child: Icon(
                Icons.cancel,
                size: 24.0,
              ),
            ),
          )
      ],
    );

    if(value != null) {
      return finalWidget;
    }
    else {
      return DragTarget(
        hitTestBehavior: HitTestBehavior.translucent,
        builder: (BuildContext context, List<dynamic> accepted, List<dynamic> rejected) {
          return finalWidget;
        },
        onWillAcceptWithDetails: (DragTargetDetails<IntValueDragData> details) {
          return value == null;
        },
        onAcceptWithDetails: (DragTargetDetails<IntValueDragData> details) {
          details.data.onAcceptedByAnotherTarget?.call();
          widget.onValueAccepted(details.data.value);
          setState(() {
            value = details.data.value;
          });
        },
      );
    }
  }
}

sealed class WizardSkillWrapper {
  String get title;
  bool get requiresImplementation;
  List<String> get implementations;
}

class WizardSkillInstance {
  WizardSkillInstance({
    required this.skill,
    this.implementation,
    this.specialization,
    required this.value,
  });

  WizardSkillWrapper skill;
  String? implementation;
  String? specialization;
  int value;

  String get title =>
    '${skill.title}${skill.requiresImplementation ? " (${implementation!})" : ""}';
}

class WizardStandardSkillWrapper implements WizardSkillWrapper {
  const WizardStandardSkillWrapper({ required this.skill });

  final Skill skill;

  @override
  String get title => skill.title;

  @override
  bool get requiresImplementation => skill.requireConcreteImplementation;

  @override
  List<String> get implementations => [];
}

class WizardMagicSphereSkillWrapper implements WizardSkillWrapper {
  const WizardMagicSphereSkillWrapper();

  @override
  String get title => "Sphère de magie";

  @override
  bool get requiresImplementation => true;

  @override
  List<String> get implementations =>
      MagicSphere.values
          .map((MagicSphere s) => s.title)
          .toList();
}

class WizardMagicSkillSkillWrapper implements WizardSkillWrapper {
  const WizardMagicSkillSkillWrapper();

  @override
  String get title => "Discipline de magie";

  @override
  bool get requiresImplementation => true;

  @override
  List<String> get implementations =>
      MagicSkill.values
          .map((MagicSkill s) => s.title)
          .toList();
}

int skillUpgradeCost(int from, int to, { double multiplier = 1.0}) {
  var res = ((to-from) * (from+1+to) / 2) * multiplier;
  if(from <= to) {
    return res.ceil();
  }
  else {
    return res.floor();
  }
}