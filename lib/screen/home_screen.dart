import 'package:billbuddy/base/app_theme.dart';
import 'package:billbuddy/bloc/home_bloc.dart';
import 'package:billbuddy/repository/bill_repository.dart';
import 'package:billbuddy/screen/edit_bill_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/result.dart';
import '../utils/string_res.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  static Route route() => MaterialPageRoute(builder: (context) => HomeScreen());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(
          HomeState(Result(Status.Loading)),
          context.read<BillRepository>()
      )..add(InitHomeEvent()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(StringRes.yourBill, style: textThemePrimary(context).headlineSmall),
            backgroundColor: colorScheme(context).primary,
          ),
          body: homeContainer(context, state),
          floatingActionButton: homeFloatingButton(context, state),
        ),
      ),
    );
  }
  
  Widget homeFloatingButton(BuildContext context, HomeState state) {
    return FloatingActionButton(
      onPressed: () {
        if (state.getStatus() != Status.Loading) {
          Navigator.push(context, EditBillScreen.route());
        }
      },
      backgroundColor: colorScheme(context).primary,
      child: Icon(Icons.add, color: colorScheme(context).onPrimary,),
      tooltip: StringRes.addBill,
    );
  }

  Widget homeContainer(BuildContext context, HomeState state) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: switch (state.getStatus()) {
        Status.Loading => Center(child: CircularProgressIndicator()),
        Status.Error => Center(child: Text(StringRes.errorOccurred)),
        Status.Success =>
        (state.getBills().isNotEmpty) ?
        ListView(
          addAutomaticKeepAlives: false,
          children: bills(context, state),
        ) : Center(child: Text(StringRes.noData))
      },
    );
  }

  List<Widget> bills(BuildContext context, HomeState state) {
    List<Widget> bills = List.empty(growable: true);
    state.getBills().map((element) => {
      Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.outline
            ),
            borderRadius: BorderRadius.all(Radius.circular(4))
        ),
        child: Column(children: [
          Text(element.id.toString())
        ]),
      ),
    });
    return bills;
  }
}