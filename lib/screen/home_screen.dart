import 'package:billbuddy/base/app_theme.dart';
import 'package:billbuddy/bloc/home_bloc.dart';
import 'package:billbuddy/repository/bill_repository.dart';
import 'package:billbuddy/screen/edit_bill_screen.dart';
import 'package:billbuddy/screen/split_summary_screen.dart';
import 'package:billbuddy/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../base/design_template.dart';
import '../utils/string_res.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  static Route route() => MaterialPageRoute(builder: (context) => HomeScreen());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(
          HomeState(bills: [], isLoading: true),
          context.read<BillRepository>()
      )..add(InitHomeEvent()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(StringRes.yourBill, style: textThemePrimary(context).headlineSmall),
            backgroundColor: colorScheme(context).primary,
          ),
          body: BlocListener(
              bloc: context.read<HomeBloc>(),
              listener: (BuildContext context, HomeState state) {
                if (state.snackbarMessage != null) showSnackbar(context, state.snackbarMessage!);
              },
              child: homeContainer(context, state)),
          floatingActionButton: homeFloatingButton(context, state),
        ),
      ),
    );
  }
  
  Widget homeFloatingButton(BuildContext context, HomeState state) {
    return FloatingActionButton(
      onPressed: () {
        if (!state.isLoading) {
          Navigator.push(context, EditBillScreen.route(null));
        }
      },
      backgroundColor: colorScheme(context).primary,
      child: Icon(Icons.add, color: colorScheme(context).onPrimary,),
      tooltip: StringRes.addBill,
    );
  }

  Widget homeContainer(BuildContext context, HomeState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 16, right: 16),
      child: state.isLoading ? Center(child: CircularProgressIndicator()) :
        state.isErrorInit ? Center(child: Text(StringRes.errorOccurred)) :
        (state.bills.isNotEmpty) ?
        ListView(
          padding: EdgeInsets.only(top: 16, bottom: 16),
          addAutomaticKeepAlives: false,
          children: bills(context, state),
        ) : Center(child: Text(StringRes.noData))
    );
  }

  List<Widget> bills(BuildContext context, HomeState state) {
    List<Widget> bills = [];
    for (int i = 0; i < state.bills.length; ++i) {
      bills.add(bill(context, state, i));
    }
    return bills;
  }

  Widget bill(BuildContext context, HomeState state, int index) {
    var bill = state.bills[index];
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 16),
      decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.outline
          ),
          borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 9,
                    child: Text(bill.title, style: textTheme(context).titleLarge)
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                      onPressed: () {
                        showBillOptionBottomSheet(context, context.read<HomeBloc>(), index);
                      }, icon: Icon(Icons.more_horiz)),
                )
              ],
            )),
            Container(
              margin: EdgeInsets.only(top: 4),
                child: Text(dateToString(bill.billDate, format: "dd MMM yyyy"), style: textTheme(context).bodyMedium)
            ),
            Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                    formatThousands(bill.total.toString()),
                    style: customTextStyle(context, colorScheme(context).primary, 16, true)
                )
            ),
            renderDivider(12, 0),
            Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                          StringRes.itemAndParticipantCount(bill.items.length, bill.participants.length),
                          style: textTheme(context).bodyMedium
                      ),
                    ),
                    Expanded(
                      flex: 1,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(context, SplitSummaryScreen.route(bill, isViewOnly: true));
                          },
                          child: Text(
                            StringRes.seeDetail,
                            style: textThemePrimary(context).titleSmall,
                          ),
                          style: primaryButtonStyle(context, verticalPadding: 6),
                        )
                    )
                  ],
                )
            )
          ]),
    );
  }

  Widget renderDivider(double topMargin, double verticalMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin, left: verticalMargin, right: verticalMargin),
      child: Divider(height: 1, thickness: 1),
    );
  }

  void showBillOptionBottomSheet(BuildContext context, HomeBloc bloc, int itemPosition) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, EditBillScreen.route(bloc.state.bills[itemPosition]));
                    },
                    child: Container(
                        padding: EdgeInsets.all(16),
                        child: Text(StringRes.editBill,
                            style: textTheme(context).titleSmall)),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      bloc.add(DeleteBillEvent(itemPosition));
                    },
                    child: Container(
                        padding: EdgeInsets.all(16),
                        child: Text(StringRes.deleteBill,
                            style: textTheme(context).titleSmall)),
                  )
                ],
              ),
            ));
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}