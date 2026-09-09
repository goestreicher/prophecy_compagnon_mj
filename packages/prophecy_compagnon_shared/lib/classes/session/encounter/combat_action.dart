import 'package:prophecy_compagnon_shared/classes/session/encounter/combat_action_type.dart';

abstract class CombatAction {
  CombatAction({
    required this.type,
    required this.rank,
    this.interpolate = false,
  });

  final CombatActionType type;
  final int rank;
  final bool interpolate;

  CombatAction? lerp(int rank, double x) => null;
}