import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/bill.dart';

class AddBillBloc extends Bloc<AddBillEvent, AddBillState> {
  AddBillBloc(super.initialState) {
   on<InitEditBill>(onInit);
  }

  void onInit(InitEditBill event, Emitter<AddBillState> emitter) {

  }
}

abstract class AddBillEvent {}

class InitEditBill extends AddBillEvent {}

class AddBillState {
  Bill bill;

  AddBillState(this.bill);
}