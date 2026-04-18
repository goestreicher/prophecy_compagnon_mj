import 'package:json_annotation/json_annotation.dart';

part 'money.g.dart';

enum MoneyUnit {
  fer,
  bronze,
  argent,
  or,
  dragon,
  ;
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class MoneyWallet {
  MoneyWallet({
    this.fer = 0,
    this.bronze = 0,
    this.argent = 0,
    this.or = 0,
    this.dragon = 0,
  });

  int fer;
  int bronze;
  int argent;
  int or;
  int dragon;

  factory MoneyWallet.fromJson(Map<String, dynamic> j) =>
      _$MoneyWalletFromJson(j);

  Map<String, dynamic> toJson() =>
      _$MoneyWalletToJson(this);
}