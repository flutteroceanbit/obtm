import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/daily_report_model.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'add_daily_report_repository.dart';
part 'add_daily_report_event.dart';
part 'add_daily_report_state.dart';

class AddDailyReportBloc
    extends Bloc<AddDailyReportEvent, AddDailyReportState> {
  AddDailyReportBloc() : super(AddDailyReportInitial()) {
    on<AddReportEvent>(_addDailyReport);
  }

  Future<void> _addDailyReport(
      AddDailyReportEvent event, Emitter<AddDailyReportState> emit) async {
    emit(AddDailyReportLoading());
    Logger.println('token from add report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await AddDailyReportRepository.addDailyReport(
            reportText: event.reportText,
            totalTime: event.totalTime,
            intermediateTime: event.intermediateTime,
            token: MyLocalStorage().getToken());
        emit(AddDailyReportLoaded(data: model));
      } on ServiceException catch (e) {
        emit(AddDailyReportError(errors: e.message));
      }
    } else {
      emit(const AddDailyReportError(errors: Strings.offlineMsg));
    }
  }
}
