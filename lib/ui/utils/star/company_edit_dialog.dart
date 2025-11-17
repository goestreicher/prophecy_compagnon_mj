import 'package:flutter/material.dart';

import '../../../classes/character_role.dart';
import '../../../classes/star_company.dart';
import '../character_role_edit_widget.dart';


class StarCompanyEditDialog extends StatefulWidget {
  const StarCompanyEditDialog({ super.key, this.company });

  final StarCompany? company;

  @override
  State<StarCompanyEditDialog> createState() => _StarCompanyEditDialogState();
}

class _StarCompanyEditDialogState extends State<StarCompanyEditDialog> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  CharacterRole? guide;
  CharacterRole? archiviste;
  CharacterRole? mainDuDestin;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.company?.name ?? '';
    guide = widget.company?.guide;
    archiviste = widget.company?.archiviste;
    mainDuDestin = widget.company?.mainDuDestin;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Éditer la compagnie'),
      content: Form(
        key: formKey,
        child: SizedBox(
          width: 450,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 12.0,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text('Nom'),
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if(value == null || value.isEmpty) {
                    return 'Valeur manquante';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              CharacterRoleListEditWidget(
                title: 'Guide',
                maxCount: 1,
                members: guide == null ? [] : [guide!],
                onAdd: (CharacterRole r) => setState(() {
                  guide = r;
                }),
                onDelete: (CharacterRole r) => setState(() {
                  guide = null;
                }),
              ),
              CharacterRoleListEditWidget(
                title: 'Archiviste',
                maxCount: 1,
                members: archiviste == null ? [] : [archiviste!],
                onAdd: (CharacterRole r) => setState(() {
                  archiviste = r;
                }),
                onDelete: (CharacterRole r) => setState(() {
                  archiviste = null;
                }),
              ),
              CharacterRoleListEditWidget(
                title: 'Main du destin',
                maxCount: 1,
                members: mainDuDestin == null ? [] : [mainDuDestin!],
                onAdd: (CharacterRole r) => setState(() {
                  mainDuDestin = r;
                }),
                onDelete: (CharacterRole r) => setState(() {
                  mainDuDestin = null;
                }),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            if(!formKey.currentState!.validate()) return;

            var company = StarCompany(
              name: nameController.text,
              guide: guide,
              archiviste: archiviste,
              mainDuDestin: mainDuDestin,
            );

            Navigator.of(context, rootNavigator: true).pop(company);
          },
          child: const Text('OK'),
        )
      ]
    );
  }
}