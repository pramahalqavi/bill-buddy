import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/bill.dart';

class SplitSummaryBloc extends Bloc<SplitSummaryEvent, SplitSummaryState> {
  SplitSummaryBloc(super.initialState);

}

abstract class SplitSummaryEvent {}

class SplitSummaryState {
  Bill bill;

  SplitSummaryState(this.bill);
}