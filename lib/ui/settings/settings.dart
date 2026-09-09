import 'package:uuid/uuid.dart';

class ApplicationSettings {
  static ApplicationSettings get instance {
    _instance ??= ApplicationSettings._create();
    return _instance!;
  }

  ApplicationSettings._create()
    : runUuid = Uuid().v4().toString();

  final String runUuid;
  static ApplicationSettings? _instance;
}