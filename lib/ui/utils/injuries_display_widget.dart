import 'package:flutter/material.dart';

import '../../classes/character/injury.dart';

class InjuriesDisplayWidget extends StatelessWidget {
  const InjuriesDisplayWidget({ super.key, required this.injuries });

  final List<InjuryLevel> injuries;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        for(var i = 0; i < injuries.length; ++i)
          Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  '${injuries[i].title} (${injuries[i].start+1}${injuries[i].end == -1 ? "+" : "-${injuries[i].end.toString()}"})',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              for(var j = 0; j < injuries[i].capacity; ++j)
                Container(
                  margin: const EdgeInsets.fromLTRB(1.0, 0.0, 1.0, 0.0),
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
            ],
          )
      ],
    );
  }
}