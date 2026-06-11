import 'package:bloc/bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/systemfaults_bloc/systemfaults_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/systemfaults_bloc/systemfaults_repositories.dart';
import 'package:oceanbit_timeclock/bloc_logic/systemfaults_bloc/systemfaults_state.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class SystemFaultBloc extends Bloc<SystemFaultEvent, SystemFaultState> {
  SystemFaultsRepository repository;
  SystemFaultBloc({required this.repository}) : super(SystemFaultInitial()) {
    on<GetSystemFaultEvent>(_getSystemFault);
    on<GetAdminSystemFaultEvent>(_getAdminSystemFault);
    on<AddSystemFaultEvent>(_addSystemFault);
    on<UpdateSystemFaultEvent>(_updateSystemFault);
    on<UpdateAdminSystemFaultEvent>(_updateAdminSystemFault);
    on<DeleteSystemFaultEvent>(_deleteBankInfo);
  }

  Future<void> _getSystemFault(
      GetSystemFaultEvent event, Emitter<SystemFaultState> emit) async {
    emit(GetSystemFaultLoading());
    Logger.println('token from get report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await SystemFaultsRepository.getSystemFaults(
            token: MyLocalStorage().getToken());

        emit(GetSystemFaultLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetSystemFaultError(errors: e.message));
      }
    } else {
      emit(const GetSystemFaultError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _getAdminSystemFault(
      GetAdminSystemFaultEvent event, Emitter<SystemFaultState> emit) async {
    emit(GetAdminSystemFaultLoading());
    Logger.println('token from get report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await SystemFaultsRepository.adminSystemFaultsByUser(
          token: MyLocalStorage().getToken(),
        );

        emit(GetAdminSystemFaultLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetAdminSystemFaultError(errors: e.message));
      }
    } else {
      emit(const GetAdminSystemFaultError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addSystemFault(
      AddSystemFaultEvent event, Emitter<SystemFaultState> emit) async {
    emit(AddSystemFaultLoading());
    Logger.println('token from add report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await SystemFaultsRepository.addSystemFaults(
          token: MyLocalStorage().getToken(),
          systemType: event.systemType,
          description: event.description,
        );
        emit(AddSystemFaultLoaded(data: model));
      } on ServiceException catch (e) {
        emit(AddSystemFaultError(errors: e.message));
      }
    } else {
      emit(const AddSystemFaultError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateSystemFault(
      UpdateSystemFaultEvent event, Emitter<SystemFaultState> emit) async {
    emit(UpdateSystemFaultLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await SystemFaultsRepository.updateSystemFaults(
          id: event.id,
          systemType: event.systemType,
          description: event.description,
        );

        emit(UpdateSystemFaultLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdateSystemFaultError(errors: e.message));
      }
    } else {
      emit(const UpdateSystemFaultError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateAdminSystemFault(
      UpdateAdminSystemFaultEvent event, Emitter<SystemFaultState> emit) async {
    emit(UpdateAdminSystemFaultLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await SystemFaultsRepository.updateAdminSystemFaults(
          id: event.id,
          status: event.status,
        );

        emit(UpdateAdminSystemFaultLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdateAdminSystemFaultError(errors: e.message));
      }
    } else {
      emit(const UpdateAdminSystemFaultError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteBankInfo(
      DeleteSystemFaultEvent event, Emitter<SystemFaultState> emit) async {
    emit(DeleteSystemFaultLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await SystemFaultsRepository.deleteSystemFaults(id: event.id);

        emit(DeleteSystemFaultLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteSystemFaultError(errors: e.message));
      }
    } else {
      emit(const DeleteSystemFaultError(errors: Strings.offlineMsg));
    }
  }
}
