abstract interface class StorageEngine {
  String uriScheme();
  String uriHost();
  Future<void> init();
  Future<List<String>> keys(String category);
  Future<String> get(String category, String key);
  Future<void> save(String category, String key, String data);
  Future<void> delete(String category, String key);
  Future<void> purge(String category);
}