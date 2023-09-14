import 'package:billbuddy/base/app_theme.dart';
import 'package:billbuddy/base/design_template.dart';
import 'package:billbuddy/bloc/add_bill_bloc.dart';
import 'package:billbuddy/model/bill.dart';
import 'package:billbuddy/model/bill_item.dart';
import 'package:billbuddy/utils/utils.dart';
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
          AddBillState(Bill(billDate: DateTime.now(), items: []))
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
            padding: EdgeInsets.only(bottom: 24),
            addAutomaticKeepAlives: false,
            children: constructBill(context, state)));
  }

  List<Widget> constructBill(BuildContext context, AddBillState state) {
    List<Widget> items = [];
    items.addAll(constructBillHeader(context, state));
    items.addAll(constructBillItems(context, state));
    items.addAll(constructBillSummary(context, state));
    items.add(constructSubmitButton(context, state));
    return items;
  }

  List<Widget> constructBillHeader(BuildContext context, AddBillState state) {
    List<Widget> items = [];
    items.add(Padding(padding: EdgeInsets.only(top: 16), child: Text(StringRes.billItems, style: textTheme(context).headlineSmall)));
    items.add(Padding(padding: EdgeInsets.only(top: 4), child: Text(StringRes.billItemsInstruction, style: textTheme(context).bodyMedium)));
    items.add(Padding(
        padding: EdgeInsets.only(top: 24),
        child: TextField(
          onChanged: (value) {
            context.read<AddBillBloc>().add(UpdateBillHeaderEvent(value));
          },
          controller: textEditingControllerWithValue(state.bill.title),
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
              onChanged: (value) {
                context.read<AddBillBloc>().add(UpdateBillItemEvent(position: item.position, name: value));
              },
              controller: textEditingControllerWithValue(item.name),
              decoration: inputDecoration(context, padding: 12, label: Text(StringRes.itemName))
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            children: [
              Expanded(
                flex: 75,
                child: TextFormField(
                    onChanged: (value) {
                      context.read<AddBillBloc>().add(UpdateBillItemEvent(position: item.position, price: value));
                    },
                    maxLength: 13,
                    controller: textEditingControllerWithValue(item.price.toString(), shouldFormatNumber: true),
                    keyboardType: TextInputType.number,
                    inputFormatters: numberInputFormatters(),
                    decoration: inputDecoration(context, padding: 12, label: Text(StringRes.price))
                ),
              ),
              Expanded(flex: 5, child: SizedBox()),
              Expanded(
                flex: 40,
                child: TextFormField(
                    onChanged: (value) {
                      context.read<AddBillBloc>().add(UpdateBillItemEvent(position: item.position, qty: value));
                    },
                    maxLength: 3,
                    textAlign: TextAlign.right,
                    controller: textEditingControllerWithValue(item.quantity.toString(), shouldFormatNumber: true),
                    keyboardType: TextInputType.number,
                    inputFormatters: numberInputFormatters(),
                    decoration: inputDecoration(context, padding: 12, label: Text(StringRes.qty), prefix: Text("X"))
                ),
              ),
              Expanded(flex: 10, child: SizedBox(
                  child: Text("=", textAlign: TextAlign.end, style: textTheme(context).titleMedium)
              )),
              Expanded(
                  flex: 75,
                  child: Text(formatThousands(item.amount.toString()),
                      textAlign: TextAlign.end,
                      style: textTheme(context).titleMedium)),
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
                  context.read<AddBillBloc>().add(AddBillItemEvent());
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
    items.add(constructBillSummaryItem(context, state, StringRes.subtotal, state.bill.getSubtotal().toString()));
    items.add(constructBillSummaryItem(context, state, StringRes.tax, state.bill.tax.toString(), onTextChange: (value) {
      context.read<AddBillBloc>().add(UpdateBillSummaryEvent(tax: value));
    }));
    items.add(constructBillSummaryItem(context, state, StringRes.serviceCharge, state.bill.service.toString(), onTextChange: (value) {
      context.read<AddBillBloc>().add(UpdateBillSummaryEvent(service: value));
    }));
    items.add(constructBillSummaryItem(context, state, StringRes.discounts, state.bill.discounts.toString(), onTextChange: (value) {
      context.read<AddBillBloc>().add(UpdateBillSummaryEvent(discounts: value));
    }));
    items.add(constructBillSummaryItem(context, state, StringRes.others, state.bill.others.toString(), onTextChange: (value) {
      context.read<AddBillBloc>().add(UpdateBillSummaryEvent(others: value));
    }));
    items.add(constructBillSummaryItem(context, state, StringRes.totalAmount, state.bill.total.toString(), onTextChange: (value) {
      context.read<AddBillBloc>().add(UpdateBillSummaryEvent(total: value));
    }));
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

  Widget constructBillSummaryItem(BuildContext context, AddBillState state, String itemName, String itemValue, {void Function(String value)? onTextChange}) {
    Widget rightWidget;
    bool isTextForm = onTextChange != null;
    if (isTextForm) {
      rightWidget = TextFormField(
          onChanged: onTextChange,
          maxLength: 13,
          textAlign: TextAlign.right,
          controller: textEditingControllerWithValue(itemValue, shouldFormatNumber: true),
          keyboardType: TextInputType.number,
          inputFormatters: numberInputFormatters(),
          decoration: inputDecoration(context, padding: 6)
      );
    } else {
      rightWidget = Text(formatThousands(itemValue), textAlign: TextAlign.right, style: textTheme(context).titleMedium);
    }
    double rightPadding = isTextForm ? 0 : 8;
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8, right: rightPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text(itemName, style: textTheme(context).titleSmall), flex: 1),
          Expanded(child: rightWidget, flex: 1)
        ],
      ),
    );
  }

  Widget constructSubmitButton(BuildContext context, AddBillState state) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: primaryTextButton(context, onPressed: () {}, text: StringRes.next),
    );
  }
}