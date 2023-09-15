import 'package:billbuddy/bloc/edit_participant_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../base/app_theme.dart';
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
            title: Text(StringRes.newBill, style: textThemePrimary(context).headlineSmall),
            backgroundColor: colorScheme(context).primary,
          ),
          body: renderContainer(context, state),
        ),
      ),
    );
  }

  Widget renderContainer(BuildContext context, EditParticipantState state) {
    return Container();
  }

}