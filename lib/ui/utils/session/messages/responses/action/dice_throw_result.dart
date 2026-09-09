import '../../../../../../classes/dice/throw_request.dart';
import '../../../../../../classes/dice/throw_result.dart';

class DiceThrowRequestResult {
  DiceThrowRequestResult({
    required this.request,
    required this.result,
  });

  final DiceThrowRequest request;
  final DiceThrowResult result;
}