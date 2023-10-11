import 'package:billbuddy/bloc/split_summary_bloc.dart';
import 'package:billbuddy/model/split_report.dart';
import 'package:billbuddy/repository/bill_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

import '../base/app_theme.dart';
import '../base/design_template.dart';
import '../model/bill.dart';
import '../utils/string_res.dart';
import '../utils/utils.dart';
import 'home_screen.dart';

class SplitSummaryScreen extends StatelessWidget {
  final Bill initialBill;
  final bool isViewOnly;

  const SplitSummaryScreen(this.initialBill, {this.isViewOnly = false, super.key});

  static Route route(Bill bill, {bool isViewOnly = false}) => MaterialPageRoute(builder: (context) => SplitSummaryScreen(bill, isViewOnly: isViewOnly,));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplitSummaryBloc>(
      create: (context) => SplitSummaryBloc(
          SplitSummaryState(initialBill),
          context.read<BillRepository>(),
          ScreenshotController(),
          isViewOnly: isViewOnly
      ),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                SingleChildScrollView(
                  child: Screenshot(
                    controller: context.read<SplitSummaryBloc>().screenshotController,
                    child: Container(
                      color: Colors.white,
                      child: ListView(
                        shrinkWrap: true,
                        addAutomaticKeepAlives: false,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(bottom: 16),
                        children: renderContainerChildren(context, state),
                      ),
                    ),
                  ),
                ),
                if (state.isLoading) Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator()
                )
              ],
            ),
          ),
          renderProceedButton(context, state)
        ],
      ),
    );
  }

  Widget renderProceedButton(BuildContext context, SplitSummaryState state) {
    return Container(
        padding: EdgeInsets.only(right: 16, left: 16, top: 12, bottom: 12),
        child: Row(
          children: [
            if (!isViewOnly) Expanded(child: Container(margin: EdgeInsets.only(right: 4), child: primaryTextButton(context, onPressed: () async {
              if (!state.isLoading) {
                context.read<SplitSummaryBloc>().add(SaveEvent());
                await context.read<SplitSummaryBloc>().saveBill();
                Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                Navigator.pushReplacement(context, HomeScreen.route());
              }
            }, text: StringRes.saveAndBackToHome))),
            Expanded(child: Container(margin: EdgeInsets.only(left: 4), child: primaryTextButton(context, onPressed: () {
              if (!state.isLoading) context.read<SplitSummaryBloc>().add(ShareEvent());
            }, text: StringRes.share))),
          ],
        )
    );
  }

  List<Widget> renderContainerChildren(BuildContext context, SplitSummaryState state) {
    List<Widget> list = [];
    list.add(renderHeader(context, state));
    list.add(renderDivider(16, 0));
    for (int i = 0; i < state.bill.participants.length; ++i) {
      var report = state.bill.getParticipantReport(i);
      list.add(renderParticipantReport(context, report, i != state.bill.participants.length - 1));
    }
    return list;
  }

  Widget renderHeader(BuildContext context, SplitSummaryState state) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
            child: Text(state.bill.title, style: textTheme(context).headlineSmall,),
          ),
          Container(
            padding: const EdgeInsets.only(top: 4.0, left: 16, right: 16),
            child:
            Text(dateToString(state.bill.billDate, format: "dd MMM yyyy"), style: textTheme(context).bodyMedium,),
          ),
          Container(
            padding: const EdgeInsets.only(top: 4.0, left: 16, right: 16),
            child:
            Text("${StringRes.billTotal} ${formatThousands(state.bill.total.toString())}", style: textTheme(context).titleMedium,),
          ),
        ],
      ),
    );
  }

  Widget renderParticipantReport(BuildContext context, SplitReport report, bool showDivider) {
    List<Widget> list = [];
    list.add(renderParticipantHeader(context, report));
    for (int i = 0; i < report.items.length; ++i) {
      list.add(renderParticipantBillItem(context, report, i));
    }
    list.add(renderParticipantSummary(context, report, showDivider));
    return Container(
      child: Column(
        children: list,
      ),
    );
  }

  Widget renderParticipantHeader(BuildContext context, SplitReport report) {
    return Container(
      padding: EdgeInsets.only(top: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
              child: Text("${report.participant}${StringRes.sTotal}", style: textTheme(context).titleMedium)
          ),
          Container(
              padding: EdgeInsets.only(top: 4, bottom: 4, left: 16, right: 16),
              child: Text(formatThousandsDouble(report.total), style: textTheme(context).titleMedium)
          ),
        ],
      ),
    );
  }

  Widget renderParticipantBillItem(BuildContext context, SplitReport report, int itemIdx) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
              flex: 8,
              child: Text(report.items[itemIdx].name, style: textTheme(context).bodyMedium)
          ),
          Expanded(
              flex: 2,
              child: Text("X${formatThousandsDouble(report.items[itemIdx].getQuantityPerParticipant())}", style: textTheme(context).bodyMedium)
          ),
          Expanded(
              flex: 3,
              child: Text(formatThousandsDouble(report.items[itemIdx].getAmountPerParticipant()), style: textTheme(context).bodyMedium, textAlign: TextAlign.right,)
          )
        ],
      ),
    );
  }

  Widget renderParticipantSummary(BuildContext context, SplitReport report, bool showDivider) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        children: [
          renderParticipantSummaryItem(context, StringRes.tax, formatThousandsDouble(report.tax)),
          renderParticipantSummaryItem(context, StringRes.serviceCharge, formatThousandsDouble(report.service)),
          renderParticipantSummaryItem(context, StringRes.discounts, formatThousandsDouble(report.discounts)),
          renderParticipantSummaryItem(context, StringRes.others, formatThousandsDouble(report.others)),
          if (showDivider) renderDivider(16, 0)
        ],
      ),
    );
  }

  Widget renderParticipantSummaryItem(BuildContext context, String label, String value) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
              child: Text(label, style: textTheme(context).bodyMedium)
          ),
          Expanded(
              child: Text(value, style: textTheme(context).bodyMedium, textAlign: TextAlign.right,)
          )
        ],
      ),
    );
  }

  Widget renderDivider(double topMargin, double verticalMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin, left: verticalMargin, right: verticalMargin),
      child: Divider(height: 1, thickness: 1),
    );
  }
}