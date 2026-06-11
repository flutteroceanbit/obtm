import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';

import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'get_holiday_event.dart';
import 'get_holiday_repository.dart';
import 'get_holiday_state.dart';

class GetHolidayBloc extends Bloc<GetHolidayEvent, GetHolidayState> {
  GetHolidayRepository reportRepository;
  GetHolidayBloc({required this.reportRepository})
      : super(GetHolidayInitial()) {
    on<FetchHoliday>(_getHoliday);
    on<FetchHolidayByMonth>(_getHolidayByMonth);
    on<UpdateHoliday>(_updateHoliday);
    on<DeleteHoliday>(_deleteHolidayType);
  }

  Future<void> _getHoliday(
      GetHolidayEvent event, Emitter<GetHolidayState> emit) async {
    emit(GetHolidayLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await GetHolidayRepository.getHoliday(
          token: MyLocalStorage().getToken(),
        );

        reportRepository.clearReportList();
        reportRepository.dataList = getModel.data;
        Logger.println('getModel list data::$getModel');
        emit(GetHolidayLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetHolidayError(errors: e.message));
      }
    } else {
      emit(GetHolidayError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _getHolidayByMonth(
      FetchHolidayByMonth event, Emitter<GetHolidayState> emit) async {
    emit(GetHolidayByMonthLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await GetHolidayRepository.getHolidayByMonth(
          token: MyLocalStorage().getToken(),
        );

        reportRepository.clearReportList();
        reportRepository.holidayList = getModel.data;
        Logger.println('getModel list data::$getModel');
        emit(GetHolidayByMonthLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetHolidayByMonthError(errors: e.message));
      }
    } else {
      emit(GetHolidayByMonthError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateHoliday(
      GetHolidayEvent event, Emitter<GetHolidayState> emit) async {
    emit(UpdateHolidayLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await GetHolidayRepository.updateHoliday(
            id: event.id,
            holidayTypeId: event.holidayTypeId,
            startDate: event.startDate,
            endDate: event.endDate,
            desc: event.desc);

        emit(UpdateHolidayLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdateHolidayError(errors: e.message));
      }
    } else {
      emit(UpdateHolidayError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteHolidayType(
      GetHolidayEvent event, Emitter<GetHolidayState> emit) async {
    emit(GetHolidayLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await GetHolidayRepository.deleteHoliday(id: event.id);

        emit(DeleteHolidayLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteHolidayError(errors: e.message));
      }
    } else {
      emit(DeleteHolidayError(errors: Strings.offlineMsg));
    }
  }
}
