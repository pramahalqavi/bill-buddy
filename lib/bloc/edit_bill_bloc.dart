import 'package:billbuddy/utils/string_res.dart';
import 'package:billbuddy/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/bill.dart';
import '../model/bill_item.dart';

class EditBillBloc extends Bloc<EditBillEvent, EditBillState> {
  EditBillBloc(super.initialState) {
   on<AddBillItemEvent>(addBillItem);
   on<DeleteBillItemEvent>(deleteBillItem);
   on<UpdateBillHeaderEvent>(updateBillHeader);
   on<UpdateBillItemEvent>(updateBillItem);
   on<UpdateBillSummaryEvent>(updateBillSummary);
   on<EditBillProceedErrorEvent>(editBillProceedError);
  }
  void addBillItem(AddBillItemEvent event, Emitter<EditBillState> emitter) {
    state.bill.items.add(BillItem(participantsId: {}));
    emitter(EditBillState(state.bill));
  }

  void deleteBillItem(DeleteBillItemEvent event, Emitter<EditBillState> emitter) {
    if (event.itemPosition < 0 || event.itemPosition >= state.bill.items.length) return;
    state.bill.items.removeAt(event.itemPosition);
    state.bill.updateTotal();
    emitter(EditBillState(state.bill));
  }

  void updateBillHeader(UpdateBillHeaderEvent event, Emitter<EditBillState> emitter) {
    if (event.title != null) state.bill.title = event.title!;
    DateTime? date = stringToDate(event.date);
    if (date != null) {
      state.bill.billDate = date;
      emitter(EditBillState(state.bill));
    }
  }

  void updateBillItem(UpdateBillItemEvent event, Emitter<EditBillState> emitter) {
    if (event.position < 0 || event.position >= state.bill.items.length) return;
    BillItem item = state.bill.items[event.position];
    if (event.name != null) item.name = event.name!;
    if (event.price?.isNotEmpty ?? false) {
      item.price = stringToInt(event.price);
      item.amount = item.getTotalPrice();
    }
    if (event.qty?.isNotEmpty ?? false) {
      item.quantity = stringToInt(event.qty);
      item.amount = item.getTotalPrice();
    }
    state.bill.items[event.position] = item;
    state.bill.updateTotal();
    _resetError();
    emitter(EditBillState(state.bill));
  }

  void updateBillSummary(UpdateBillSummaryEvent event, Emitter<EditBillState> emitter) {
    if (event.tax != null) state.bill.tax = stringToInt(event.tax);
    if (event.service != null) state.bill.service = stringToInt(event.service);
    if (event.discounts != null) state.bill.discounts = stringToInt(event.discounts);
    if (event.others != null) state.bill.others = stringToInt(event.others);
    if (event.total != null) {
      state.bill.total = stringToInt(event.total);
      state.bill.updateOthers();
    }
    state.bill.updateTotal();
    _resetError();
    emitter(EditBillState(state.bill));
  }

  void editBillProceedError(EditBillProceedErrorEvent event, Emitter<EditBillState> emitter) {
    bool othersError = state.bill.others < 0;
    bool totalError = state.bill.total <= 0;
    bool itemsLengthError = state.bill.items.isEmpty;
    bool itemQtyError = state.bill.items.where((element) => element.quantity <= 0).isNotEmpty;
    emitter(EditBillState(state.bill,
        editBillError: EditBillError(
          othersError: othersError,
          totalError: totalError,
          itemsLengthError: itemsLengthError,
          itemQuantityError: itemQtyError
        )));
  }

  bool isBillValid() {
    return state.bill.others >= 0 && state.bill.total > 0 && state.bill.items.isNotEmpty;
  }

  void _resetError() {
    state.editBillError = null;
  }

  void setDefaultBillValue() {
    if (state.bill.title.isEmpty) {
      state.bill.title = "${StringRes.bill} ${dateToString(state.bill.billDate)}";
    }
    for (int i = 0; i < state.bill.items.length; ++i) {
      var item = state.bill.items[i];
      if (item.name.isEmpty) item.name = "${StringRes.item} ${i + 1}";
    }
  }
}

abstract class EditBillEvent {}

class UpdateBillHeaderEvent extends EditBillEvent {
  String? title;
  String? date;

  UpdateBillHeaderEvent({this.title, this.date});
}

class UpdateBillItemEvent extends EditBillEvent {
  int position;
  String? name;
  String? price;
  String? qty;

  UpdateBillItemEvent({required this.position, this.name, this.price, this.qty});
}

class UpdateBillSummaryEvent extends EditBillEvent {
  String? tax;
  String? service;
  String? discounts;
  String? others;
  String? total;

  UpdateBillSummaryEvent({this.tax, this.service, this.discounts, this.others, this.total});
}

class AddBillItemEvent extends EditBillEvent {}
class DeleteBillItemEvent extends EditBillEvent {
  int itemPosition;

  DeleteBillItemEvent(this.itemPosition);
}

class EditBillProceedErrorEvent extends EditBillEvent {}

class EditBillError {
  bool totalError;
  bool othersError;
  bool itemsLengthError;
  bool itemQuantityError;

  EditBillError({required this.totalError, required this.othersError, required this.itemsLengthError, required this.itemQuantityError});
}

class EditBillState {
  Bill bill;
  EditBillError? editBillError;

  EditBillState(this.bill, {this.editBillError});
}