import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/bill.dart';

class AssignParticipantBloc extends Bloc<AssignParticipantEvent, AssignParticipantState> {
  AssignParticipantBloc(super.initialState) {
    on<ParticipantSelectedEvent>(onParticipantSelected);
    on<BillItemSelectedEvent>(onBillItemSelected);
    on<AssignParticipantErrorEvent>(onAssignParticipantError);
  }

  void onParticipantSelected(ParticipantSelectedEvent event, Emitter<AssignParticipantState> emitter) {
    if (event.index < 0 || event.index >= state.bill.participants.length) return;
    state.selectedParticipantIdx = event.index;
    emitter(AssignParticipantState(state.bill, selectedParticipantIdx: state.selectedParticipantIdx));
  }

  void onBillItemSelected(BillItemSelectedEvent event, Emitter<AssignParticipantState> emitter) {
    if (event.index < 0 || event.index >= state.bill.items.length) return;
    Set<int> participantSet = state.bill.items[event.index].participantsId;
    if (participantSet.contains(state.selectedParticipantIdx)) {
      participantSet.remove(state.selectedParticipantIdx);
    } else {
      participantSet.add(state.selectedParticipantIdx);
    }
    emitter(AssignParticipantState(state.bill, selectedParticipantIdx: state.selectedParticipantIdx));
  }

  void onAssignParticipantError(AssignParticipantErrorEvent event, Emitter<AssignParticipantState> emitter) {
    emitter(AssignParticipantState(state.bill,
        selectedParticipantIdx: state.selectedParticipantIdx,
        assignParticipantError: state.assignParticipantError
    ));
  }

  bool isAssignParticipantValid() {
    Set<int> validatedParticipantId = {};
    bool billItemError = false;
    bool participantError = false;
    for (var item in state.bill.items) {
      if (item.participantsId.isEmpty) {
        billItemError = true;
      }
      validatedParticipantId.addAll(item.participantsId);
    }
    participantError = validatedParticipantId.length != state.bill.participants.length;
    state.assignParticipantError = AssignParticipantError(
        billItemNotAssignedError: billItemError,
        participantNotAssignedError: participantError
    );
    return !billItemError && !participantError;
  }
}

abstract class AssignParticipantEvent {}

class ParticipantSelectedEvent extends AssignParticipantEvent {
  int index;

  ParticipantSelectedEvent(this.index);
}

class BillItemSelectedEvent extends AssignParticipantEvent {
  int index;

  BillItemSelectedEvent(this.index);
}

class AssignParticipantErrorEvent extends AssignParticipantEvent {}

class AssignParticipantError {
  bool participantNotAssignedError = false;
  bool billItemNotAssignedError = false;

  AssignParticipantError({this.participantNotAssignedError = false, this.billItemNotAssignedError = false});
}

class AssignParticipantState {
  Bill bill;
  int selectedParticipantIdx;
  AssignParticipantError? assignParticipantError;

  AssignParticipantState(this.bill,
      {this.selectedParticipantIdx = 0, this.assignParticipantError});
}