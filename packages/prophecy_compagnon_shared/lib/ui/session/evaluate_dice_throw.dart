import 'package:prophecy_compagnon_shared/classes/dice/throw_request.dart';
import 'package:prophecy_compagnon_shared/classes/dice/throw_result.dart';
import 'package:prophecy_compagnon_shared/classes/entity_base.dart';
import 'package:prophecy_compagnon_shared/ui/session/clients/session_message_bus_client.dart';
import 'package:prophecy_compagnon_shared/ui/session/messages/status/entity_property_status.dart';

class DiceThrowEvaluation {
  DiceThrowEvaluation({
    required this.resultType,
    required this.criticalType,
    required this.margin,
    required this.nr,
  });

  DiceThrowResultType resultType;
  DiceThrowResultType criticalType;
  int margin;
  int nr;
}

class EntityThrowBundle {
  const EntityThrowBundle({
    required this.entity,
    required this.request,
    required this.result,
  });

  final EntityBase entity;
  final DiceThrowRequest request;
  final DiceThrowResult result;

  int get _total {
    var sum = request.base.value(entity) + result.total();

    if(result.criticalType(request.base.componentValue(entity)) == DiceThrowResultType.criticalSuccess) {
      sum += 5;
    }

    return sum;
  }

  int _margin(int threshold) => _total - threshold;

  int _nr(int threshold) => _margin(threshold) ~/ 5;
}

DiceThrowEvaluation evaluateDiceThrow(
    EntityThrowBundle actor,
    {
      EntityThrowBundle? opposing,
    }
) {
  if(actor.request.difficulty == null && opposing == null) {
    throw(ArgumentError('One of "difficulty" or "opposing" must be set'));
  }

  var actorEvaluation = _doEvaluation(actor, actor.request.difficulty ?? opposing!._total);
  if(opposing == null && actorEvaluation.resultType == DiceThrowResultType.none) {
    actorEvaluation.resultType = DiceThrowResultType.success;
  }
  _dispatchUsedLuckProficiencyMessages(actor);
  _dispatchGainedLuckProficiencyMessages(actorEvaluation, actor.entity.id);

  DiceThrowEvaluation? opposingEvaluation;
  if(opposing != null) {
    opposingEvaluation = _doEvaluation(opposing, actor._total);
    _dispatchUsedLuckProficiencyMessages(opposing);
    _dispatchGainedLuckProficiencyMessages(opposingEvaluation, opposing.entity.id);
  }

  return actorEvaluation;
}

DiceThrowEvaluation _doEvaluation(EntityThrowBundle actor, int difficulty) {
  DiceThrowResultType resultType;
  DiceThrowResultType criticalType = actor.result.criticalType(
      actor.request.base.componentValue(
          actor.entity
      )
  );
  int margin;
  int nr;

  margin = actor._margin(difficulty);
  nr = actor._nr(difficulty);

  if(margin < 0 || criticalType == DiceThrowResultType.criticalFail) {
    resultType = DiceThrowResultType.fail;
  }
  else if(margin == 0) {
    resultType = DiceThrowResultType.none;
  }
  else {
    resultType = DiceThrowResultType.success;
  }

  return DiceThrowEvaluation(
    resultType: resultType,
    criticalType: criticalType,
    margin: margin,
    nr: nr
  );
}

void _dispatchUsedLuckProficiencyMessages(EntityThrowBundle bundle) {
  var messageBus = SessionMessageBusClient.instance;
  if(messageBus == null) return;

  if(bundle.result.luck != null) {
    messageBus.publish(
      SessionEntitySetPropertyMessage(
        broadcastIncludesSelf: true,
        entityId: bundle.entity.id,
        property: EntityMessageProperty.useLuckPoints,
        value: bundle.result.luck,
      )
    );
  }

  if(bundle.result.proficiency != null) {
    messageBus.publish(
      SessionEntitySetPropertyMessage(
        broadcastIncludesSelf: true,
        entityId: bundle.entity.id,
        property: EntityMessageProperty.useProficiencyPoints,
        value: bundle.result.proficiency,
      )
    );
  }
}

void _dispatchGainedLuckProficiencyMessages(DiceThrowEvaluation evaluation, String entityId) {
  var messageBus = SessionMessageBusClient.instance;
  if(messageBus == null) return;

  if(evaluation.criticalType == DiceThrowResultType.criticalSuccess) {
    messageBus.publish(
      SessionEntitySetPropertyMessage(
        broadcastIncludesSelf: true,
        entityId: entityId,
        property: EntityMessageProperty.gainProficiencyPoints,
        value: 2,
      )
    );
  }
  else if(evaluation.criticalType == DiceThrowResultType.criticalFail) {
    messageBus.publish(
      SessionEntitySetPropertyMessage(
        broadcastIncludesSelf: true,
        entityId: entityId,
        property: EntityMessageProperty.gainLuckPoints,
        value: 2,
      )
    );
  }
  else if(evaluation.resultType == DiceThrowResultType.success) {
    messageBus.publish(
      SessionEntitySetPropertyMessage(
        broadcastIncludesSelf: true,
        entityId: entityId,
        property: EntityMessageProperty.gainProficiencyPoints,
        value: 1,
      )
    );
  }
  else if(evaluation.resultType == DiceThrowResultType.fail) {
    messageBus.publish(
      SessionEntitySetPropertyMessage(
        broadcastIncludesSelf: true,
        entityId: entityId,
        property: EntityMessageProperty.gainLuckPoints,
        value: 1,
      )
    );
  }
}