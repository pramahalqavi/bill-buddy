import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/bill.dart';

class AssignParticipantBloc extends Bloc<AssignParticipantEvent, AssignParticipantState> {
  AssignParticipantBloc(super.initialState) {
    on<ParticipantSelectedEvent>(onParticipantSelected);
    on<BillItemSelectedEvent>(onBillItemSelected);
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

class AssignParticipantState {
  Bill bill;
  int selectedParticipantIdx;

  AssignParticipantState(this.bill, {this.selectedParticipantIdx = 0});
}