import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/human_character.dart';

class TendenciesEditWidget extends StatefulWidget {
  const TendenciesEditWidget({
    super.key,
    required this.tendencies,
    this.showCircles = false,
  });

  final CharacterTendencies tendencies;
  final bool showCircles;

  @override
  State<TendenciesEditWidget> createState() => _TendenciesEditWidgetState();
}

class _TendenciesEditWidgetState extends State<TendenciesEditWidget> {
  final TextEditingController _tendencyDragonController = TextEditingController();
  final TextEditingController _tendencyFatalityController = TextEditingController();
  final TextEditingController _tendencyHumanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tendencyDragonController.text = widget.tendencies.dragon.value.toString();
    _tendencyFatalityController.text = widget.tendencies.fatality.value.toString();
    _tendencyHumanController.text = widget.tendencies.human.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var circlesVerticalOffset = 0.0;
    var circlesHorizontalOffset = 0.0;
    var bottomExtraPadding = 0.0;
    if(widget.showCircles) {
      circlesVerticalOffset = 34.0;
      circlesHorizontalOffset = 60.0;
      bottomExtraPadding = 16.0;
    }

    return SizedBox(
      width: 260 + 2 * circlesHorizontalOffset,
      height: 260 + 2 * circlesVerticalOffset - bottomExtraPadding,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
              top: circlesVerticalOffset,
              left: circlesHorizontalOffset,
              child: Image.asset(
                'assets/images/tendencies/background_tendencies.png',
                width: 244,
              )
            ),
            Positioned(
              top: 59 + circlesVerticalOffset,
              left: 103 + circlesHorizontalOffset,
              child: SizedBox(
                width: 40,
                child: TextFormField(
                  controller: _tendencyDragonController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                    error: null,
                    errorText: null,
                  ),
                  style: theme.textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
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
                left: 54 + circlesHorizontalOffset,
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
                        _tendencyDragonController.text = widget.tendencies.dragon.value.toString();
                        widget.tendencies.dragon.circles = 0;
                      });
                    }
                  },
                  onTendencyDecreased: () {
                    if(widget.tendencies.dragon.value > 0) {
                      setState(() {
                        widget.tendencies.dragon.value -= 1;
                        _tendencyDragonController.text = widget.tendencies.dragon.value.toString();
                        widget.tendencies.dragon.circles = 10;
                      });
                    }
                  },
                ),
              ),
            Positioned(
              bottom: 65 + circlesVerticalOffset - bottomExtraPadding,
              left: 53 + circlesHorizontalOffset,
              child: SizedBox(
                width: 40,
                child: TextFormField(
                  controller: _tendencyFatalityController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                    error: null,
                    errorText: null,
                  ),
                  style: theme.textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
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
                        _tendencyFatalityController.text = widget.tendencies.fatality.value.toString();
                        widget.tendencies.fatality.circles = 0;
                      });
                    }
                  },
                  onTendencyDecreased: () {
                    if(widget.tendencies.fatality.value > 0) {
                      setState(() {
                        widget.tendencies.fatality.value -= 1;
                        _tendencyFatalityController.text = widget.tendencies.fatality.value.toString();
                        widget.tendencies.fatality.circles = 10;
                      });
                    }
                  },
                ),
              ),
            Positioned(
              bottom: 65 + circlesVerticalOffset - bottomExtraPadding,
              right: 51 + circlesHorizontalOffset,
              child: SizedBox(
                width: 40,
                child: TextFormField(
                  controller: _tendencyHumanController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                    error: null,
                    errorText: null,
                  ),
                  style: theme.textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
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
                right: 0,
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
                        _tendencyHumanController.text = widget.tendencies.human.value.toString();
                        widget.tendencies.human.circles = 0;
                      });
                    }
                  },
                  onTendencyDecreased: () {
                    if(widget.tendencies.human.value > 0) {
                      setState(() {
                        widget.tendencies.human.value -= 1;
                        _tendencyHumanController.text = widget.tendencies.human.value.toString();
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