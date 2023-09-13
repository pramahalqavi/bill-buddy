import 'package:billbuddy/base/app_theme.dart';
import 'package:billbuddy/base/design_template.dart';
import 'package:billbuddy/bloc/add_bill_bloc.dart';
import 'package:billbuddy/model/bill.dart';
import 'package:billbuddy/model/bill_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../utils/string_res.dart';

class EditBillScreen extends StatelessWidget {
  const EditBillScreen({super.key});

  static Route route() => MaterialPageRoute(builder: (context) => EditBillScreen());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddBillBloc>(
      create: (context) => AddBillBloc(
          AddBillState(Bill(billDate: DateTime.now(), items: [BillItem(name: "test")]))
      ),
      child: BlocBuilder<AddBillBloc, AddBillState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: colorScheme(context).onPrimary),
            title: Text(StringRes.newBill, style: textThemePrimary(context).headlineSmall),
            backgroundColor: colorScheme(context).primary,
          ),
          body: billContainer(context, state),
        ),
      ),
    );
  }

  Widget billContainer(BuildContext context, AddBillState state) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
        child: ListView(
            padding: EdgeInsets.only(bottom: 16),
            addAutomaticKeepAlives: false,
            children: constructBill(context, state)));
  }

  List<Widget> constructBill(BuildContext context, AddBillState state) {
    List<Widget> items = [];
    items.addAll(constructBillHeader(context, state));
    items.addAll(constructBillItems(context, state));
    items.addAll(constructBillSummary(context, state));
    return items;
  }

  List<Widget> constructBillHeader(BuildContext context, AddBillState state) {
    List<Widget> items = [];
    items.add(Padding(padding: EdgeInsets.only(top: 16), child: Text(StringRes.billItems, style: textTheme(context).headlineSmall)));
    items.add(Padding(padding: EdgeInsets.only(top: 4), child: Text(StringRes.billItemsInstruction, style: textTheme(context).bodyMedium)));
    items.add(Padding(
        padding: EdgeInsets.only(top: 24),
        child: TextField(
          decoration: inputDecoration(context, padding: 16, label: Text(StringRes.title)),
        )));
    items.add(Padding(
      padding: EdgeInsets.only(top: 8),
      child: Divider(thickness: 1),
    ));
    return items;
  }

  List<Widget> constructBillItems(BuildContext context, AddBillState state) {
    List<Widget> items = [];
    for (BillItem item in state.bill.items) {
      items.add(constructBillItem(context, item));
    }
    items.add(constructAddBillItem(context, state));
    return items;
  }
  
  Widget constructBillItem(BuildContext context, BillItem item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: TextField(
              controller: textEditingControllerWithValue(item.name),
              decoration: inputDecoration(context, padding: 12, label: Text(StringRes.itemName))
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: TextFormField(
                    controller: textEditingControllerWithValue(item.price.toString()),
                    keyboardType: TextInputType.number,
                    inputFormatters: numberInputFormatters(),
                    decoration: inputDecoration(context, padding: 12, label: Text(StringRes.price))
                ),
              ),
              Expanded(flex: 3, child: SizedBox()),
              Expanded(
                flex: 4,
                child: TextFormField(
                    controller: textEditingControllerWithValue(item.quantity.toString()),
                    keyboardType: TextInputType.number,
                    inputFormatters: numberInputFormatters(),
                    decoration: inputDecoration(context, padding: 12, label: Text(StringRes.qty), suffix: Text("X"))
                ),
              ),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 6,
                child: TextFormField(
                    controller: textEditingControllerWithValue(item.getTotal().toString()),
                    keyboardType: TextInputType.number,
                    inputFormatters: numberInputFormatters(),
                    decoration: inputDecoration(context, padding: 12, label: Text(StringRes.amount))
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Divider(),
        )
      ],
    );
  }
  
  Widget constructAddBillItem(BuildContext context, AddBillState state) {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 4),
            child: SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.all(16)),
                ),
                icon: Icon(Icons.add_circle_outline),
                label: Text(StringRes.addItem),
                onPressed: () {

                },
              ),
            )
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Divider(),
        )
      ],
    );
  }

  List<Widget> constructBillSummary(BuildContext context, AddBillState state) {
    List<Widget> items = [];
    items.add(constructBillSummaryHeader(context, state));
    items.add(constructBillSummaryItem(context, state, StringRes.subtotal, state.bill.getSubtotal().toString(), false));
    items.add(constructBillSummaryItem(context, state, StringRes.tax, state.bill.tax.toString(), true));
    items.add(constructBillSummaryItem(context, state, StringRes.serviceCharge, state.bill.service.toString(), true));
    items.add(constructBillSummaryItem(context, state, StringRes.discounts, state.bill.discounts.toString(), true));
    items.add(constructBillSummaryItem(context, state, StringRes.others, state.bill.others.toString(), false));
    items.add(constructBillSummaryItem(context, state, StringRes.totalAmount, state.bill.getTotal().toString(), true));
    return items;
  }

  Widget constructBillSummaryHeader(BuildContext context, AddBillState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Text(StringRes.summary, style: textTheme(context).titleMedium),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 4),
          child: Divider(),
        )
      ],
    );
  }

  Widget constructBillSummaryItem(BuildContext context, AddBillState state, String itemName, String itemValue, bool isTextForm) {
    Widget rightWidget;
    if (isTextForm) {
      rightWidget = TextFormField(
          textAlign: TextAlign.right,
          controller: textEditingControllerWithValue(itemValue),
          keyboardType: TextInputType.number,
          inputFormatters: numberInputFormatters(),
          decoration: inputDecoration(context, padding: 6)
      );
    } else {
      rightWidget = Text(itemValue, textAlign: TextAlign.right, style: textTheme(context).labelLarge);
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text(itemName, style: textTheme(context).labelLarge), flex: 1),
          Expanded(child: rightWidget, flex: 1)
        ],
      ),
    );
  }
}