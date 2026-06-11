import 'package:bloc/bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_employee_report/get_employee_report_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_employee_report/get_employee_report_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_employee_report/get_employee_report_state.dart';
import 'package:provider/provider.dart';

import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class GetEmployeeReportBloc
    extends Bloc<GetEmployeeReportEvent, GetEmployeeReportState> {
  GetEmployeeReportRepository reportRepository;
  GetEmployeeReportBloc({required this.reportRepository})
      : super(GetEmployeeReportInitial()) {
    on<FetchEmployeeReport>(_getEmployeeReport);
  }

  Future<void> _getEmployeeReport(GetEmployeeReportEvent event,
      Emitter<GetEmployeeReportState> emit) async {
    emit(GetEmployeeReportLoading());
    Logger.println(
        'token from employee report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        if (reportRepository.page == 1) {
          reportRepository.clearReportList();
        }
        final getModel = await GetEmployeeReportRepository.getEmployeeReport(
            token: MyLocalStorage().getToken(),
            page: reportRepository.page.toString(),
            id: event.id,
            year: event.year.toString());
        if (reportRepository.page == 1) {
          reportRepository.clearReportList();
          reportRepository.totalReports = 0;
        }
        reportRepository.page++;
        reportRepository.dataList = getModel.data!;
        reportRepository.totalReports = getModel.total!;

        reportRepository.isLastPage =
            reportRepository.dataList.length >= reportRepository.totalReports;
        Logger.println(
            "daily report list size=${reportRepository.totalReports}");
        emit(GetEmployeeReportLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetEmployeeReportError(errors: e.message));
      }
    } else {
      emit(GetEmployeeReportError(errors: Strings.offlineMsg));
    }
  }
}
