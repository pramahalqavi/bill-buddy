import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../base/app_theme.dart';
import '../bloc/assign_participant_bloc.dart';
import '../model/bill.dart';
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

    );
}
  
}