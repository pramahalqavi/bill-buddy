import 'dart:developer';

import 'package:billbuddy/repository/bill_repository.dart';
import 'package:billbuddy/utils/bill_recognizer.dart';
import 'package:billbuddy/utils/string_res.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../model/bill.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BillRepository billRepository;
  HomeBloc(super.initialState, this.billRepository) {
    on<InitHomeEvent>(onInitHome);
    on<DeleteBillEvent>(onDeleteBill);
    on<RecognizeBillEvent>(onRecognizeImage);
  }

  void onInitHome(InitHomeEvent event, Emitter<HomeState> emitter) async {
    emitter(HomeState(bills: state.bills, isLoading: true));
    try {
      var bills = await billRepository.getBills();
      emitter(HomeState(bills: bills, isLoading: false));
    } catch (error) {
      emitter(HomeState(bills: [], isErrorInit: true, isLoading: false));
      log("error init: ${error.toString()}");
    }
  }

  void onDeleteBill(DeleteBillEvent event, Emitter<HomeState> emitter) async {
    if (event.index >= state.bills.length || state.bills[event.index].id == null) return;
    emitter(HomeState(bills: state.bills, isLoading: true));
    try {
      await billRepository.deleteBill(state.bills[event.index].id!);
      var bills = await billRepository.getBills();
      emitter(HomeState(bills: bills, isLoading: false, snackbarMessage: StringRes.deleteBillSuccessMsg));
    } catch (error) {
      emitter(HomeState(bills: state.bills, isLoading: false, snackbarMessage: StringRes.deleteBillErrorMsg));
      log("error delete: ${error.toString()}");
    }
  }

  void onRecognizeImage(RecognizeBillEvent event, Emitter<HomeState> emitter) async {
    XFile? image = await event.imagePicker.pickImage(source: (event.isFromCamera) ? ImageSource.camera : ImageSource.gallery);
    if (image != null) {
      emitter(HomeState(bills: state.bills, isLoading: true));
      RecognizedText recognizedText = await event.textRecognizer.processImage(
          InputImage.fromFilePath(image.path));
      Bill result = BillRecognizer(recognizedText).recognize();
      event.textRecognizer.close();
      emitter(HomeState(bills: state.bills, scannedBill: result));
    }
  }
}

abstract class HomeEvent {}

class InitHomeEvent extends HomeEvent {}

class DeleteBillEvent extends HomeEvent {
  int index;

  DeleteBillEvent(this.index);
}

class RecognizeBillEvent extends HomeEvent {
  bool isFromCamera;
  ImagePicker imagePicker;
  TextRecognizer textRecognizer;

  RecognizeBillEvent(this.imagePicker, this.textRecognizer, {this.isFromCamera = false});
}

class HomeState {
  bool isLoading;
  bool isErrorInit;
  List<Bill> bills;
  String? snackbarMessage;
  Bill? scannedBill;

  HomeState({required this.bills, this.isLoading = false, this.isErrorInit = false, this.snackbarMessage, this.scannedBill});
}