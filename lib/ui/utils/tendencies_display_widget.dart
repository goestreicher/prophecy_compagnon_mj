import 'package:flutter/material.dart';

import '../../classes/human_character.dart';

class TendenciesDisplayWidget extends StatelessWidget {
  const TendenciesDisplayWidget({ super.key, required this.tendencies });

  final CharacterTendencies tendencies;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SizedBox(
      width: 140,
      child: Center(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/tendencies/background_tendencies.png',
              width: 140,
            ),
            Positioned(
              top: 31,
              left: 66,
              child: Text(
                tendencies.dragon.value.toString(),
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              bottom: 33,
              left: 37,
              child: Text(
                tendencies.fatality.value.toString(),
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              bottom: 33,
              left: 95,
              child: Text(
                tendencies.human.value.toString(),
                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}