import 'package:flutter/material.dart';

import '../../dismissible_dialog.dart';

class SingleSkillWidget extends StatelessWidget {
  const SingleSkillWidget({
    super.key,
    required this.name,
    required this.value,
    this.description,
  });

  final String name;
  final int value;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  DismissibleDialog<void>(
                    title: name,
                    content: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 400,
                        maxWidth: 400,
                        maxHeight: 400,
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          description!,
                        ),
                      )
                    )
                  )
                );
              },
              child: Text(name)
            ),
          )
        ),
        Flexible(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black12),
                )
            ),
          )
        ),
        Text(value.toString()),
      ],
    );
  }
}