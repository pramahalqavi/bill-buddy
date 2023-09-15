import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/bill.dart';

class EditParticipantBloc extends Bloc<EditParticipantEvent, EditParticipantState> {
  EditParticipantBloc(super.initialState);

}

abstract class EditParticipantEvent {}

class EditParticipantState {
  Bill bill;

  EditParticipantState(this.bill);
}