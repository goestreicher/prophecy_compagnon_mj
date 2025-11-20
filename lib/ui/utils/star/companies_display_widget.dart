import 'package:flutter/material.dart';

import '../../../classes/resource_link/resource_link.dart';
import '../../../classes/star.dart';
import '../uniform_height_wrap.dart';
import '../widget_group_container.dart';
import 'company_display_widget.dart';
import 'company_edit_dialog.dart';

class StarCompaniesDisplayWidget extends StatefulWidget {
  const StarCompaniesDisplayWidget({
    super.key,
    required this.star,
    this.edit = false,
    this.resourceLinkProvider,
  });

  final Star star;
  final bool edit;
  final ResourceLinkProvider? resourceLinkProvider;

  @override
  State<StarCompaniesDisplayWidget> createState() => _StarCompaniesDisplayWidgetState();
}

class _StarCompaniesDisplayWidgetState extends State<StarCompaniesDisplayWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return WidgetGroupContainer(
      title: Text(
        'Compagnies',
        style: theme.textTheme.bodyMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        spacing: 12.0,
        children: [
          UniformHeightWrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              for(var c in widget.star.companies)
                StarCompanyDisplayWidget(
                  company: c,
                  onEdit: !widget.edit ? null : () async {
                    var company = await showDialog(
                      context: context,
                      builder: (BuildContext context) => StarCompanyEditDialog(
                        company: c,
                        resourceLinkProvider: widget.resourceLinkProvider,
                      ),
                    );
                    if(!context.mounted) return;
                    if(company == null) return;

                    setState(() {
                      widget.star.companies.remove(c);
                      widget.star.companies.add(company);
                    });
                  },
                  onDelete: !widget.edit ? null : () {
                    setState(() {
                      widget.star.companies.remove(c);
                    });
                  },
                )
            ],
          ),
          if(widget.edit)
            ElevatedButton.icon(
              icon: const Icon(
                Icons.add,
                size: 16.0,
              ),
              style: ElevatedButton.styleFrom(
                textStyle: theme.textTheme.bodySmall,
              ),
              label: const Text('Nouvelle compagnie'),
              onPressed: () async {
                var company = await showDialog(
                  context: context,
                  builder: (BuildContext context) => StarCompanyEditDialog(),
                );
                if(!context.mounted) return;
                if(company == null) return;

                setState(() {
                  widget.star.companies.add(company);
                });
              },
            ),
        ],
      )
    );
  }
}