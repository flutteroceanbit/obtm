import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'employee_info_event.dart';
import 'employee_info_repository.dart';
import 'employee_info_state.dart';

class EmployeeInfoBloc extends Bloc<EmployeeInfoEvent, EmployeeInfoState> {
  EmployeeInfoRepository reportRepository;
  EmployeeInfoBloc({required this.reportRepository})
      : super(EmployeeInfoInitial()) {
    on<GetEmployeeInfo>(_getEmployeeInfo);
    on<GetEmployeeInfoDetail>(_getEmployeeInfoDetail);
    on<AddEmployeeInfoEvent>(_addEmployeeInfo);
    on<IncrementEvent>(_increment);
    on<UpdateEmployeeInfo>(_updateEmployeeInfo);
    on<DeleteEmployeeInfo>(_deleteEmployeeInfoType);
  }

  Future<void> _getEmployeeInfo(
      EmployeeInfoEvent event, Emitter<EmployeeInfoState> emit) async {
    emit(GetEmployeeInfoLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await EmployeeInfoRepository.getEmployeeInfo(
          token: MyLocalStorage().getToken(),
          userId: event.id.toString(),
        );

        reportRepository.clearReportList();
        reportRepository.dataList = getModel.data;
        Logger.println('getModel list data::$getModel');
        emit(GetEmployeeInfoLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetEmployeeInfoError(errors: e.message));
      }
    } else {
      emit(GetEmployeeInfoError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _getEmployeeInfoDetail(
      EmployeeInfoEvent event, Emitter<EmployeeInfoState> emit) async {
    emit(GetEmployeeInfoDetailLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await EmployeeInfoRepository.getEmployeeInfoDetail(
          token: MyLocalStorage().getToken(),
        );

        reportRepository.clearReportList();
        Logger.println('getModel list data::$getModel');
        emit(GetEmployeeInfoDetailLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetEmployeeInfoDetailError(errors: e.message));
      }
    } else {
      emit(GetEmployeeInfoDetailError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addEmployeeInfo(
      AddEmployeeInfoEvent event, Emitter<EmployeeInfoState> emit) async {
    emit(AddEmployeeInfoLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await EmployeeInfoRepository.addEmployeeInfo(
          token: MyLocalStorage().getToken(),
          userId: event.userId,
          departmentId: event.departmentId,
          designationId: event.designationId,
          period: event.period,
          basicSalary: event.basicSalary,
          startDate: event.startDate,
          hra: event.hra,
          da: event.da,
          ta: event.ta,
          securityDeposit: event.securityDeposit,
          monthlySecurityDeposit: event.monthlySecurityDeposit,
          bonusOne: event.bonusOne,
          bonusTwo: event.bonusTwo,
          minimumFullTime: event.minimumFullTime,
          minimumHalfTime: event.minimumHalfTime,
        );

        Logger.println('getModel list data::$getModel');
        emit(AddEmployeeInfoLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(AddEmployeeInfoError(errors: e.message));
      }
    } else {
      emit(AddEmployeeInfoError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _increment(
      IncrementEvent event, Emitter<EmployeeInfoState> emit) async {
    emit(IncrementLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await EmployeeInfoRepository.increment(
          token: MyLocalStorage().getToken(),
          userId: event.userId,
          departmentId: event.departmentId,
          designationId: event.designationId,
          basicSalary: event.basicSalary,
          startDate: event.startDate,
          hra: event.hra,
          period: event.period,
          da: event.da,
          ta: event.ta,
          securityDeposit: event.securityDeposit,
          monthlySecurityDeposit: event.monthlySecurityDeposit,
          bonusOne: event.bonusOne,
          bonusTwo: event.bonusTwo,
          minimumFullTime: event.minimumFullTime,
          minimumHalfTime: event.minimumHalfTime,
        );

        Logger.println('getModel list data::$getModel');
        emit(IncrementLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(IncrementError(errors: e.message));
      }
    } else {
      emit(IncrementError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateEmployeeInfo(
      EmployeeInfoEvent event, Emitter<EmployeeInfoState> emit) async {
    emit(UpdateEmployeeInfoLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await EmployeeInfoRepository.updateEmployeeInfo(
          userId: event.userId,
          departmentId: event.departmentId,
          designationId: event.designationId,
          period: event.period,
          basicSalary: event.basicSalary,
          startDate: event.startDate,
          hra: event.hra,
          da: event.da,
          ta: event.ta,
          securityDeposit: event.securityDeposit,
          monthlySecurityDeposit: event.monthlySecurityDeposit,
          bonusOne: event.bonusOne,
          bonusTwo: event.bonusTwo,
          minimumFullTime: event.minimumFullTime,
          minimumHalfTime: event.minimumHalfTime,
        );

        emit(UpdateEmployeeInfoLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdateEmployeeInfoError(errors: e.message));
      }
    } else {
      emit(UpdateEmployeeInfoError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteEmployeeInfoType(
      EmployeeInfoEvent event, Emitter<EmployeeInfoState> emit) async {
    emit(GetEmployeeInfoLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await EmployeeInfoRepository.deleteEmployeeInfo(id: event.id);

        emit(DeleteEmployeeInfoLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteEmployeeInfoError(errors: e.message));
      }
    } else {
      emit(DeleteEmployeeInfoError(errors: Strings.offlineMsg));
    }
  }
}
