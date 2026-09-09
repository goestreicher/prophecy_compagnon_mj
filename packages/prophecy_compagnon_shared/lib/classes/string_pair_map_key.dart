class StringPairMapKey {
  StringPairMapKey(String n1, String n2)
    : pair = n1.compareTo(n2) < 0 ? (n1, n2) : (n2, n1)
  {
    if(n1 == n2) {
      throw(
        ArgumentError.value(
          pair,
          null,
          'Both strings in a StringPairMapKey must be different'
        )
      );
    }
  }

  (String, String) pair;

  @override
  bool operator ==(Object other) =>
      other is StringPairMapKey
      && pair.$1 == other.pair.$1
      && pair.$2 == other.pair.$2;

  @override
  int get hashCode => Object.hash(pair.$1, pair.$2);
}