import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'inventory_event.dart';
import 'inventory_repository.dart';
import 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryRepository reportRepository;
  InventoryBloc({required this.reportRepository}) : super(InventoryInitial()) {
    on<GetInventory>(_getInventory);
    on<GetInventoryById>(_getInventoryById);
    on<AddInventoryEvent>(_addInventory);
    on<UpdateInventory>(_updateInventory);
    on<DeleteInventory>(_deleteInventoryType);
  }

  Future<void> _getInventory(
      InventoryEvent event, Emitter<InventoryState> emit) async {
    emit(GetInventoryLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await InventoryRepository.getInventory(
          token: MyLocalStorage().getToken(),
        );

        reportRepository.clearReportList();
        reportRepository.dataList = getModel.data;
        Logger.println('getModel list data::$getModel');
        emit(GetInventoryLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetInventoryError(errors: e.message));
      }
    } else {
      emit(GetInventoryError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _getInventoryById(
      InventoryEvent event, Emitter<InventoryState> emit) async {
    emit(GetInventoryByIdLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await InventoryRepository.getInventoryById(
          token: MyLocalStorage().getToken(),
          id: event.id,
        );

        Logger.println('getModel list data::$getModel');
        emit(GetInventoryByIdLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetInventoryByIdError(errors: e.message));
      }
    } else {
      emit(GetInventoryError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addInventory(
      AddInventoryEvent event, Emitter<InventoryState> emit) async {
    emit(GetInventoryLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await InventoryRepository.addInventory(
          token: MyLocalStorage().getToken(),
          inventoryName: event.inventoryName,
          amount: event.amount,
          serialNo: event.serialNo,
          purchaseDate: event.purchaseDate,
          endWarrantyDate: event.endWarrantyDate,
        );

        Logger.println('getModel list data::$getModel');
        emit(AddInventoryLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(AddInventoryError(errors: e.message));
      }
    } else {
      emit(AddInventoryError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateInventory(
      InventoryEvent event, Emitter<InventoryState> emit) async {
    emit(UpdateInventoryLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await InventoryRepository.updateInventory(
          id: event.id.toString(),
          inventoryName: event.inventoryName,
          amount: event.amount,
          serialNo: event.serialNo,
          purchaseDate: event.purchaseDate,
          endWarrantyDate: event.endWarrantyDate,
        );

        emit(UpdateInventoryLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdateInventoryError(errors: e.message));
      }
    } else {
      emit(UpdateInventoryError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteInventoryType(
      InventoryEvent event, Emitter<InventoryState> emit) async {
    emit(GetInventoryLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await InventoryRepository.deleteInventory(id: event.id.toString());

        emit(DeleteInventoryLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteInventoryError(errors: e.message));
      }
    } else {
      emit(DeleteInventoryError(errors: Strings.offlineMsg));
    }
  }
}
