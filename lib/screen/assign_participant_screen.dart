import 'package:billbuddy/screen/split_summary_screen.dart';
import 'package:billbuddy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../base/app_theme.dart';
import '../base/design_template.dart';
import '../bloc/assign_participant_bloc.dart';
import '../model/bill.dart';
import '../model/bill_item.dart';
import '../utils/string_res.dart';

class AssignParticipantScreen extends StatelessWidget {
  final Bill initialBill;

  const AssignParticipantScreen(this.initialBill, {super.key});

  static Route route(Bill bill) => MaterialPageRoute(builder: (context) => AssignParticipantScreen(bill));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssignParticipantBloc>(
      create: (context) => AssignParticipantBloc(AssignParticipantState(initialBill)),
      child: BlocBuilder<AssignParticipantBloc, AssignParticipantState>(
        builder: (BuildContext context, state) => Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: colorScheme(context).onPrimary),
              title: Text(StringRes.assignParticipant, style: textThemePrimary(context).headlineSmall),
              backgroundColor: colorScheme(context).primary,
            ),
            body: renderContainer(context, state)
        ),
      ),
    );
  }

  Widget renderContainer(BuildContext context, AssignParticipantState state) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(bottom: 16),
              addAutomaticKeepAlives: false,
              children: renderAssignScreen(context, state),
            ),
          ),
          renderProceedButton(context, state)
        ],
      ),
    );
  }

  Widget renderProceedButton(BuildContext context, AssignParticipantState state) {
    var errorMsg = (state.assignParticipantError?.participantNotAssignedError == true) ?
    StringRes.participantNotAssignedErrorMsg : (state.assignParticipantError?.billItemNotAssignedError == true) ?
    StringRes.billItemNotAssignedErrorMsg : "";
    var error = Container(
        margin: EdgeInsets.only(bottom: 4),
        child: Text(errorMsg, textAlign: TextAlign.center, style: errorTextStyle(context))
    );
    var button = primaryTextButton(context, onPressed: () {
      if (context.read<AssignParticipantBloc>().isAssignParticipantValid()) {
        Navigator.push(context, SplitSummaryScreen.route(state.bill));
      } else {
        context.read<AssignParticipantBloc>().add(AssignParticipantErrorEvent());
      }
    }, text: StringRes.proceed);
    List<Widget> columnChildren = [
      if (errorMsg.isNotEmpty) error,
      button
    ];
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: columnChildren,
      ),
    );
  }

  List<Widget> renderAssignScreen(BuildContext context, AssignParticipantState state) {
    List<Widget> list = [];
    list.add(renderHeader(context, state));
    list.addAll(renderBillItems(context, state));
    list.add(renderBillSummary(context, state));
    return list;
  }

  Widget renderHeader(BuildContext context, AssignParticipantState state) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
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
          renderParticipantListView(context, state),
          renderDivider(8),
        ],
      ),
    );
  }

  Widget renderParticipantListView(BuildContext context, AssignParticipantState state) {
    return Container(
      height: 120,
      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: ListView(
        addAutomaticKeepAlives: false,
        scrollDirection: Axis.horizontal,
        children: renderParticipants(context, state),
      ),
    );
  }

  List<Widget> renderParticipants(BuildContext context, AssignParticipantState state) {
    List<Widget> list = [];
    for (int i = 0; i < state.bill.participants.length; ++i) {
      String participant = state.bill.participants[i];
      var fillColor = i == state.selectedParticipantIdx ? colorScheme(context).primary : colorScheme(context).onPrimary;
      var outlineColor = i == state.selectedParticipantIdx ? colorScheme(context).onPrimary : colorScheme(context).outline;
      var txtThemeContainer = i == state.selectedParticipantIdx ? textThemePrimary(context) : textTheme(context);
      list.add(
          GestureDetector(
            onTap: () {
              context.read<AssignParticipantBloc>().add(ParticipantSelectedEvent(i));
            },
            child: Container(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "${i + 1}",
                      style: txtThemeContainer.headlineMedium,
                    ),
                    decoration: BoxDecoration(
                        color: fillColor,
                        border: Border.all(
                          color: outlineColor,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(100))
                    ),
                    padding: EdgeInsets.only(top: 16, bottom: 16, left: 26, right: 26),
                  ),
                  Container(
                      constraints: BoxConstraints(maxWidth: 90, maxHeight: 110),
                      margin: EdgeInsets.only(top: 8),
                      child: Text(
                        participant,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme(context).bodyMedium,
                        maxLines: 1,
                      )
                  ),
              ],
            ),
        ),
          )
      );
    }
    return list;
  }

  List<Widget> renderBillItems(BuildContext context, AssignParticipantState state) {
    var idx = 0;
    return state.bill.items.map((item) => renderBillItem(context, state, idx++)).toList();
  }

  Widget renderBillItem(BuildContext context, AssignParticipantState state, int index) {
    return InkWell(
      onTap: () {
        context.read<AssignParticipantBloc>().add(BillItemSelectedEvent(index));
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 17,
                      child: Text(state.bill.items[index].name, style: textTheme(context).bodyLarge,),
                  ),
                  Expanded(
                    flex: 1,
                    child: Checkbox(
                        value: state.bill.items[index].participantsId.contains(state.selectedParticipantIdx),
                        onChanged: (isChecked) {
                          context.read<AssignParticipantBloc>().add(BillItemSelectedEvent(index));
                        }
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  Expanded(
                      flex: 4,
                      child: Text(
                        formatThousands(state.bill.items[index].price.toString()),
                        style: textTheme(context).bodyLarge,
                      )),
                  Expanded(
                      flex: 1,
                      child: Text("X${state.bill.items[index].quantity}",
                          style: textTheme(context).bodyLarge)),
                  Expanded(
                      flex: 3,
                      child: Text(
                        formatThousands(state.bill.items[index].amount.toString()),
                        style: textTheme(context).bodyLarge,
                        textAlign: TextAlign.right,
                      ))
                ],
              ),
            ),
            if (state.bill.items[index].participantsId.isNotEmpty) Container(
              height: 56,
              padding: EdgeInsets.only(top: 12, left: 16, right: 16),
              child: ListView(
                addAutomaticKeepAlives: false,
                scrollDirection: Axis.horizontal,
                children: renderItemBillParticipant(context, state, state.bill.items[index]),
              ),
            ),
            renderDivider(16)
          ],
        ),
      ),
    );
  }

  List<Widget> renderItemBillParticipant(BuildContext context, AssignParticipantState state, BillItem billItem) {
    return billItem.participantsId.map((id) =>
        Container(
          margin: EdgeInsets.only(right: 2, left: 2),
          child: Text(
            "${id + 1}",
            style: textTheme(context).bodyMedium,
          ),
          decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme(context).outline,
              ),
              borderRadius: BorderRadius.all(Radius.circular(100))
          ),
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 16, right: 16),
        )
    ).toList();
  }

  Widget renderBillSummary(BuildContext context, AssignParticipantState state) {
    List<Widget> items = [];
    items.add(renderBillSummaryItem(context, state, StringRes.subtotal, state.bill.getSubtotal().toString()));
    items.add(renderBillSummaryItem(context, state, StringRes.tax, state.bill.tax.toString()));
    items.add(renderBillSummaryItem(context, state, StringRes.serviceCharge, state.bill.service.toString()));
    items.add(renderBillSummaryItem(context, state, StringRes.discounts, state.bill.discounts.toString()));
    items.add(renderBillSummaryItem(context, state, StringRes.others, state.bill.others.toString()));
    items.add(renderBillSummaryItem(context, state, StringRes.totalAmount, state.bill.total.toString()));
    return Container(
      margin: EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Column(
        children: items,
      ),
    );
  }

  Widget renderBillSummaryItem(BuildContext context, AssignParticipantState state, String itemName, String itemValue) {
    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text(itemName, style: textTheme(context).titleSmall)),
          Expanded(child: Text(formatThousands(itemValue), textAlign: TextAlign.right, style: textTheme(context).titleMedium))
        ],
      ),
    );
  }

  Widget renderDivider(double topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin, left: 16, right: 16),
      child: Divider(height: 1, thickness: 1),
    );
  }
}