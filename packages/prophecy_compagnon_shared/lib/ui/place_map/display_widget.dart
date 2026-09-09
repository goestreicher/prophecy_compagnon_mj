import 'package:flutter/material.dart';
import 'package:prophecy_compagnon_shared/classes/place_map.dart';

class PlaceMapDisplayWidget extends StatelessWidget {
  const PlaceMapDisplayWidget({ super.key, required this.map });

  final PlaceMap map;
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: map.load(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if(snapshot.hasError || map.image == null) {
          return ErrorWidget('Échec de chargement de la carte');
        }

        return InteractiveViewer(
          child: Image.memory(map.image!)
        );
      }
    );
  }
}