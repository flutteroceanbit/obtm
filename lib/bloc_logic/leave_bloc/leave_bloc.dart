import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'leave_event.dart';
import 'leave_repositories.dart';
import 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  LeaveRepository reportRepository;
  LeaveBloc({required this.reportRepository}) : super(LeaveInitial()) {
    on<GetLeaveEvent>(_getLeave);
    on<AddLeaveEvent>(_addLeave);
    on<GetLeaveByUserEvent>(_getLeaveByUser);
    on<GetUserLeaveEvent>(_getUserLeave);
    on<UpdateLeaveEvent>(_updateLeave);
    on<DeleteLeaveEvent>(_deleteBankInfo);
  }

  Future<void> _getLeave(GetLeaveEvent event, Emitter<LeaveState> emit) async {
    emit(GetLeaveLoading());
    Logger.println('token from get report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        if (reportRepository.page == 1) {
          reportRepository.clearReportList();
        }
        print('reportRepository.page :: ${reportRepository.page}');
        final getModel = await LeaveRepository.getLeave(
            token: MyLocalStorage().getToken(),
            page: reportRepository.page,
            text: event.text,
            endDate: event.endDate,
            status: event.status,
            startDate: event.startDate);

        print(
            'data :: ${getModel.lastPage} :: last page ${reportRepository.page}');

        reportRepository.page++;
        reportRepository.reportList = getModel.data;
        reportRepository.totalReports = getModel.total;
        reportRepository.isLastPage =
            reportRepository.reportList.length >= reportRepository.totalReports;
        // reportRepository.isLoading = false;

        Logger.println("daily report list size=${getModel.data.length}");
        emit(GetLeaveLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetLeaveError(errors: e.message));
      }
    } else {
      emit(const GetLeaveError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _getLeaveByUser(
      GetLeaveByUserEvent event, Emitter<LeaveState> emit) async {
    emit(GetLeaveByUserLoading());
    Logger.println('token from get report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        if (reportRepository.page == 1) {
          reportRepository.clearReportList();
        }

        final getModel = await LeaveRepository.getLeaveByUser(
            token: MyLocalStorage().getToken(),
            page: reportRepository.page,
            userId: event.userId);

        reportRepository.page++;
        reportRepository.totalReports = getModel.total;
        reportRepository.isLastPage =
            getModel.data.length >= reportRepository.totalReports;
        emit(GetLeaveByUserLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetLeaveByUserError(errors: e.message));
      }
    } else {
      emit(const GetLeaveByUserError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _getUserLeave(
      GetUserLeaveEvent event, Emitter<LeaveState> emit) async {
    emit(GetUserLeaveLoading());
    Logger.println('token from get report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        if (reportRepository.page == 1) {
          reportRepository.clearReportList();
        }

        final getModel = await LeaveRepository.getUserLeave(
          token: MyLocalStorage().getToken(),
          page: reportRepository.page,
        );

        reportRepository.page++;
        reportRepository.totalReports = getModel.total;
        reportRepository.isLastPage =
            getModel.data.length >= reportRepository.totalReports;

        emit(GetUserLeaveLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetLeaveByUserError(errors: e.message));
      }
    } else {
      emit(const GetLeaveByUserError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addLeave(AddLeaveEvent event, Emitter<LeaveState> emit) async {
    emit(AddLeaveLoading());
    Logger.println('token from add report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await LeaveRepository.addLeave(
          token: MyLocalStorage().getToken(),
          startDate: event.startDate,
          endDate: event.endDate,
          reason: event.reason,
          leaveTypeValue: event.leaveTypeValue,
          leaveValue: event.leaveValue,
        );
        emit(AddLeaveLoaded(data: model));
      } on ServiceException catch (e) {
        emit(AddLeaveError(errors: e.message));
      }
    } else {
      emit(const AddLeaveError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateLeave(
      UpdateLeaveEvent event, Emitter<LeaveState> emit) async {
    emit(UpdateLeaveLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await LeaveRepository.updateLeave(
          userId: event.userId,
          leaveId: event.leaveId,
          leaveStatusValue: event.leaveStatusValue,
        );

        emit(UpdateLeaveLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdateLeaveError(errors: e.message));
      }
    } else {
      emit(const UpdateLeaveError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteBankInfo(
      DeleteLeaveEvent event, Emitter<LeaveState> emit) async {
    emit(DeleteLeaveLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await LeaveRepository.deleteLeave(
            id: event.id, leaveId: event.id.toString());

        emit(DeleteLeaveLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteLeaveError(errors: e.message));
      }
    } else {
      emit(const DeleteLeaveError(errors: Strings.offlineMsg));
    }
  }
}
