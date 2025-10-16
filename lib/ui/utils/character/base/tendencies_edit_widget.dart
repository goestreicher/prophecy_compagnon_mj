import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../classes/character/tendencies.dart';
import '../../measure_widget_offscreen.dart';

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

class TendenciesEditWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var valueTextStyle = theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold);
    var backgroundDisplayRatio = backgroundWidth / _backgroundSize.width;

    var textWidgetSize = measureWidgetOffscreen(
      Text('5', style: valueTextStyle)
    );
    if(editValues) {
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
    if(showCircles) {
      circlesVerticalOffset = 34.0;
      circlesHorizontalOffset = 60.0;
      bottomExtraPadding = 16.0;
    }

    return SizedBox(
      width: backgroundWidth + 2 * _widgetPadding + 2 * circlesHorizontalOffset,
      height: backgroundWidth + 2 * _widgetPadding + 2 * circlesVerticalOffset - bottomExtraPadding,
      child: Padding(
        padding: const EdgeInsets.all(_widgetPadding),
        child: Stack(
          children: [
            Positioned(
              top: circlesVerticalOffset,
              left: circlesHorizontalOffset,
              child: Image.asset(
                'assets/images/tendencies/background_tendencies.png',
                width: backgroundWidth.toDouble(),
              )
            ),
            Positioned(
              top: (_dragonCenter.height * backgroundDisplayRatio) + circlesVerticalOffset - textWidgetSize.height / 2,
              left: (_dragonCenter.width * backgroundDisplayRatio) + circlesHorizontalOffset - textWidgetSize.width / 2,
              child: SizedBox(
                width: 40,
                child: ValueListenableBuilder(
                  valueListenable: tendencies.dragon.valueNotifier,
                  builder: (BuildContext context, int value, _) {
                    return _TendencyValueInputWidget(
                      value: value,
                      valueTextStyle: valueTextStyle,
                      editable: editValues,
                      onChanged: (int v) => tendencies.dragon.value = v,
                    );
                  }
                ),
              ),
            ),
            if(showCircles)
              Positioned(
                top: 0,
                left: (backgroundWidth - circlesWidgetSize.width) / 2 + circlesHorizontalOffset,
                child: ValueListenableBuilder(
                  valueListenable: tendencies.dragon.circlesNotifier,
                  builder: (BuildContext context, int value, _) {
                    return _TendencyCirclesInputWidget(
                      count: value,
                      onChanged: (int count) {
                        tendencies.dragon.circles = count;
                      },
                      onTendencyIncreased: () {
                        if(tendencies.dragon.value < 5) {
                          tendencies.dragon.value += 1;
                          tendencies.dragon.circles = 0;
                        }
                      },
                      onTendencyDecreased: () {
                        if(tendencies.dragon.value > 0) {
                          tendencies.dragon.value -= 1;
                          tendencies.dragon.circles = 10;
                        }
                      },
                    );
                  }
                ),
              ),
            Positioned(
              top: (_fatalityCenter.height * backgroundDisplayRatio) + circlesVerticalOffset - textWidgetSize.height / 2,
              left: (_fatalityCenter.width * backgroundDisplayRatio) + circlesHorizontalOffset - textWidgetSize.width / 2,
              child: SizedBox(
                width: 40,
                child: ValueListenableBuilder(
                  valueListenable: tendencies.fatality.valueNotifier,
                  builder: (BuildContext context, int value, _) {
                    return _TendencyValueInputWidget(
                      value: value,
                      valueTextStyle: valueTextStyle,
                      editable: editValues,
                      onChanged: (int v) => tendencies.fatality.value = v,
                    );
                  }
                ),
              ),
            ),
            if(showCircles)
              Positioned(
                bottom: 0,
                left: 0,
                child: ValueListenableBuilder(
                  valueListenable: tendencies.fatality.circlesNotifier,
                  builder: (BuildContext context, int value, _) {
                    return _TendencyCirclesInputWidget(
                      count: value,
                      onChanged: (int count) {
                        tendencies.fatality.circles = count;
                      },
                      onTendencyIncreased: () {
                        if(tendencies.fatality.value < 5) {
                          tendencies.fatality.value += 1;
                          tendencies.fatality.circles = 0;
                        }
                      },
                      onTendencyDecreased: () {
                        if(tendencies.fatality.value > 0) {
                          tendencies.fatality.value -= 1;
                          tendencies.fatality.circles = 10;
                        }
                      },
                    );
                  }
                ),
              ),
            Positioned(
              top: (_humanCenter.height * backgroundDisplayRatio) + circlesVerticalOffset - textWidgetSize.height / 2,
              left: (_humanCenter.width * backgroundDisplayRatio) + circlesHorizontalOffset - textWidgetSize.width / 2,
              child: SizedBox(
                width: 40,
                child: ValueListenableBuilder(
                  valueListenable: tendencies.human.valueNotifier,
                  builder: (BuildContext context, int value, _) {
                    return _TendencyValueInputWidget(
                      value: value,
                      valueTextStyle: valueTextStyle,
                      editable: editValues,
                      onChanged: (int v) => tendencies.human.value = v,
                    );
                  }
                ),
              ),
            ),
            if(showCircles)
              Positioned(
                bottom: 0,
                left: backgroundWidth + circlesHorizontalOffset - circlesWidgetSize.width / 2,
                child: ValueListenableBuilder(
                  valueListenable: tendencies.human.circlesNotifier,
                  builder: (BuildContext context, int value, _) {
                    return _TendencyCirclesInputWidget(
                      count: value,
                      onChanged: (int count) {
                        tendencies.human.circles = count;
                      },
                      onTendencyIncreased: () {
                        if(tendencies.human.value < 5) {
                          tendencies.human.value += 1;
                          tendencies.human.circles = 0;
                        }
                      },
                      onTendencyDecreased: () {
                        if(tendencies.human.value > 0) {
                          tendencies.human.value -= 1;
                          tendencies.human.circles = 10;
                        }
                      },
                    );
                  }
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TendencyValueInputWidget extends StatelessWidget {
  const _TendencyValueInputWidget({
    required this.value,
    required this.valueTextStyle,
    required this.editable,
    required this.onChanged,
  });

  final int value;
  final TextStyle valueTextStyle;
  final bool editable;
  final void Function(int) onChanged;

  Widget getValueWidget() {
    if(editable) {
      return SizedBox(
        width: 40,
        child: TextFormField(
          key: UniqueKey(),
          initialValue: value.toString(),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            error: null,
            errorText: null,
            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          ),
          style: valueTextStyle,
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
          onChanged: (String value) => onChanged(int.parse(value)),
        ),
      );
    }
    else {
      return Text(
        value.toString(),
        style: valueTextStyle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: getValueWidget(),
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