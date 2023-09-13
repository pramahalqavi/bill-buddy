import 'package:billbuddy/model/result.dart';
import 'package:billbuddy/repository/bill_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../database/entity/bill_entity.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BillRepository billRepository;
  HomeBloc(super.initialState, this.billRepository) {
    on<InitHomeEvent>(initHome);
  }

  void initHome(InitHomeEvent event, Emitter<HomeState> emitter) async {
    emitter(HomeState(Result(Status.Loading)));
    try {
      List<BillEntity> bills = await billRepository.getBills();
      emitter(HomeState(Result(Status.Success, data: bills)));
    } catch (error) {
      emitter(HomeState(Result(Status.Error)));
    }
  }
}

abstract class HomeEvent {}

class InitHomeEvent extends HomeEvent {}

class HomeState {
  Result<List<BillEntity>> billsResult;
  HomeState(this.billsResult);

  Status getStatus() {
    return billsResult.status;
  }

  List<BillEntity> getBills() {
    return billsResult.data ?? [];
  }
}