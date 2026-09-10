import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

enum CombatActionType {
  movement(title: 'Mouvement', icon: Symbols.arrows_output),
  // attack(title: 'Attaque', icon: Icons.cancel_outlined),
  // defense(title: 'Défense', icon: Icons.cancel_outlined),
  // effect(title: 'Effet', icon: Icons.cancel_outlined),
  ;

  final String title;
  final IconData icon;

  const CombatActionType({ required this.title, required this.icon });
}