import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../model/bill.dart';
import '../repository/bill_repository.dart';

class SplitSummaryBloc extends Bloc<SplitSummaryEvent, SplitSummaryState> {
  final BillRepository _billRepository;
  final ScreenshotController screenshotController;

  SplitSummaryBloc(super.initialState, this._billRepository, this.screenshotController) {
    on<SaveEvent>(onSaveEvent);
    on<ShareEvent>(onShareEvent);
  }

  void onSaveEvent(SaveEvent event, Emitter<SplitSummaryState> emitter) {
    // _billRepository.
  }

  void onShareEvent(ShareEvent event, Emitter<SplitSummaryState> emitter) async {
    screenshotController.capture().then((imageBytes) async {
      if (imageBytes == null) return;
      final directory = (await getApplicationDocumentsDirectory()).path;
      File imgFile = File("$directory/bill.png");
      imgFile.writeAsBytes(imageBytes);
      await Share.file("Bill", "bill.png", imageBytes, "image/png");
    }).catchError((e) {
      log(e);
    });
  }
}

abstract class SplitSummaryEvent {}

class SaveEvent extends SplitSummaryEvent {}
class ShareEvent extends SplitSummaryEvent {}

class SplitSummaryState {
  Bill bill;

  SplitSummaryState(this.bill);
}