import 'package:billbuddy/base/app_theme.dart';
import 'package:billbuddy/base/design_template.dart';
import 'package:billbuddy/bloc/edit_bill_bloc.dart';
import 'package:billbuddy/model/bill.dart';
import 'package:billbuddy/model/bill_item.dart';
import 'package:billbuddy/screen/edit_participant_screen.dart';
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
    return BlocProvider<EditBillBloc>(
      create: (context) => EditBillBloc(
          EditBillState(Bill(billDate: DateTime.now(), items: [], participants: [""]))
      ),
      child: BlocBuilder<EditBillBloc, EditBillState>(
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

  Widget billContainer(BuildContext context, EditBillState state) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
        child: ListView(
            padding: EdgeInsets.only(bottom: 24),
            addAutomaticKeepAlives: false,
            children: renderBill(context, state)));
  }

  List<Widget> renderBill(BuildContext context, EditBillState state) {
    List<Widget> items = [];
    items.addAll(renderBillHeader(context, state));
    items.addAll(renderBillItems(context, state));
    items.addAll(renderBillSummary(context, state));
    items.add(renderSubmitButton(context, state));
    return items;
  }

  List<Widget> renderBillHeader(BuildContext context, EditBillState state) {
    List<Widget> items = [];
    items.add(Padding(padding: EdgeInsets.only(top: 16), child: Text(StringRes.billItems, style: textTheme(context).headlineSmall)));
    items.add(Padding(padding: EdgeInsets.only(top: 4), child: Text(StringRes.billItemsInstruction, style: textTheme(context).bodyMedium)));
    items.add(Padding(
        padding: EdgeInsets.only(top: 24),
        child: TextFormField(
          onChanged: (value) {
            context.read<EditBillBloc>().add(UpdateBillHeaderEvent(title: value));
          },
          maxLength: 128,
          textCapitalization: TextCapitalization.sentences,
          controller: textEditingControllerWithValue(state.bill.title),
          decoration: inputDecoration(context, padding: 16, label: Text(StringRes.title)),
        )));
    items.add(Padding(
        padding: EdgeInsets.only(top: 16),
        child: TextFormField(
          onTap: () { onTapDatePicker(context, state, context.read<EditBillBloc>()); },
          readOnly: true,
          controller: textEditingControllerWithValue(dateToString(state.bill.billDate)),
          decoration: inputDecoration(context, padding: 16, label: Text(StringRes.billDate)),
        )));
    items.add(Padding(
      padding: EdgeInsets.only(top: 8),
      child: Divider(thickness: 1),
    ));
    return items;
  }

  void onTapDatePicker(BuildContext context, EditBillState state, EditBillBloc bloc) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: state.bill.billDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101)
    );
    if (pickedDate != null) {
      bloc.add(UpdateBillHeaderEvent(date: dateToString(pickedDate)));
    }
  }

  List<Widget> renderBillItems(BuildContext context, EditBillState state) {
    List<Widget> items = [];
    for (int i = 0; i < state.bill.items.length; ++i) {
      items.add(renderBillItem(context, state.bill.items[i], i));
    }
    items.add(renderAddBillItem(context, state));
    return items;
  }
  
  Widget renderBillItem(BuildContext context, BillItem item, int position) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Row(
            children: [
              Expanded(
                flex: 9,
                child: TextField(
                    onChanged: (value) {
                      context.read<EditBillBloc>().add(UpdateBillItemEvent(position: position, name: value));
                    },
                    maxLength: 128,
                    textCapitalization: TextCapitalization.sentences,
                    controller: textEditingControllerWithValue(item.name),
                    decoration: inputDecoration(context, padding: 12, label: Text(StringRes.itemName))
                ),
              ),
              Expanded(
                  flex: 1,
                  child: IconButton(
                      onPressed: () {
                        var bloc = context.read<EditBillBloc>();
                        showBillItemOptionBottomSheet(context, position, bloc);
                      }, icon: Icon(Icons.more_horiz)))
            ],
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
                      context.read<EditBillBloc>().add(UpdateBillItemEvent(position: position, price: value));
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
                      context.read<EditBillBloc>().add(UpdateBillItemEvent(position: position, qty: value));
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
  
  Widget renderAddBillItem(BuildContext context, EditBillState state) {
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
                  context.read<EditBillBloc>().add(AddBillItemEvent());
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

  List<Widget> renderBillSummary(BuildContext context, EditBillState state) {
    List<Widget> items = [];
    items.add(renderBillSummaryHeader(context, state));
    items.add(renderBillSummaryItem(context, state, StringRes.subtotal, state.bill.getSubtotal().toString()));
    items.add(renderBillSummaryItem(context, state, StringRes.tax, state.bill.tax.toString(), onTextChange: (value) {
      context.read<EditBillBloc>().add(UpdateBillSummaryEvent(tax: value));
    }));
    items.add(renderBillSummaryItem(context, state, StringRes.serviceCharge, state.bill.service.toString(), onTextChange: (value) {
      context.read<EditBillBloc>().add(UpdateBillSummaryEvent(service: value));
    }));
    items.add(renderBillSummaryItem(context, state, StringRes.discounts, state.bill.discounts.toString(), onTextChange: (value) {
      context.read<EditBillBloc>().add(UpdateBillSummaryEvent(discounts: value));
    }));
    String? othersErrorMsg = (state.editBillError?.othersError ?? false) ? StringRes.othersErrorMsg : null;
    items.add(renderBillSummaryItem(context, state, StringRes.others, state.bill.others.toString(), errorMessage: othersErrorMsg, onTextChange: (value) {
      context.read<EditBillBloc>().add(UpdateBillSummaryEvent(others: value));
    }));
    String? totalErrorMsg = (state.editBillError?.totalError ?? false) ? StringRes.totalErrorMsg : null;
    items.add(renderBillSummaryItem(context, state, StringRes.totalAmount, state.bill.total.toString(), errorMessage: totalErrorMsg, onTextChange: (value) {
      context.read<EditBillBloc>().add(UpdateBillSummaryEvent(total: value));
    }));
    return items;
  }

  Widget renderBillSummaryHeader(BuildContext context, EditBillState state) {
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

  Widget renderBillSummaryItem(BuildContext context, EditBillState state, String itemName, String itemValue, {void Function(String value)? onTextChange, String? errorMessage}) {
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
          decoration: inputDecoration(context, padding: 6, isError: errorMessage != null)
      );
    } else {
      rightWidget = Text(formatThousands(itemValue), textAlign: TextAlign.right, style: textTheme(context).titleMedium);
    }
    double rightPadding = isTextForm ? 0 : 8;
    var contentRow = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Text(itemName, style: textTheme(context).titleSmall), flex: 1),
        Expanded(child: rightWidget, flex: 1)
      ],
    );
    var columnChildren = [contentRow];
    if (errorMessage != null) {
      columnChildren.add(Row(
        children: [
          Expanded(flex: 1, child: SizedBox()),
          Expanded(
              flex: 1,
              child: Text(errorMessage, textAlign: TextAlign.start, style: errorTextStyle(context)))
        ],
      ));
    }
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8, right: rightPadding),
      child: Column(
        children: columnChildren,
      ),
    );
  }

  Widget renderSubmitButton(BuildContext context, EditBillState state) {
    var button = primaryTextButton(context, onPressed: () {
      EditBillBloc bloc = context.read<EditBillBloc>();
      if (bloc.isBillValid()) {
        bloc.setDefaultBillValue();
        Navigator.push(context, EditParticipantScreen.route(state.bill));
      } else {
        bloc.add(EditBillProceedErrorEvent());
      }
    }, text: StringRes.next);
    List<Widget> columnChildren = [button];
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: columnChildren,
      ),
    );
  }

  void showBillItemOptionBottomSheet(BuildContext context, int itemPosition, EditBillBloc bloc) {
    showModalBottomSheet(context: context,
        builder: (context) => Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    bloc.add(DeleteBillItemEvent(itemPosition));
                  },
                  child: Padding(padding: EdgeInsets.only(top: 16, bottom: 16, right: 16, left: 16),
                      child: Text(StringRes.deleteItem, style: textTheme(context).titleSmall)
                  ),
                )
              ]
            ),
          ),
        )
    );
  }
}