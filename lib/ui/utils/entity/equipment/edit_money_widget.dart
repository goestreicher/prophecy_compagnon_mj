import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../classes/entity_base.dart';
import '../../num_input_widget.dart';
import '../../widget_group_container.dart';

class EntityEditMoneyWidget extends StatelessWidget {
  const EntityEditMoneyWidget({
    super.key,
    required this.entity
  });

  final EntityBase entity;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Argent',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.0,
                    children: [
                      Text("Dragons"),
                      SizedBox(
                        width: 96,
                        child: NumIntInputWidget(
                          initialValue: entity.money.dragon,
                          minValue: 0,
                          maxValue: pow(2, 32).toInt() - 1,
                          onChanged: (int v) => entity.money.dragon = v,
                        ),
                      )
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.0,
                    children: [
                      Text("Or"),
                      SizedBox(
                        width: 96,
                        child: NumIntInputWidget(
                          initialValue: entity.money.or,
                          minValue: 0,
                          maxValue: pow(2, 32).toInt() - 1,
                          onChanged: (int v) => entity.money.or = v,
                        ),
                      )
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.0,
                    children: [
                      Text("Argent"),
                      SizedBox(
                        width: 96,
                        child: NumIntInputWidget(
                          initialValue: entity.money.argent,
                          minValue: 0,
                          maxValue: pow(2, 32).toInt() - 1,
                          onChanged: (int v) => entity.money.argent = v,
                        ),
                      )
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.0,
                    children: [
                      Text("Bronze"),
                      SizedBox(
                        width: 96,
                        child: NumIntInputWidget(
                          initialValue: entity.money.bronze,
                          minValue: 0,
                          maxValue: pow(2, 32).toInt() - 1,
                          onChanged: (int v) => entity.money.bronze = v,
                        ),
                      )
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8.0,
                    children: [
                      Text("Fer"),
                      SizedBox(
                        width: 96,
                        child: NumIntInputWidget(
                          initialValue: entity.money.fer,
                          minValue: 0,
                          maxValue: pow(2, 32).toInt() - 1,
                          onChanged: (int v) => entity.money.fer = v,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}