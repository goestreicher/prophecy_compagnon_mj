import 'package:flutter/material.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({ super.key });

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  @override
  Widget build(BuildContext context) {
    Widget mapView = const Center(child: Text('Pas de carte chargée'));

    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: 3.0),
        ),
        child: Column(
          children: [
            mapView,
          ],
        ),
      ),
    );
  }
}