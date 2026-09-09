import 'package:prophecy_compagnon_shared/classes/dice/throw_entity_base.dart';

class DiceThrowRequest {
  DiceThrowRequest({
    this.difficulty,
    required this.base,
    this.allowTendencies = true,
  });

  final int? difficulty;
  final bool allowTendencies;
  final DiceThrowEntityBase base;
}