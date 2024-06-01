enum DiceThrowResultType {
  criticalFail(title: 'Échec critique'),
  fail(title: 'Échec'),
  pass(title: 'Réussite'),
  criticalPass(title: 'Réussite critique');

  final String title;

  const DiceThrowResultType({ required this.title });
}

class DiceThrowResult {
  DiceThrowResult({ required this.type, this.nrCount = 0 });

  DiceThrowResultType type;
  int nrCount;
}