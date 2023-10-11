import 'dart:developer';
import 'dart:io';

import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../model/bill.dart';
import '../repository/bill_repository.dart';

class SplitSummaryBloc extends Bloc<SplitSummaryEvent, SplitSummaryState> {
  final BillRepository _billRepository;
  final ScreenshotController screenshotController;
  final isViewOnly;

  SplitSummaryBloc(super.initialState, this._billRepository, this.screenshotController, {this.isViewOnly = false}) {
    on<SaveEvent>(onSaveEvent);
    on<ShareEvent>(onShareEvent);
  }

  void onSaveEvent(SaveEvent event, Emitter<SplitSummaryState> emitter) {
    emitter(SplitSummaryState(state.bill, isLoading: true));
  }

  Future<void> saveBill() async {
    if (state.bill.id == null) {
      _billRepository.insertBill(state.bill).catchError((e) {
        log("error insert bill: ${e.toString()}");
      });
    } else {
      _billRepository.updateBill(state.bill).catchError((e) {
        log("error update bill: ${e.toString()}");
      });
    }
  }

  void onShareEvent(ShareEvent event, Emitter<SplitSummaryState> emitter) async {
    screenshotController.capture().then((imageBytes) async {
      if (imageBytes == null) return;
      final directory = (await getApplicationDocumentsDirectory()).path;
      File imgFile = File("$directory/bill.png");
      imgFile.writeAsBytes(imageBytes);
      await Share.file("Bill", "bill.png", imageBytes, "image/png");
    }).catchError((e) {
      log("error share: ${e.toString()}");
    });
  }
}

abstract class SplitSummaryEvent {}

class SaveEvent extends SplitSummaryEvent {}
class ShareEvent extends SplitSummaryEvent {}

class SplitSummaryState {
  Bill bill;
  bool isLoading;

  SplitSummaryState(this.bill, {this.isLoading = false});
}