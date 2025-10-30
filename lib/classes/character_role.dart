import 'package:json_annotation/json_annotation.dart';

import 'resource_link/resource_link.dart';

part 'character_role.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class CharacterRole {
  CharacterRole({
    this.name,
    this.link,
    required this.title,
  })
  {
    if(name == null && link == null) {
      throw ArgumentError('Either name or link must be provided to create a faction member');
    }
  }

  String? name;
  ResourceLink? link;
  String title;

  factory CharacterRole.fromJson(Map<String, dynamic> j) =>
      _$CharacterRoleFromJson(j);
  Map<String, dynamic> toJson() =>
      _$CharacterRoleToJson(this);
}