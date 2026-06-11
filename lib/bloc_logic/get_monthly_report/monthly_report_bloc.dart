import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../models/get_daily_report_model.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'monthly_report_repository.dart';
part 'monthly_report_event.dart';
part 'monthly_report_state.dart';

class MonthlyReportBloc extends Bloc<MonthlyReportEvent, MonthlyReportState> {
  MonthlyReportRepository? repository;
  // MonthlyReportRepository? monthlyReportRepository;
  MonthlyReportBloc({required this.repository})
      : super(MonthlyReportInitial()) {
    on<FetchMonthlyReport>(_getMonthlyReport);
  }
  int page = 1;
  bool isFetching = false;

  int year = 2023;
  Future<void> _getMonthlyReport(
      MonthlyReportEvent event, Emitter<MonthlyReportState> emit) async {
    emit(MonthlyReportLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await MonthlyReportRepository.getMonthlyReport(
            month: DateTime.now().month, year: DateTime.now().year, page: page);
        if (page == 1) {
          repository?.clearReportList();
        }
        Logger.println("monthly report list =${getModel.data}");
        repository?.monthlyReportList.addAll(getModel.data!);
        // repository?.totalOrderItem = getModel.total!;
        emit(MonthlyReportLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(MonthlyReportError(errors: e.message));
      }
    } else {
      emit(const MonthlyReportError(errors: Strings.offlineMsg));
    }
  }
}
