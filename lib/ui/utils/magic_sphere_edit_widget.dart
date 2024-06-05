import 'package:flutter/material.dart';

import '../../classes/magic.dart';
import 'character_digit_input_widget.dart';

class MagicSphereEditWidget extends StatefulWidget {
  const MagicSphereEditWidget({
    super.key,
    required this.sphere,
    required this.value,
    required this.pool,
    required this.onValueChanged,
    required this.onPoolChanged,
  });

  final MagicSphere sphere;
  final int value;
  final int pool;
  final void Function(int) onValueChanged;
  final void Function(int) onPoolChanged;

  @override
  State<MagicSphereEditWidget> createState() => _MagicSphereEditWidgetState();
}

class _MagicSphereEditWidgetState extends State<MagicSphereEditWidget> {
  late int _value;
  late int _pool;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
    _pool = widget.pool;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            height: 48,
            child: Image.asset(
              'assets/images/magic/sphere-${widget.sphere.name}-icon.png',
            ),
          ),
          const SizedBox(width: 12.0),
          Column(
            children: [
              SizedBox(
                width: 96,
                child: CharacterDigitInputWidget(
                    label: 'Niveau',
                    initialValue: _value,
                    minValue: 0,
                    maxValue: 15,
                    onChanged: (int value) {
                      var old = _value;
                      var delta = value - old;

                      setState(() {
                        _value = value;
                        _pool = _pool + delta;
                      });

                      widget.onValueChanged(_value);
                      widget.onPoolChanged(_pool);
                    }
                ),
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                width: 96,
                child: CharacterDigitInputWidget(
                    label: 'Réserve',
                    initialValue: _pool,
                    minValue: 0,
                    maxValue: 15,
                    onChanged: (int value) {
                      setState(() {
                        _pool = value;
                      });

                      widget.onPoolChanged(_pool);
                    }
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}