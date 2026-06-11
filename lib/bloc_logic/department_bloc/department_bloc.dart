import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'department_event.dart';
import 'department_repository.dart';
import 'department_state.dart';

class MyDepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  DepartmentRepository reportRepository;
  MyDepartmentBloc({required this.reportRepository})
      : super(DepartmentInitial()) {
    on<GetDepartmentEvent>(_getDepartment);
    on<AddDepartmentEvent>(_addDepartment);
    on<UpdateDepartment>(_updateDepartment);
    on<DeleteDepartment>(_deleteDepartmentType);
  }

  Future<void> _getDepartment(
      GetDepartmentEvent event, Emitter<DepartmentState> emit) async {
    emit(GetDepartmentLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await DepartmentRepository.getDepartment(
          token: MyLocalStorage().getToken(),
        );

        reportRepository.clearReportList();
        reportRepository.dataList = getModel.data;
        Logger.println('getModel list data::$getModel');
        emit(GetDepartmentLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetDepartmentError(errors: e.message));
      }
    } else {
      emit(const GetDepartmentError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addDepartment(
      AddDepartmentEvent event, Emitter<DepartmentState> emit) async {
    emit(GetDepartmentLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await DepartmentRepository.addDepartment(
          token: MyLocalStorage().getToken(),
          name: event.name,
        );

        Logger.println('getModel list data::$getModel');
        emit(AddDepartmentLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(AddDepartmentError(errors: e.message));
      }
    } else {
      emit(const AddDepartmentError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateDepartment(
      DepartmentEvent event, Emitter<DepartmentState> emit) async {
    emit(UpdateDepartmentLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await DepartmentRepository.updateDepartment(
            id: event.id.toString(), name: event.name);

        emit(UpdateDepartmentLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdateDepartmentError(errors: e.message));
      }
    } else {
      emit(const UpdateDepartmentError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteDepartmentType(
      DepartmentEvent event, Emitter<DepartmentState> emit) async {
    emit(GetDepartmentLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await DepartmentRepository.deleteDepartment(id: event.id);

        emit(DeleteDepartmentLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteDepartmentError(errors: e.message));
      }
    } else {
      emit(const DeleteDepartmentError(errors: Strings.offlineMsg));
    }
  }
}
