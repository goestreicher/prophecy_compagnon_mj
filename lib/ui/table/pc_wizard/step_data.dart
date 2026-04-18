import 'package:flutter/material.dart';

import 'model.dart';

abstract class PlayerCharacterWizardStepData {
  PlayerCharacterWizardStepData({
    required this.title,
    this.canSkip = false,
    this.completed = false,
    this.changed = false,
    this.clearNextOnChange = true,
  });

  String title;
  bool canSkip;
  bool completed;
  bool changed;
  bool clearNextOnChange;

  Widget overviewWidget(BuildContext context);
  List<Widget> stepWidget(BuildContext context);
  void reset(PlayerCharacterWizardModel model);
  void init(PlayerCharacterWizardModel model);
  void clear();
  bool validate(PlayerCharacterWizardModel model, BuildContext context);
  void save(PlayerCharacterWizardModel model);
  
  Widget sliverWrap(List<Widget> widgets) {
    return SliverList(
      delegate: SliverChildListDelegate(widgets)
    );
  }
}