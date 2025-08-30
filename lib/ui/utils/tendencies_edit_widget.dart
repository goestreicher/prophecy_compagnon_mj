import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/human_character.dart';
import 'measure_widget_offscreen.dart';

/*
    Some data about the full-size tendencies background image
      - width: 490
      - height: 486
      - center of the dragon circle: 245,158
      - center of the fatality circle: 146,332
      - center of the human circle: 346,332
 */

const _backgroundSize = Size(490, 486);
const _dragonCenter = Size(245,158);
const _fatalityCenter = Size(146,332);
const _humanCenter = Size(346,332);
const _widgetPadding = 8.0;
// 12.0 on top, 8.0 on bottom, because TextFormField decoration is dense and has a border
//   source: https://api.flutter.dev/flutter/material/InputDecoration/contentPadding.html
const _valuesEditVerticalPadding = 20.0;

class TendenciesEditWidget extends StatefulWidget {
  const TendenciesEditWidget({
    super.key,
    required this.tendencies,
    this.backgroundWidth = 260,
    this.editValues = true,
    this.showCircles = false,
  });

  final CharacterTendencies tendencies;
  final int backgroundWidth;
  final bool editValues;
  final bool showCircles;

  @override
  State<TendenciesEditWidget> createState() => _TendenciesEditWidgetState();
}

class _TendenciesEditWidgetState extends State<TendenciesEditWidget> {
  final TextEditingController tendencyDragonController = TextEditingController();
  final TextEditingController tendencyFatalityController = TextEditingController();
  final TextEditingController tendencyHumanController = TextEditingController();

  @override
  void initState() {
    super.initState();

    tendencyDragonController.text = widget.tendencies.dragon.value.toString();
    tendencyFatalityController.text = widget.tendencies.fatality.value.toString();
    tendencyHumanController.text = widget.tendencies.human.value.toString();
  }

  Widget getValueWidget({
    required TextEditingController controller,
    required TextStyle textStyle,
    required void Function(String?) onChanged,
  }) {
    if(widget.editValues) {
      return SizedBox(
        width: 40,
        child: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            // isCollapsed: true,
            // contentPadding: EdgeInsets.all(_valuesEditPadding),
            error: null,
            errorText: null,
          ),
          style: textStyle,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (String? value) {
            if(value == null || value.isEmpty) return 'Valeur manquante';
            int? input = int.tryParse(value);
            if(input == null) return 'Pas un nombre';
            if(input < 0) return 'Nombre >= 0';
            if(input > 5) return 'Nombre <= 5';
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (String? value) => onChanged(value),
        ),
      );
    }
    else {
      return Text(
        controller.text,
        style: textStyle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var valueTextStyle = theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold);
    var backgroundDisplayRatio = widget.backgroundWidth / _backgroundSize.width;

    var textWidgetSize = measureWidgetOffscreen(
      Text('5', style: valueTextStyle)
    );
    if(widget.editValues) {
      // add padding only once, and +2 for the borders
      textWidgetSize = Size(40.0, textWidgetSize.height + _valuesEditVerticalPadding + 2);
    }

    var circlesWidgetSize = measureWidgetOffscreen(
      _TendencyCirclesInputWidget(
        count: 0,
        onChanged: (int count) {},
        onTendencyIncreased: () {},
        onTendencyDecreased: () {},
      )
    );

    var circlesVerticalOffset = 0.0;
    var circlesHorizontalOffset = 0.0;
    var bottomExtraPadding = 0.0;
    if(widget.showCircles) {
      circlesVerticalOffset = 34.0;
      circlesHorizontalOffset = 60.0;
      bottomExtraPadding = 16.0;
    }

    return SizedBox(
      width: widget.backgroundWidth + 2 * _widgetPadding + 2 * circlesHorizontalOffset,
      height: widget.backgroundWidth + 2 * _widgetPadding + 2 * circlesVerticalOffset - bottomExtraPadding,
      child: Padding(
        padding: const EdgeInsets.all(_widgetPadding),
        child: Stack(
          children: [
            Positioned(
              top: circlesVerticalOffset,
              left: circlesHorizontalOffset,
              child: Image.asset(
                'assets/images/tendencies/background_tendencies.png',
                width: widget.backgroundWidth.toDouble(),
              )
            ),
            Positioned(
              top: (_dragonCenter.height * backgroundDisplayRatio) + circlesVerticalOffset - textWidgetSize.height / 2,
              left: (_dragonCenter.width * backgroundDisplayRatio) + circlesHorizontalOffset - textWidgetSize.width / 2,
              child: SizedBox(
                width: 40,
                child: getValueWidget(
                  controller: tendencyDragonController,
                  textStyle: valueTextStyle,
                  onChanged: (String? value) {
                    if(value == null) return;
                    int? input = int.tryParse(value);
                    if(input == null) return;
                    widget.tendencies.dragon.value = input;
                  },
                ),
              ),
            ),
            if(widget.showCircles)
              Positioned(
                top: 0,
                left: (widget.backgroundWidth - circlesWidgetSize.width) / 2 + circlesHorizontalOffset,
                child: _TendencyCirclesInputWidget(
                  count: widget.tendencies.dragon.circles,
                  onChanged: (int count) {
                    setState(() {
                      widget.tendencies.dragon.circles = count;
                    });
                  },
                  onTendencyIncreased: () {
                    if(widget.tendencies.dragon.value < 5) {
                      setState(() {
                        widget.tendencies.dragon.value += 1;
                        tendencyDragonController.text = widget.tendencies.dragon.value.toString();
                        widget.tendencies.dragon.circles = 0;
                      });
                    }
                  },
                  onTendencyDecreased: () {
                    if(widget.tendencies.dragon.value > 0) {
                      setState(() {
                        widget.tendencies.dragon.value -= 1;
                        tendencyDragonController.text = widget.tendencies.dragon.value.toString();
                        widget.tendencies.dragon.circles = 10;
                      });
                    }
                  },
                ),
              ),
            Positioned(
              top: (_fatalityCenter.height * backgroundDisplayRatio) + circlesVerticalOffset - textWidgetSize.height / 2,
              left: (_fatalityCenter.width * backgroundDisplayRatio) + circlesHorizontalOffset - textWidgetSize.width / 2,
              child: SizedBox(
                width: 40,
                child: getValueWidget(
                  controller: tendencyFatalityController,
                  textStyle: valueTextStyle,
                  onChanged: (String? value) {
                    if(value == null) return;
                    int? input = int.tryParse(value);
                    if(input == null) return;
                    widget.tendencies.fatality.value = input;
                  },
                ),
              ),
            ),
            if(widget.showCircles)
              Positioned(
                bottom: 0,
                left: 0,
                child: _TendencyCirclesInputWidget(
                  count: widget.tendencies.fatality.circles,
                  onChanged: (int count) {
                    setState(() {
                      widget.tendencies.fatality.circles = count;
                    });
                  },
                  onTendencyIncreased: () {
                    if(widget.tendencies.fatality.value < 5) {
                      setState(() {
                        widget.tendencies.fatality.value += 1;
                        tendencyFatalityController.text = widget.tendencies.fatality.value.toString();
                        widget.tendencies.fatality.circles = 0;
                      });
                    }
                  },
                  onTendencyDecreased: () {
                    if(widget.tendencies.fatality.value > 0) {
                      setState(() {
                        widget.tendencies.fatality.value -= 1;
                        tendencyFatalityController.text = widget.tendencies.fatality.value.toString();
                        widget.tendencies.fatality.circles = 10;
                      });
                    }
                  },
                ),
              ),
            Positioned(
              top: (_humanCenter.height * backgroundDisplayRatio) + circlesVerticalOffset - textWidgetSize.height / 2,
              left: (_humanCenter.width * backgroundDisplayRatio) + circlesHorizontalOffset - textWidgetSize.width / 2,
              child: SizedBox(
                width: 40,
                child: getValueWidget(
                  controller: tendencyHumanController,
                  textStyle: valueTextStyle,
                  onChanged: (String? value) {
                    if(value == null) return;
                    int? input = int.tryParse(value);
                    if(input == null) return;
                    widget.tendencies.human.value = input;
                  },
                ),
              ),
            ),
            if(widget.showCircles)
              Positioned(
                bottom: 0,
                left: widget.backgroundWidth + circlesHorizontalOffset - circlesWidgetSize.width / 2,
                child: _TendencyCirclesInputWidget(
                  count: widget.tendencies.human.circles,
                  onChanged: (int count) {
                    setState(() {
                      widget.tendencies.human.circles = count;
                    });
                  },
                  onTendencyIncreased: () {
                    if(widget.tendencies.human.value < 5) {
                      setState(() {
                        widget.tendencies.human.value += 1;
                        tendencyHumanController.text = widget.tendencies.human.value.toString();
                        widget.tendencies.human.circles = 0;
                      });
                    }
                  },
                  onTendencyDecreased: () {
                    if(widget.tendencies.human.value > 0) {
                      setState(() {
                        widget.tendencies.human.value -= 1;
                        tendencyHumanController.text = widget.tendencies.human.value.toString();
                        widget.tendencies.human.circles = 10;
                      });
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TendencyCirclesInputWidget extends StatelessWidget {
  const _TendencyCirclesInputWidget({
    required this.count,
    required this.onChanged,
    required this.onTendencyIncreased,
    required this.onTendencyDecreased,
  });

  final int count;
  final void Function(int) onChanged;
  final void Function() onTendencyIncreased;
  final void Function() onTendencyDecreased;

  void _increase() {
    if(count == 10) {
      onTendencyIncreased();
    }
    else {
      onChanged(count + 1);
    }
  }

  void _decrease() {
    if(count == 0) {
      onTendencyDecreased();
    }
    else {
      onChanged(count - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    var colored = 0;
    var firstRow = <Widget>[];
    var secondRow = <Widget>[];
    var circleDiameter = 12.0;

    for(var i = 0; i < 5; ++i) {
      if(colored < count) {
        firstRow.add(
          Container(
            margin: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
            width: circleDiameter,
            height: circleDiameter,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(circleDiameter/2),
            ),
          )
        );
        ++colored;
      }
      else {
        firstRow.add(
          Container(
            margin: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
            width: circleDiameter,
            height: circleDiameter,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(circleDiameter/2),
            ),
          )
        );
      }
    }

    for(var i = 0; i < 5; ++i) {
      if(colored < count) {
        secondRow.add(
          Container(
            margin: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
            width: circleDiameter,
            height: circleDiameter,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(circleDiameter),
            ),
          )
        );
        ++colored;
      }
      else {
        secondRow.add(
          Container(
            margin: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
            width: circleDiameter,
            height: circleDiameter,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(circleDiameter),
            ),
          )
        );
      }
    }

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          style: IconButton.styleFrom(
            minimumSize: const Size.square(28.0),
            maximumSize: const Size.square(28.0),
            iconSize: 12.0,
          ),
          onPressed: () => _decrease(),
        ),
        const SizedBox(width: 4.0),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ...firstRow
              ],
            ),
            const SizedBox(height: 2.0),
            Row(
              children: [
                ...secondRow
              ],
            ),
          ],
        ),
        const SizedBox(width: 4.0),
        IconButton(
          icon: const Icon(Icons.add),
          style: IconButton.styleFrom(
            minimumSize: const Size.square(28.0),
            maximumSize: const Size.square(28.0),
            iconSize: 14.0,
          ),
          onPressed: () => _increase(),
        )
      ],
    );
  }
}