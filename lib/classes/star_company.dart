import 'package:json_annotation/json_annotation.dart';

import 'character_role.dart';

part 'star_company.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class StarCompany {
  StarCompany({
    required this.name,
    this.guide,
    this.archiviste,
    this.mainDuDestin,
  });

  String name;
  CharacterRole? guide;
  CharacterRole? archiviste;
  CharacterRole? mainDuDestin;

  factory StarCompany.fromJson(Map<String, dynamic> json) =>
      _$StarCompanyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$StarCompanyToJson(this);
}