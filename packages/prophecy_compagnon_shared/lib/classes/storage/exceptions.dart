class StorageException implements Exception {
  StorageException(this.message);

  String message;

  @override
  String toString() => 'Storage exception: $message';
}

class KeyNotFoundException implements Exception {
  KeyNotFoundException(this.category, this.key);

  String category;
  String key;

  @override
  String toString() => 'Key "$key" not found in category "$category"';
}