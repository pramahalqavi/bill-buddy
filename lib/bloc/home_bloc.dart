import 'dart:developer';

import 'package:billbuddy/repository/bill_repository.dart';
import 'package:billbuddy/utils/string_res.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/bill.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BillRepository billRepository;
  HomeBloc(super.initialState, this.billRepository) {
    on<InitHomeEvent>(onInitHome);
    on<DeleteBillEvent>(onDeleteBill);
  }

  void onInitHome(InitHomeEvent event, Emitter<HomeState> emitter) async {
    emitter(HomeState(bills: state.bills, isLoading: true));
    try {
      var bills = await billRepository.getBills();
      emitter(HomeState(bills: bills, isLoading: false));
    } catch (error) {
      emitter(HomeState(bills: [], isErrorInit: true, isLoading: false));
      log("error init: ${error.toString()}");
    }
  }

  void onDeleteBill(DeleteBillEvent event, Emitter<HomeState> emitter) async {
    if (event.index >= state.bills.length || state.bills[event.index].id == null) return;
    emitter(HomeState(bills: state.bills, isLoading: true));
    try {
      await billRepository.deleteBill(state.bills[event.index].id!);
      var bills = await billRepository.getBills();
      emitter(HomeState(bills: bills, isLoading: false, snackbarMessage: StringRes.deleteBillSuccessMsg));
    } catch (error) {
      emitter(HomeState(bills: state.bills, isLoading: false, snackbarMessage: StringRes.deleteBillErrorMsg));
      log("error delete: ${error.toString()}");
    }
  }
}

abstract class HomeEvent {}

class InitHomeEvent extends HomeEvent {}

class DeleteBillEvent extends HomeEvent {
  int index;

  DeleteBillEvent(this.index);
}

class HomeState {
  bool isLoading;
  bool isErrorInit;
  List<Bill> bills;
  String? snackbarMessage;

  HomeState({required this.bills, this.isLoading = false, this.isErrorInit = false, this.snackbarMessage});
}