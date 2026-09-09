import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prophecy_compagnon_shared/classes/star.dart';
import 'package:prophecy_compagnon_shared/ui/star/create_widget.dart';

class StarClonePage extends StatelessWidget {
  const StarClonePage({ super.key, required this.from });
  
  final String from;
  
  @override
  Widget build(BuildContext context) {
    return StarCreateWidget(
      cloneFrom: from,
      onStarCreated: (Star? star) {
        if(star == null) {
          context.go('/stars');
        }
        else {
          context.go('/stars/${star.id}');
        }
      },
    );
  }
}