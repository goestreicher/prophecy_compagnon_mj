import 'package:flutter/foundation.dart';

import 'step_data.dart';
import 'step_data_0_concept.dart';
import 'step_data_10_xp.dart';
import 'step_data_11_skill_points.dart';
import 'step_data_12_equipment.dart';
import 'step_data_13_names.dart';
import 'step_data_1_augure.dart';
import 'step_data_2_age.dart';
import 'step_data_3_caste.dart';
import 'step_data_4_abilities.dart';
import 'step_data_5_attributes.dart';
import 'step_data_6_tendencies.dart';
import 'step_data_7_disadvantages.dart';
import 'step_data_8_advantages.dart';
import 'step_data_9_base_skills.dart';

class PlayerCharacterWizardStepper extends ChangeNotifier {
  PlayerCharacterWizardStepper();

  int get currentStep => _currentStep;
  set currentStep(int v) {
    _currentStep = v;
    notifyListeners();
  }
  int _currentStep = 0;

  List<PlayerCharacterWizardStepData> steps =
    <PlayerCharacterWizardStepData>[
      PlayerCharacterWizardStepDataConcept(),
      PlayerCharacterWizardStepDataAugure(),
      PlayerCharacterWizardStepDataAge(),
      PlayerCharacterWizardStepDataCaste(),
      PlayerCharacterWizardStepDataAbilities(),
      PlayerCharacterWizardStepDataAttributes(),
      PlayerCharacterWizardStepDataTendencies(),
      PlayerCharacterWizardStepDataDisadvantages(),
      PlayerCharacterWizardStepDataAdvantages(),
      PlayerCharacterWizardStepDataBaseSkills(),
      PlayerCharacterWizardStepDataXP(),
      PlayerCharacterWizardStepDataSkillPoints(),
      PlayerCharacterWizardStepDataEquipment(),
      PlayerCharacterWizardStepDataNames(),
    ];
}