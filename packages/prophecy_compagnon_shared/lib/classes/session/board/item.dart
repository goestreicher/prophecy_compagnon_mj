import 'package:prophecy_compagnon_shared/classes/generic_image.dart';

abstract class SessionBoardItem {
  SessionBoardItem({
    required this.title,
    this.removable = true,
  });

  final String title;
  final bool removable;

  Future<GenericImage> thumbnail(double maxDimension);
  GenericImage image();
  Map<String, dynamic> toJson();
}