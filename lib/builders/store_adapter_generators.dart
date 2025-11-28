// ignore_for_file: depend_on_referenced_packages
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class RegisterStoreAdapterGenerator extends Generator {
  @override
  String generate(
    LibraryReader library,
    BuildStep buildStep,
  ) {
    var lines = <String>[];

    for(var element in library.classes) {
      if(!element.isPublic) continue;
      if(element.isAbstract) continue;

      var isObjectStoreAdapter = false;
      for(var interfaceType in element.allSupertypes) {
        if(interfaceType.getDisplayString().startsWith('ObjectStoreAdapter<')) isObjectStoreAdapter = true;
      }
      if(!isObjectStoreAdapter) continue;

      lines.add(
        '  DataStorage.registerStoreAdapter(\n'
        '    ${element.name!}().storeCategory(),\n'
        '    () => ${element.name!}(),\n'
        '  );'
      );
    }

    return lines.join('\n');
  }
}