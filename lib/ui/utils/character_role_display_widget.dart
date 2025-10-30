import 'package:flutter/material.dart';

import '../../classes/character_role.dart';
import 'markdown_display_widget.dart';

class CharacterRoleDisplayWidget extends StatelessWidget {
  const CharacterRoleDisplayWidget({ super.key, required this.member });

  final CharacterRole member;

  @override
  Widget build(BuildContext context) {
    var title = member.title.isNotEmpty ? ', ${member.title}' : '';
    if(member.name != null) {
      return Text(
          '${member.name}$title'
      );
    }
    else if(member.link != null) {
      return MarkdownDisplayWidget(
        data: '[${member.link!.name}$title](${member.link!.link})',
      );
    }
    else {
      return Text('Nom de dirigeant invalide');
    }
  }
}