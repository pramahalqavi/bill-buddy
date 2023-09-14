import 'package:billbuddy/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/bill.dart';
import '../model/bill_item.dart';

class AddBillBloc extends Bloc<AddBillEvent, AddBillState> {
  AddBillBloc(super.initialState) {
   on<AddBillItemEvent>(addBillItem);
   on<UpdateBillHeaderEvent>(updateBillHeader);
   on<UpdateBillItemEvent>(updateBillItem);
   on<UpdateBillSummaryEvent>(updateBillSummary);
  }
  void addBillItem(AddBillItemEvent event, Emitter<AddBillState> emitter) {
    int position = state.bill.items.length;
    state.bill.items.add(BillItem(position: position));
    emitter(AddBillState(state.bill));
  }

  void updateBillHeader(UpdateBillHeaderEvent event, Emitter<AddBillState> emitter) {
    state.bill.title = event.title;
  }

  void updateBillItem(UpdateBillItemEvent event, Emitter<AddBillState> emitter) {
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
    emitter(AddBillState(state.bill));
  }

  void updateBillSummary(UpdateBillSummaryEvent event, Emitter<AddBillState> emitter) {
    if (event.tax != null) state.bill.tax = stringToInt(event.tax);
    if (event.service != null) state.bill.service = stringToInt(event.service);
    if (event.discounts != null) state.bill.discounts = stringToInt(event.discounts);
    if (event.others != null) state.bill.others = stringToInt(event.others);
    if (event.total != null) {
      state.bill.total = stringToInt(event.total);
      state.bill.updateOthers();
    }
    state.bill.updateTotal();
    emitter(AddBillState(state.bill));
  }
}

abstract class AddBillEvent {}

class UpdateBillHeaderEvent extends AddBillEvent {
  String title;

  UpdateBillHeaderEvent(this.title);
}

class UpdateBillItemEvent extends AddBillEvent {
  int position;
  String? name;
  String? price;
  String? qty;

  UpdateBillItemEvent({required this.position, this.name, this.price, this.qty});
}

class UpdateBillSummaryEvent extends AddBillEvent {
  String? tax;
  String? service;
  String? discounts;
  String? others;
  String? total;

  UpdateBillSummaryEvent({this.tax, this.service, this.discounts, this.others, this.total});
}

class AddBillItemEvent extends AddBillEvent {}

class AddBillState {
  Bill bill;

  AddBillState(this.bill);
}