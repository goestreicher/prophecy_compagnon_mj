import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../classes/star.dart';
import '../utils/star/create_widget.dart';

class StarCreatePage extends StatelessWidget {
  const StarCreatePage({ super.key });

  @override
  Widget build(BuildContext context) {
    return StarCreateWidget(
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