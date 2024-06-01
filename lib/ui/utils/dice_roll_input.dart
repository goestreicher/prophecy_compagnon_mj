import 'package:flutter/material.dart';

class DiceRollInputWidget extends StatefulWidget {
  const DiceRollInputWidget({ super.key, this.initialValue, required this.onValueSelected });

  final int? initialValue;
  final void Function(int) onValueSelected;

  @override
  State<DiceRollInputWidget> createState() => _DiceRollInputWidgetState();
}

class _DiceRollInputWidgetState extends State<DiceRollInputWidget> {
  late int selected;
  final GlobalKey _inputButtonKey = GlobalKey();
  double _selectorHeight = 0.0;
  double _selectorWidth = 0.0;
  final GlobalKey _offstageSelectorKey = GlobalKey();
  OverlayEntry? _selectorOverlay;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue ?? -1;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var box = _offstageSelectorKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _selectorHeight = box.getDryLayout(const BoxConstraints()).height;
        _selectorWidth = box.getDryLayout(const BoxConstraints()).width;
      });
    });

    // Just wait a bit if an initial value has been provided to ensure
    // that all widgets have been built. A bit dirty...
    if(widget.initialValue != null) {
      Future.delayed(
        const Duration(milliseconds: 200),
        () => widget.onValueSelected(widget.initialValue!)
      );
    }
  }

  void _dismissOverlay() {
    _selectorOverlay?.remove();
    _selectorOverlay?.dispose();
    _selectorOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextButton(
          key: _inputButtonKey,
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.all(16.0),
          ),
          onPressed: () {
            RenderBox box = _inputButtonKey.currentContext!.findRenderObject()! as RenderBox;
            Offset offset = box.localToGlobal(Offset(box.size.width / 2, box.size.height / 2));
            var screenWidth = MediaQuery.of(context).size.width;
            var screenHeight = MediaQuery.of(context).size.height;

            var top = offset.dy - (_selectorHeight / 2);
            if((top + _selectorHeight) > screenHeight) top = screenHeight - _selectorHeight;
            if(top < 0.0) top = 0.0;

            var left = offset.dx - (_selectorWidth / 2);
            if((left + _selectorWidth) > screenWidth) left = screenWidth - _selectorWidth;
            if(left < 0.0) left = 0.0;

            var overlayState = Overlay.of(context);
            _selectorOverlay = OverlayEntry(
              builder: (BuildContext context) {
                return Stack(
                  children: [
                    ModalBarrier(
                      dismissible: true,
                      onDismiss: () {
                        _dismissOverlay();
                      },
                    ),
                    Positioned(
                      top: top,
                      left: left,
                      child: _DiceValueSelector(
                        onValueSelected: (int v) {
                          _dismissOverlay();
                          widget.onValueSelected(v);
                          setState(() {
                            selected = v;
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
            );

            overlayState.insert(_selectorOverlay!);
          },
          child: Text(selected != -1 ? selected.toString() : '?'),
        ),
        Positioned(
          child: Offstage(
            offstage: true,
            child: _DiceValueSelector(
                key: _offstageSelectorKey,
                onValueSelected: (int v) {},
            ),
          ),
        ),
      ],
    );
  }
}

class _DiceValueSelector extends StatelessWidget {
  const _DiceValueSelector({ super.key, required this.onValueSelected });

  final void Function(int) onValueSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: List<int>.generate(5, (index) => index + 1).map((int v) => _DiceRollResultButton(
                value: v,
                onPressed: (int v) {
                  onValueSelected(v);
                },
              )).toList(),
            ),
            Row(
              children: List<int>.generate(5, (index) => index + 6).map((int v) => _DiceRollResultButton(
                value: v,
                onPressed: (int v) {
                  onValueSelected(v);
                },
              )).toList(),
            )
          ],
        ),
      ),
    );
  }
}

class _DiceRollResultButton extends StatelessWidget {
  const _DiceRollResultButton({
    required this.value,
    required this.onPressed,
  });

  final int value;
  final void Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed(value);
      },
      child: Text(value.toString()),
    );
  }
}