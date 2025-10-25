import 'package:flutter/material.dart';

class SingleSkillWidget extends StatelessWidget {
  const SingleSkillWidget({
    super.key,
    required this.name,
    required this.value
  });

  final String name;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: Text(name)),
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