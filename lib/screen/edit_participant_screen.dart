import 'package:billbuddy/bloc/edit_participant_bloc.dart';
import 'package:billbuddy/screen/assign_participant_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../base/app_theme.dart';
import '../base/design_template.dart';
import '../model/bill.dart';
import '../utils/string_res.dart';

class EditParticipantScreen extends StatelessWidget {
  final Bill initialBill;

  const EditParticipantScreen(this.initialBill, {super.key});

  static Route route(Bill bill) => MaterialPageRoute(builder: (context) => EditParticipantScreen(bill));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditParticipantBloc>(
      create: (context) => EditParticipantBloc(EditParticipantState(initialBill)),
      child: BlocBuilder<EditParticipantBloc, EditParticipantState>(
        builder: (BuildContext context, state) => Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: colorScheme(context).onPrimary),
            title: Text(StringRes.editParticipant, style: textThemePrimary(context).headlineSmall),
            backgroundColor: colorScheme(context).primary,
          ),
          body: renderContainer(context, state)
        ),
      ),
    );
  }

  Widget renderContainer(BuildContext context, EditParticipantState state) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ListView(
              addAutomaticKeepAlives: false,
              children: renderEditParticipant(context, state),
            ),
          ),
          renderProceedButton(context, state)
        ],
      ),
    );
  }

  List<Widget> renderEditParticipant(BuildContext context, EditParticipantState state) {
    List<Widget> items = [];
    items.addAll(renderHeader(context, state));
    items.add(Padding(padding: EdgeInsets.only(top: 8)));
    items.addAll(renderParticipants(context, state));
    return items;
  }

  List<Widget> renderHeader(BuildContext context, EditParticipantState state) {
    List<Widget> items = [];
    items.add(Padding(padding: EdgeInsets.only(top: 16), child: Text(StringRes.addParticipant, style: textTheme(context).headlineSmall)));
    items.add(
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextButton.icon(onPressed: () {
          if (state.bill.participants.length == 20) {
            showMaxParticipantErrorSnackbar(context, state);
          } else {
            context.read<EditParticipantBloc>().add(AddParticipantEvent());
          }
        },
        icon: Icon(Icons.add, color: colorScheme(context).onPrimary,),
        label: Text(StringRes.add, style: textThemePrimary(context).titleSmall),
        style: primaryButtonStyle(context, verticalPadding: 10),
    ),
      ));
    items.add(Padding(
      padding: EdgeInsets.only(top: 8),
      child: Divider(thickness: 1),
    ));
    return items;
  }

  List<Widget> renderParticipants(BuildContext context, EditParticipantState state) {
    List<Widget> items = [];
    for (int i = 0; i < state.bill.participants.length; ++i) {
      var participant = state.bill.participants[i];
      var rowChildren = [Expanded(
        flex: 9,
        child: TextFormField(
            onChanged: (value) {
              context.read<EditParticipantBloc>().add(UpdateParticipantEvent(i, value));
            },
            maxLength: 128,
            textCapitalization: TextCapitalization.sentences,
            controller: textEditingControllerWithValue(participant),
            decoration: inputDecoration(context, padding: 12, label: Text("${StringRes.participant} ${i + 1}"))
        ),
      )];
      if (i > 0) {
        rowChildren.add(Expanded(
          flex: 1,
          child: IconButton(onPressed: () {
            context.read<EditParticipantBloc>().add(DeleteParticipantEvent(i));
          }, icon: Icon(Icons.highlight_remove)),
        ));
      }
      var row = Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Row(children: rowChildren),
      );
      items.add(row);
    }
    return items;
  }

  Widget renderProceedButton(BuildContext context, EditParticipantState state) {
    var button = primaryTextButton(context, onPressed: () {
      Navigator.push(context, AssignParticipantScreen.route(state.bill));
    }, text: StringRes.next);
    List<Widget> columnChildren = [button];
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: columnChildren,
      ),
    );
  }

  void showMaxParticipantErrorSnackbar(BuildContext context, EditParticipantState state) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(StringRes.maxParticipantError),
    ));
  }
}