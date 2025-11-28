// ignore_for_file: depend_on_referenced_packages
import 'package:build/build.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart' show LibraryReader;

import 'store_adapter_generators.dart';

Builder registerStoreAdaptersBuilder(BuilderOptions options) {
  var defaults = BuilderOptions({
    'output': 'lib/register_store_adapters.dart'
  });

  var opts = options.overrideWith(defaults);

  return RegisterStoreAdaptersBuilder(options: opts);
}

class RegisterStoreAdaptersBuilder implements Builder {
  RegisterStoreAdaptersBuilder({ required this.options })
    : generator = RegisterStoreAdapterGenerator();

  final BuilderOptions options;
  final RegisterStoreAdapterGenerator generator;

  @override
  Map<String, List<String>> get buildExtensions => {
    r'lib/$lib$': [options.config['output']],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    var buffer = StringBuffer();
    var functionBuffer = StringBuffer(
      'void registerStoreAdapters() {\n'
    );

    await for(var input in buildStep.findAssets(Glob('lib/**.dart'))) {
      if(!(await buildStep.resolver.isLibrary(input))) continue;
      var generated = generator.generate(
        LibraryReader(await buildStep.resolver.libraryFor(input)),
        buildStep,
      );
      if(generated.isNotEmpty) {
        buffer.write('import "${input.uri}";\n');
        functionBuffer.write(generated);
        functionBuffer.write('\n');
      }
    }

    functionBuffer.write('}\n');
    buffer.write('\n');
    buffer.write('import "classes/storage/storage.dart";');
    buffer.write('\n\n');
    buffer.write(functionBuffer.toString());

    await buildStep.writeAsString(AssetId(buildStep.inputId.package, options.config['output']), buffer.toString());
  }
}