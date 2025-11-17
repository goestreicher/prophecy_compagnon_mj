import 'package:flutter/material.dart';

import '../../../classes/star_company.dart';
import '../character_role_display_widget.dart';

class StarCompanyDisplayWidget extends StatelessWidget {
  const StarCompanyDisplayWidget({
    super.key,
    required this.company,
    this.onEdit,
    this.onDelete,
  });

  final StarCompany company;
  final void Function()? onEdit;
  final void Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: theme.canvasColor,
        boxShadow: [BoxShadow(
          color: theme.colorScheme.onPrimaryContainer.withAlpha(80),
          blurRadius: 1,
          offset: Offset(0, 1),
        )]
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
        child: IntrinsicWidth(
          child: Row(
            spacing: 4.0,
            children: [
              if(onDelete != null)
                IconButton(
                  style: IconButton.styleFrom(
                    iconSize: 20.0,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    onDelete!();
                  },
                ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.0,
                  children: [
                    Text(
                      company.name,
                      style: theme.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    if(company.guide != null)
                      RichText(
                        text: TextSpan(
                          text: 'Guide : ',
                          style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: CharacterRoleDisplayWidget(
                                member: company.guide!
                              ),
                            ),
                          ],
                        ),
                      ),
                    if(company.archiviste != null)
                      RichText(
                        text: TextSpan(
                          text: 'Archiviste : ',
                          style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: CharacterRoleDisplayWidget(
                                  member: company.archiviste!
                              ),
                            ),
                          ],
                        ),
                      ),
                    if(company.mainDuDestin != null)
                      RichText(
                        text: TextSpan(
                          text: 'Main du destin : ',
                          style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: CharacterRoleDisplayWidget(
                                  member: company.mainDuDestin!
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if(onEdit != null)
                IconButton(
                  style: IconButton.styleFrom(
                    iconSize: 20.0,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    onEdit!();
                  },
                ),
            ],
          ),
        ),
      )
    );
  }
}