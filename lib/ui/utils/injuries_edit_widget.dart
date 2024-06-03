import 'package:flutter/material.dart';

import '../../classes/character/injury.dart';
import '../utils/character_digit_input_widget.dart';

class InjuriesEditWidget extends StatefulWidget {
  const InjuriesEditWidget({ super.key, required this.injuries });

  final List<InjuryLevel> injuries;

  @override
  State<InjuriesEditWidget> createState() => _InjuriesEditWidgetState();
}

class _InjuriesEditWidgetState extends State<InjuriesEditWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        for(var i = 0; i < widget.injuries.length; ++i)
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    widget.injuries[i].title,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 8.0),
                if(widget.injuries[i].end != -1)
                  SizedBox(
                    width: 80,
                    child: CharacterDigitInputWidget(
                      initialValue: widget.injuries[i].end,
                      maxValue: 501,
                      label: 'Max.',
                      onChanged: (int value) {
                        setState(() {
                          widget.injuries[i].end = value;
                          widget.injuries[i+1].start = value;
                        });
                      },
                    ),
                  ),
                if(widget.injuries[i].end == -1)
                  const SizedBox(width: 80),
                const SizedBox(width: 8.0),
                SizedBox(
                  width: 80,
                  child: CharacterDigitInputWidget(
                    initialValue: widget.injuries[i].capacity,
                    label: 'Nb.',
                    onChanged: (int value) {
                      setState(() {
                        widget.injuries[i].capacity = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}