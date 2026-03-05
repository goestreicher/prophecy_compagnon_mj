import 'package:flutter/material.dart';

import '../../classes/entity/abilities.dart';
import '../../classes/entity/base.dart';
import 'num_input_widget.dart';
import 'widget_group_container.dart';

enum _CalculatorType {
  static,
  ability,
}

enum AttributeBasedCalculatorStaticType {
  int,
  double,
}

class AttributeBasedCalculatorEditWidget extends StatefulWidget {
  const AttributeBasedCalculatorEditWidget({
    super.key,
    required this.title,
    required this.onChanged,
    this.calculator,
    this.staticType = AttributeBasedCalculatorStaticType.int,
  });

  final String title;
  final void Function(AttributeBasedCalculator) onChanged;
  final AttributeBasedCalculator? calculator;
  final AttributeBasedCalculatorStaticType staticType;

  @override
  State<AttributeBasedCalculatorEditWidget> createState() => _AttributeBasedCalculatorEditWidgetState();
}

class _AttributeBasedCalculatorEditWidgetState extends State<AttributeBasedCalculatorEditWidget> {
  late _CalculatorType type;
  late AttributeBasedCalculator calculator;

  @override
  void initState() {
    super.initState();

    calculator = widget.calculator ?? AttributeBasedCalculator(static: 0.0);
    type = calculator.static != null ? _CalculatorType.static : _CalculatorType.ability;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget? calculatorWidget;
    if(type == _CalculatorType.static) {
      Widget? inputWidget;
      if(widget.staticType == AttributeBasedCalculatorStaticType.int) {
        inputWidget = NumIntInputWidget(
          label: 'Valeur',
          initialValue: calculator.static?.floor() ?? 0,
          minValue: 0,
          maxValue: 9999,
          onChanged: (int value) {
            calculator = AttributeBasedCalculator(
              static: value.toDouble(),
              dice: calculator.dice,
            );
            widget.onChanged(calculator);
          },
        );
      }
      else {
        inputWidget = NumDoubleInputWidget(
          label: 'Valeur',
          initialValue: calculator.static ?? 0.0,
          minValue: 0.0,
          maxValue: 9999.0,
          onChanged: (double value) {
            calculator = AttributeBasedCalculator(
              static: value,
              dice: calculator.dice,
            );
            widget.onChanged(calculator);
          },
        );
      }

      calculatorWidget = SizedBox(
        width: 90,
        child: inputWidget,
      );
    }
    else {
      calculatorWidget = _AttributeTypeEditWidget(
        calculator: calculator,
        onAbilityChanged: (Ability a) {
          setState(() {
            calculator = AttributeBasedCalculator(
              ability: a,
              multiply: calculator.multiply,
              add: calculator.add,
              dice: calculator.dice,
            );
          });
          widget.onChanged(calculator);
        },
        onMultiplyChanged: (int value) {
          setState(() {
            calculator = AttributeBasedCalculator(
              ability: calculator.ability,
              multiply: value,
              add: calculator.add,
              dice: calculator.dice,
            );
          });
          widget.onChanged(calculator);
        },
        onAddChanged: (int value) {
          setState(() {
            calculator = AttributeBasedCalculator(
              ability: calculator.ability,
              multiply: calculator.multiply,
              add: value,
              dice: calculator.dice,
            );
          });
          widget.onChanged(calculator);
        },
        onDiceChanged: (int value) {
          setState(() {
            calculator = AttributeBasedCalculator(
              ability: calculator.ability,
              multiply: calculator.multiply,
              add: calculator.add,
              dice: value,
            );
          });
          widget.onChanged(calculator);
        },
      );
    }

    return WidgetGroupContainer(
      title: Text(
        widget.title,
        style: theme.textTheme.bodySmall!.copyWith(
          color: Colors.black87,
        )
      ),
      child: Row(
        spacing: 12.0,
        children: [
          DropdownMenu(
            initialSelection: type,
            requestFocusOnTap: true,
            label: const Text('Type'),
            textStyle: theme.textTheme.bodySmall,
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(),
              isCollapsed: true,
              constraints: BoxConstraints(maxHeight: 36.0),
              contentPadding: EdgeInsets.all(12.0),
            ),
            dropdownMenuEntries: [
              DropdownMenuEntry(value: _CalculatorType.static, label: 'Statique'),
              DropdownMenuEntry(value: _CalculatorType.ability, label: 'Attribut'),
            ],
            onSelected: (_CalculatorType? t) {
              if(t == null) return;

              if(t == _CalculatorType.static && type == _CalculatorType.ability) {
                calculator = AttributeBasedCalculator(static: 0.0);
                widget.onChanged(calculator);
              }
              else if(t == _CalculatorType.ability && type == _CalculatorType.static) {
                calculator = AttributeBasedCalculator(ability: Ability.force);
                widget.onChanged(calculator);
              }

              setState(() {
                type = t;
              });
            },
          ),
          calculatorWidget,
        ],
      ),
    );
  }
}

class _AttributeTypeEditWidget extends StatefulWidget {
  const _AttributeTypeEditWidget({
    required this.calculator,
    required this.onAbilityChanged,
    required this.onMultiplyChanged,
    required this.onAddChanged,
    required this.onDiceChanged,
  });

  final AttributeBasedCalculator calculator;
  final void Function(Ability) onAbilityChanged;
  final void Function(int) onMultiplyChanged;
  final void Function(int) onAddChanged;
  final void Function(int) onDiceChanged;

  @override
  State<_AttributeTypeEditWidget> createState() => _AttributeTypeEditWidgetState();
}

class _AttributeTypeEditWidgetState extends State<_AttributeTypeEditWidget> {
  late Ability ability;
  late int multiply;
  late int add;
  late int dice;

  @override
  void initState() {
    super.initState();

    ability = widget.calculator.ability!;
    multiply = widget.calculator.multiply;
    add = widget.calculator.add;
    dice = widget.calculator.dice;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      spacing: 12.0,
      children: [
        DropdownMenu(
          initialSelection: widget.calculator.ability!,
          requestFocusOnTap: true,
          textStyle: theme.textTheme.bodySmall,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(),
            isCollapsed: true,
            constraints: BoxConstraints(maxHeight: 36.0),
            contentPadding: EdgeInsets.all(12.0),
          ),
          dropdownMenuEntries: Ability.values
              .map((Ability a) => DropdownMenuEntry(value: a, label: a.short))
              .toList(),
          onSelected: (Ability? a) {
            if(a == null) return;
            widget.onAbilityChanged(a);
          },
        ),
        Text('x'),
        SizedBox(
          width: 70,
          child: NumIntInputWidget(
            initialValue: multiply,
            minValue: 1,
            maxValue: 10,
            onChanged: (int value) => widget.onMultiplyChanged(value),
          ),
        ),
        Text('+'),
        SizedBox(
          width: 70,
          child: NumIntInputWidget(
            initialValue: add,
            minValue: 0,
            maxValue: 9999,
            onChanged: (int value) => widget.onAddChanged(value),
          ),
        ),
        Text('+'),
        SizedBox(
          width: 70,
          child: NumIntInputWidget(
            initialValue: dice,
            minValue: 0,
            maxValue: 9999,
            onChanged: (int value) => widget.onDiceChanged(value),
          ),
        ),
        Text('D10'),
      ],
    );
  }
}