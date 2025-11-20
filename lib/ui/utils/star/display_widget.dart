import 'package:flutter/material.dart';

import '../../../classes/star.dart';
import '../../../classes/star_motivations.dart';
import '../dismissible_dialog.dart';
import '../error_feedback.dart';
import '../full_page_loading.dart';
import '../markdown_display_widget.dart';
import '../widget_group_container.dart';
import 'companies_display_widget.dart';

class StarDisplayWidget extends StatefulWidget {
  const StarDisplayWidget({ super.key, required this.id });

  final String id;

  @override
  State<StarDisplayWidget> createState() => _StarDisplayWidgetState();
}

class _StarDisplayWidgetState extends State<StarDisplayWidget> {
  late Future<Star?> starFuture;

  @override
  void initState() {
    super.initState();
    starFuture = Star.get(widget.id);
  }

  @override
  void didUpdateWidget(StarDisplayWidget old) {
    super.didUpdateWidget(old);
    starFuture = Star.get(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: starFuture,
      builder: (BuildContext context, AsyncSnapshot<Star?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return FullPageLoadingWidget();
        }

        if (snapshot.hasError) {
          return FullPageErrorWidget(
              message: snapshot.error!.toString(), canPop: false);
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return FullPageErrorWidget(
              message: 'Étoile non trouvée', canPop: false);
        }

        Star star = snapshot.data!;
        var theme = Theme.of(context);

        return Column(
          spacing: 16.0,
          children: [
            Text(
              star.name,
              style: theme.textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold),
              overflow: TextOverflow.fade,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.0,
              children: [
                Expanded(
                  child: WidgetGroupContainer(
                    title: Text(
                      'Caractéristiques',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Align(
                      alignment: AlignmentGeometry.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8.0,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Éclat : ',
                              style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: star.eclat.toString(),
                                  style: theme.textTheme.bodyLarge,
                                )
                              ]
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Envergure : ',
                              style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                  text: '${star.envergure.index + 1} (${star.envergure.title})',
                                  style: theme.textTheme.bodyLarge,
                                )
                              ]
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Vertu : ',
                                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: '${star.motivations.vertu.title} (${star.motivations.getValue(MotivationType.vertu)})',
                                    style: theme.textTheme.bodyLarge,
                                  )
                                ]
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Penchant : ',
                                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: '${star.motivations.penchant.title} (${star.motivations.getValue(MotivationType.penchant)})',
                                    style: theme.textTheme.bodyLarge,
                                  )
                                ]
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Idéal : ',
                                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: '${star.motivations.ideal.title} (${star.motivations.getValue(MotivationType.ideal)})',
                                    style: theme.textTheme.bodyLarge,
                                  )
                                ]
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Interdit : ',
                                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: '${star.motivations.interdit.title} (${star.motivations.getValue(MotivationType.interdit)})',
                                    style: theme.textTheme.bodyLarge,
                                  )
                                ]
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Épreuve : ',
                                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: '${star.motivations.epreuve.title} (${star.motivations.getValue(MotivationType.epreuve)})',
                                    style: theme.textTheme.bodyLarge,
                                  )
                                ]
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                                text: 'Destinée : ',
                                style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: '${star.motivations.destinee.title} (${star.motivations.getValue(MotivationType.destinee)})',
                                    style: theme.textTheme.bodyLarge,
                                  )
                                ]
                            ),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Pouvoirs : ',
                              style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                              children: [
                                if(star.powers.isEmpty)
                                  TextSpan(
                                    text: 'Aucun pouvoir',
                                    style: theme.textTheme.bodyLarge!.copyWith(fontStyle: FontStyle.italic),
                                  ),
                                for(var i in star.powers.keys.toList()..sort())
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: _StarPowerDisplayPill(
                                      power: star.powers[i]!.title,
                                      description: star.powers[i]!.description,
                                    )
                                  )
                              ]
                            ),
                          ),
                        ],
                      ),
                    )
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: StarCompaniesDisplayWidget(
                    star: star,
                  ),
                ),
              ],
            ),
            WidgetGroupContainer(
              title: Text(
                'Description',
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Center(
                child: MarkdownDisplayWidget(
                  data: star.description,
                ),
              ),
            )
          ],
        );
      }
    );
  }
}

class _StarPowerDisplayPill extends StatelessWidget {
  const _StarPowerDisplayPill({
    required this.power,
    required this.description,
  });

  final String power;
  final String description;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
        padding: const EdgeInsets.fromLTRB(8.0, 2.0, 2.0, 2.0),
        margin: const EdgeInsets.fromLTRB(0.0, 2.0, 12.0, 2.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black87),
          borderRadius: BorderRadius.circular(16.0),
          color: theme.colorScheme.surfaceContainerLow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(power),
            IconButton(
              icon: const Icon(Icons.help_outline),
              iconSize: 20,
              padding: const EdgeInsets.all(2.0),
              constraints: const BoxConstraints(),
              onPressed: () {
                Navigator.of(context).push(
                  DismissibleDialog<void>(
                    title: power,
                    content: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 400,
                        maxWidth: 400,
                        maxHeight: 400,
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          description,
                        ),
                      )
                    )
                  )
                );
              },
            )
          ],
        )
    );
  }
}