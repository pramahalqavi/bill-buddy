import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/bill.dart';
import '../repository/bill_repository.dart';

class SplitSummaryBloc extends Bloc<SplitSummaryEvent, SplitSummaryState> {
  final BillRepository _billRepository;
  SplitSummaryBloc(super.initialState, this._billRepository) {
    on<SaveEvent>(onSaveEvent);
  }

  void onSaveEvent(SaveEvent event, Emitter<SplitSummaryState> emitter) {
    // _billRepository.
  }
}

abstract class SplitSummaryEvent {}

class SaveEvent extends SplitSummaryEvent {}

class SplitSummaryState {
  Bill bill;

  SplitSummaryState(this.bill);
}