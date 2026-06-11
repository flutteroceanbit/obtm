import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_last_daily_report_bloc/last_daily_report_repository.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/daily_report_model.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
part 'last_daily_report_event.dart';
part 'last_daily_report_state.dart';

class LastDailyReportBloc extends Bloc<LastDailyReportEvent,LastDailyReportState>{
  LastDailyReportBloc():super(GetLastDailyReportInitial()){
    on<FetchLastDailyReport>(_fetchLastDailyReport);
  }

  Future<void> _fetchLastDailyReport(LastDailyReportEvent event,Emitter<LastDailyReportState>emit) async{
    emit(GetLastDailyReportLoading());
    Logger.println('token from get report::${MyLocalStorage().getToken()}');
    if(Provider.of<ConnectivityProvider>(event.context,listen: false).isOnline){
      try {
        final getModel = await LastDailyReportRepository.getLastDailyReport(
            token: MyLocalStorage().getToken());
        emit(GetLastDailyReportLoaded(data: getModel));
        Logger.println("Get Model ::: ${getModel.data!.date}");
      } on ServiceException catch (e) {
        emit(GetLastDailyReportError(errors: e.message));
      }
    }else{
      emit(GetLastDailyReportError(errors: Strings.offlineMsg));
    }
  }

}