import 'resource_link.dart';

class MultiResourceLinkProvider extends ResourceLinkProvider {
  const MultiResourceLinkProvider({ required this.providers });

  final List<ResourceLinkProvider> providers;

  @override
  List<String> sourceNames() => [
      for(var p in providers)
        ...(p.sourceNames())
    ];

  @override
  List<ResourceLinkType> availableTypes() => {
      for(var p in providers)
        ...(p.availableTypes())
    }.toList();

  @override
  Future<List<ResourceLink>> linksForType(ResourceLinkType type, { String? sourceName }) async {
    var ret = <ResourceLink>[];

    for(var p in providers) {
      if(sourceName == null || p.sourceNames().contains(sourceName)) {
        ret.addAll(await p.linksForType(type));
      }
    }

    return ret;
  }
}