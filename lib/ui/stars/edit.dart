import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../classes/star.dart';
import '../utils/star/edit_widget.dart';

class StarEditPage extends StatelessWidget {
  const StarEditPage({ super.key, required this.id });

  final String id;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Star.get(id),
        builder: (BuildContext context, AsyncSnapshot<Star?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorWidget(snapshot.error!);
          }

          if(!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('Étoile non trouvée'),
            );
          }

          var star = snapshot.data!;

          return StarEditWidget(
            star: star,
            onEditDone: (bool result) async {
              if(result) {
                await Star.saveLocalModel(star);
                if(!context.mounted) return;
                context.go('/stars/${star.id}');
              }
              else {
                await Star.reloadFromStore(id);
                if(!context.mounted) return;
                context.go('/stars/${star.id}');
              }
            }
          );
        }
    );
  }
}