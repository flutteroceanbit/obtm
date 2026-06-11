import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'employee_credential_event.dart';
import 'employee_credential_repositories.dart';
import 'employee_credential_state.dart';

class EmployeeCredentialBloc
    extends Bloc<EmployeeCredentialEvent, EmployeeCredentialState> {
  EmployeeCredentialRepository reportRepository;
  EmployeeCredentialBloc({required this.reportRepository})
      : super(EmployeeCredentialInitial()) {
    on<GetEmployeeCredentialEvent>(_getEmployeeCredential);
    on<AddEmployeeCredentialEvent>(_addEmployeeCredential);
    on<UpdateEmployeeCredentialEvent>(_updateEmployeeCredential);
    on<DeleteEmployeeCredentialEvent>(_deleteEmployeeCredential);
  }

  Future<void> _getEmployeeCredential(GetEmployeeCredentialEvent event,
      Emitter<EmployeeCredentialState> emit) async {
    emit(GetEmployeeCredentialLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await EmployeeCredentialRepository.getEmployeeCredential(
          token: MyLocalStorage().getToken(),
          id: event.id.toString(),
        );

        Logger.println('getModel list data::$getModel');
        emit(GetEmployeeCredentialLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetEmployeeCredentialError(errors: e.message));
      }
    } else {
      emit(const GetEmployeeCredentialError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addEmployeeCredential(AddEmployeeCredentialEvent event,
      Emitter<EmployeeCredentialState> emit) async {
    emit(AddEmployeeCredentialLoading());
    Logger.println('token from add report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await EmployeeCredentialRepository.addEmployeeCredential(
          token: MyLocalStorage().getToken(),
          userId: event.userId.toString(),
          name: event.name,
          email: event.email,
          emailPassword: event.emailPassword,
          skypeName: event.skypeName,
          skypePassword: event.skypePassword,
        );
        emit(AddEmployeeCredentialLoaded(data: model));
      } on ServiceException catch (e) {
        emit(AddEmployeeCredentialError(errors: e.message));
      }
    } else {
      emit(const AddEmployeeCredentialError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateEmployeeCredential(UpdateEmployeeCredentialEvent event,
      Emitter<EmployeeCredentialState> emit) async {
    emit(UpdateEmployeeCredentialLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await EmployeeCredentialRepository.updateEmployeeCredential(
          id: event.id.toString(),
          userId: event.userId,
          name: event.name,
          email: event.email,
          emailPassword: event.emailPassword,
          skypeName: event.skypeName,
          skypePassword: event.skypePassword,
        );

        emit(UpdateEmployeeCredentialLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdateEmployeeCredentialError(errors: e.message));
      }
    } else {
      emit(const UpdateEmployeeCredentialError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteEmployeeCredential(DeleteEmployeeCredentialEvent event,
      Emitter<EmployeeCredentialState> emit) async {
    emit(DeleteEmployeeCredentialLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await EmployeeCredentialRepository.deleteEmployeeCredential(
                id: event.id);

        emit(DeleteEmployeeCredentialLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteEmployeeCredentialError(errors: e.message));
      }
    } else {
      emit(const DeleteEmployeeCredentialError(errors: Strings.offlineMsg));
    }
  }
}
