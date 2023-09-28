import 'package:billbuddy/bloc/split_summary_bloc.dart';
import 'package:billbuddy/model/split_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../base/app_theme.dart';
import '../base/design_template.dart';
import '../model/bill.dart';
import '../utils/string_res.dart';

class SplitSummaryScreen extends StatelessWidget {
  final Bill initialBill;

  const SplitSummaryScreen(this.initialBill, {super.key});

  static Route route(Bill bill) => MaterialPageRoute(builder: (context) => SplitSummaryScreen(bill));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplitSummaryBloc>(
      create: (context) => SplitSummaryBloc(SplitSummaryState(initialBill)),
      child: BlocBuilder<SplitSummaryBloc, SplitSummaryState>(
        builder: (BuildContext context, state) => Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: colorScheme(context).onPrimary),
              title: Text(StringRes.summary, style: textThemePrimary(context).headlineSmall),
              backgroundColor: colorScheme(context).primary,
            ),
            body: renderContainer(context, state)
        ),
      ),
    );
  }

  Widget renderContainer(BuildContext context, SplitSummaryState state) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          ListView(
            children: renderContainerChildren(context, state),
          ),
          renderProceedButton(context, state)
        ],
      ),
    );
  }

  Widget renderProceedButton(BuildContext context, SplitSummaryState state) {
    return Container(
        padding: EdgeInsets.all(16),
        child: primaryTextButton(context, onPressed: () {}, text: StringRes.home)
    );
  }

  List<Widget> renderContainerChildren(BuildContext context, SplitSummaryState state) {
    List<Widget> list = [];
    list.add(renderHeader(context, state));
    for (int i = 0; i < state.bill.participants.length; ++i) {
      var report = state.bill.getParticipantReport(i);
      list.add(renderParticipantReport(context, report));
    }
    return list;
  }

  Widget renderHeader(BuildContext context, SplitSummaryState state) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
            child: Text(StringRes.assignParticipantToItems, style: textTheme(context).headlineSmall,),
          ),
          Container(
            padding: const EdgeInsets.only(top: 4.0, left: 16, right: 16),
            child:
            Text(StringRes.assignParticipantInstruction, style: textTheme(context).bodyMedium,),
          ),
        ],
      ),
    );
  }

  Widget renderParticipantReport(BuildContext context, SplitReport report) {
    return Container();
  }

  Widget renderParticipantHeader(BuildContext context, SplitReport report) {
    return Container();
  }

  Widget renderParticipantBillItem(BuildContext context, SplitReport report) {
    return Container();
  }

  Widget renderParticipantSummary(BuildContext context, SplitReport report) {
    return Container();
  }
}