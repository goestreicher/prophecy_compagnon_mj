import 'package:flutter/material.dart';

import '../../classes/resource_link/assets_resource_link_provider.dart';
import '../../classes/resource_link/resource_link.dart';

class ResourceLinkEditWidget extends StatefulWidget {
  const ResourceLinkEditWidget({
    super.key,
    required this.onChanged,
    ResourceLinkProvider? provider,
    this.restrictToTypes,
  })
    : provider = provider ?? const AssetsResourceLinkProvider();

  final void Function(ResourceLink?) onChanged;
  final ResourceLinkProvider provider;
  final List<ResourceLinkType>? restrictToTypes;

  @override
  State<ResourceLinkEditWidget> createState() => _ResourceLinkEditWidgetState();
}

class _ResourceLinkEditWidgetState extends State<ResourceLinkEditWidget> {
  TextEditingController selectionController = TextEditingController();

  ResourceLinkType? type;
  String? sourceName;
  Future<List<ResourceLink>> linksFuture = Future<List<ResourceLink>>.sync(() => <ResourceLink>[]);
  ResourceLink? selected;

  @override
  void didUpdateWidget(covariant ResourceLinkEditWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.provider.sourceNames() != widget.provider.sourceNames()) {
      sourceName = null;
      selected = null;
      if(type != null) {
        linksFuture = widget.provider.linksForType(type!, sourceName: sourceName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var types = widget.restrictToTypes ?? widget.provider.availableTypes();
    var sources = widget.provider.sourceNames();

    if(sourceName == null && sources.length == 1) {
      sourceName = sources[0];
    }

    if(type == null && types.length == 1) {
      type = types[0];
      linksFuture = widget.provider.linksForType(types[0], sourceName: sourceName);
    }

    return Column(
      spacing: 12.0,
      children: [
        if(sources.length > 1)
          DropdownMenu(
            initialSelection: sourceName,
            label: const Text('Source'),
            expandedInsets: EdgeInsets.zero,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
            textStyle: theme.textTheme.bodyMedium,
            dropdownMenuEntries: sources
                .map(
                    (String s) => DropdownMenuEntry(
                        value: s,
                        label: s
                    )
                )
                .toList(),
            onSelected: (String? s) {
              widget.onChanged(null);

              setState(() {
                sourceName = s;
                selectionController.clear();
                if(type == null) {
                  linksFuture = Future<List<ResourceLink>>.sync(() => <ResourceLink>[]);
                }
                else {
                  linksFuture = widget.provider.linksForType(type!, sourceName: sourceName);
                }
              });
            },
          ),
        if(types.length > 1)
          DropdownMenu(
            initialSelection: type,
            label: const Text('Type'),
            expandedInsets: EdgeInsets.zero,
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
            textStyle: theme.textTheme.bodyMedium,
            dropdownMenuEntries: types
                .map(
                    (ResourceLinkType t) => DropdownMenuEntry(
                        value: t,
                        label: t.title
                    )
                )
                .toList(),
            onSelected: (ResourceLinkType? t) {
              widget.onChanged(null);

              setState(() {
                type = t;
                selectionController.clear();
                if(t == null) {
                  linksFuture = Future<List<ResourceLink>>.sync(() => <ResourceLink>[]);
                }
                else {
                  linksFuture = widget.provider.linksForType(t, sourceName: sourceName);
                }
              });
            },
          ),
        FutureBuilder(
          future: linksFuture,
          builder: (BuildContext context, AsyncSnapshot<List<ResourceLink>> snapshot) {
            Widget? trailing;
            var links = <ResourceLink>[];

            if(snapshot.connectionState == ConnectionState.waiting) {
              trailing = CircularProgressIndicator();
            }

            if(snapshot.hasError) {
              trailing = Icon(Icons.warning);
            }

            if(snapshot.hasData && snapshot.data != null) {
              links.addAll(snapshot.data!.where((ResourceLink l) => l.clickable));
              links.sort((ResourceLink a, ResourceLink b) =>
                (a.label ?? a.name).compareTo((b.label ?? b.name)));
            }

            return DropdownMenuFormField(
              enabled: sourceName != null && type != null,
              enableFilter: true,
              trailingIcon: trailing,
              controller: selectionController,
              label: Text(type == null ? 'Ressource' : type!.title),
              expandedInsets: EdgeInsets.zero,
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
              textStyle: theme.textTheme.bodyMedium,
              menuStyle: const MenuStyle(
                alignment: Alignment.bottomLeft,
                maximumSize: WidgetStatePropertyAll(Size.fromHeight(200.0))
              ),
              dropdownMenuEntries: links
                .map((ResourceLink l) => DropdownMenuEntry(value: l, label: l.label ?? l.name, enabled: l.clickable))
                .toList(),
              onSelected: (ResourceLink? l) {
                widget.onChanged(l);
              },
              validator: (ResourceLink? l) {
                if(l == null) return 'Valeur obligatoire';
                return null;
              },
            );
          }
        ),
      ],
    );
  }
}