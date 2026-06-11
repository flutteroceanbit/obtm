import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/get_daily_report_model.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'get_daily_report_repository.dart';

part 'get_daily_report_event.dart';

part 'get_daily_report_state.dart';

class GetDailyReportBloc
    extends Bloc<GetDailyReportEvent, GetDailyReportState> {
  GetDailyReportRepository repository;

  GetDailyReportBloc({
    required this.repository,
  }) : super(GetDailyReportInitial()) {
    on<FetchGetDailyReport>(_getDailyReport);
    //on<FetchGetMonthlyReport>(_getMonthlyReport);
  }

  Future<void> _getDailyReport(
      GetDailyReportEvent event, Emitter<GetDailyReportState> emit) async {
    emit(GetDailyReportLoading());
    Logger.println('token from get report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        if (repository.page == 1) {
          repository.clearReportList();
          print('cren : ${repository.reportList}');
        }

        final getModel = await GetDailyReportRepository.getDailyReport(
            token: MyLocalStorage().getToken(), page: repository.page);

        repository.page++;
        repository.reportList = getModel.data ?? [];
        repository.totalReports = getModel.total ?? 0;

        repository.isLastPage =
            repository.reportList.length >= repository.totalReports;

        Logger.println("daily report list size=${getModel.data?.length}");
        emit(GetDailyReportLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetDailyReportError(errors: e.message));
      }
    } else {
      emit(const GetDailyReportError(errors: Strings.offlineMsg));
    }
  }
}
