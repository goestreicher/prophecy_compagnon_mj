// @dart=3.6
// ignore_for_file: type=lint
// build_runner >=2.4.16
import 'dart:io' as _io;
import 'package:build_runner/src/build_plan/builder_factories.dart'
    as _build_runner;
import 'package:build_runner/src/bootstrap/processes.dart' as _build_runner;
import 'package:prophecy_compagnon_shared/builders/store_adapter_builders.dart'
    as _i1;

final _builderFactories = _build_runner.BuilderFactories(
  {
    'prophecy_compagnon_shared:register_store_adapters': [
      _i1.registerStoreAdaptersBuilder
    ],
  },
  postProcessBuilderFactories: {},
);
void main(List<String> args) async {
  _io.exitCode = await _build_runner.ChildProcess.run(
    args,
    _builderFactories,
  )!;
}
