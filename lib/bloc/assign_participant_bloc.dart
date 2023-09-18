import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/bill.dart';

class AssignParticipantBloc extends Bloc<AssignParticipantEvent, AssignParticipantState> {
  AssignParticipantBloc(super.initialState);

}

abstract class AssignParticipantEvent {}

class AssignParticipantState {
  Bill bill;

  AssignParticipantState(this.bill);
}