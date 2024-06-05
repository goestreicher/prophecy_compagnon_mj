import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../classes/human_character.dart';

class TendenciesEditWidget extends StatefulWidget {
  const TendenciesEditWidget({
    super.key,
    required this.tendencies,
    this.showCircles = false,
  });

  final CharacterTendencies tendencies;
  final bool showCircles;

  @override
  State<TendenciesEditWidget> createState() => _TendenciesEditWidgetState();
}

class _TendenciesEditWidgetState extends State<TendenciesEditWidget> {
  final TextEditingController _tendencyDragonController = TextEditingController();
  final TextEditingController _tendencyFatalityController = TextEditingController();
  final TextEditingController _tendencyHumanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tendencyDragonController.text = widget.tendencies.dragon.value.toString();
    _tendencyFatalityController.text = widget.tendencies.fatality.value.toString();
    _tendencyHumanController.text = widget.tendencies.human.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return SizedBox(
      width: 260,
      height: 260,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                'assets/images/tendencies/background_tendencies.png',
                width: 244,
              )
            ),
            // Positioned(
            //   top: 0,
            //   left: 66,
            //   child: Image.asset(
            //     'assets/images/tendencies/tendency-dragon.png',
            //     width: 96,
            //   ),
            // ),
            Positioned(
              // top: 43,
              // left: 94,
              top: 59,
              left: 103,
              child: SizedBox(
                width: 40,
                child: TextFormField(
                  controller: _tendencyDragonController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                    error: null,
                    errorText: null,
                  ),
                  style: theme.textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (String? value) {
                    if(value == null || value.isEmpty) return 'Valeur manquante';
                    int? input = int.tryParse(value);
                    if(input == null) return 'Pas un nombre';
                    if(input < 0) return 'Nombre >= 0';
                    if(input > 5) return 'Nombre <= 5';
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String? value) {
                    if(value == null) return;
                    int? input = int.tryParse(value);
                    if(input == null) return;
                    widget.tendencies.dragon.value = input;
                  },
                ),
              ),
            ),
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   child: Image.asset(
            //     'assets/images/tendencies/tendency-fatality.png',
            //     width: 96,
            //   ),
            // ),
            Positioned(
              // bottom: 41,
              // left: 41,
              bottom: 65,
              left: 53,
              child: SizedBox(
                width: 40,
                child: TextFormField(
                  controller: _tendencyFatalityController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                    error: null,
                    errorText: null,
                  ),
                  style: theme.textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (String? value) {
                    if(value == null || value.isEmpty) return 'Valeur manquante';
                    int? input = int.tryParse(value);
                    if(input == null) return 'Pas un nombre';
                    if(input < 0) return 'Nombre >= 0';
                    if(input > 5) return 'Nombre <= 5';
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String? value) {
                    if(value == null) return;
                    int? input = int.tryParse(value);
                    if(input == null) return;
                    widget.tendencies.fatality.value = input;
                  },
                ),
              ),
            ),
            // Positioned(
            //   bottom: 0,
            //   right: 0,
            //   child: Image.asset(
            //     'assets/images/tendencies/tendency-human.png',
            //     width: 96,
            //   ),
            // ),
            Positioned(
              // bottom: 41,
              // right: 39,
              bottom: 65,
              right: 51,
              child: SizedBox(
                width: 40,
                child: TextFormField(
                  controller: _tendencyHumanController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isCollapsed: true,
                    contentPadding: EdgeInsets.all(12.0),
                    error: null,
                    errorText: null,
                  ),
                  style: theme.textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (String? value) {
                    if(value == null || value.isEmpty) return 'Valeur manquante';
                    int? input = int.tryParse(value);
                    if(input == null) return 'Pas un nombre';
                    if(input < 0) return 'Nombre >= 0';
                    if(input > 5) return 'Nombre <= 5';
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (String? value) {
                    if(value == null) return;
                    int? input = int.tryParse(value);
                    if(input == null) return;
                    widget.tendencies.human.value = input;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}