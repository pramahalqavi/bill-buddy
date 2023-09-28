import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/bill.dart';

class EditParticipantBloc extends Bloc<EditParticipantEvent, EditParticipantState> {
  EditParticipantBloc(super.initialState) {
    on<AddParticipantEvent>(onAddParticipant);
    on<DeleteParticipantEvent>(onDeleteParticipant);
    on<UpdateParticipantEvent>(onUpdateParticipant);
  }

  void onAddParticipant(AddParticipantEvent event, Emitter<EditParticipantState> emitter) {
    state.bill.participants.add("");
    emitter(EditParticipantState(state.bill));
  }

  void onDeleteParticipant(DeleteParticipantEvent event, Emitter<EditParticipantState> emitter) {
    if (event.position < 0 || event.position >= state.bill.participants.length) return;
    state.bill.participants.removeAt(event.position);
    emitter(EditParticipantState(state.bill));
  }

  void onUpdateParticipant(UpdateParticipantEvent event, Emitter<EditParticipantState> emitter) {
    if (event.position < 0 || event.position >= state.bill.participants.length) return;
    state.bill.participants[event.position] = event.newName;
    emitter(EditParticipantState(state.bill));
  }

}

abstract class EditParticipantEvent {}

class AddParticipantEvent extends EditParticipantEvent {}

class DeleteParticipantEvent extends EditParticipantEvent {
  int position;

  DeleteParticipantEvent(this.position);
}

class UpdateParticipantEvent extends EditParticipantEvent {
  int position;
  String newName;

  UpdateParticipantEvent(this.position, this.newName);
}

class EditParticipantState {
  Bill bill;

  EditParticipantState(this.bill);
}