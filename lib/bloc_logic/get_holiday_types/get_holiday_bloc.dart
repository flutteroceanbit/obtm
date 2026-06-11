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

class GetHolidayTypeBloc
    extends Bloc<GetHolidayTypeEvent, GetHolidayTypeState> {
  GetHolidayTypeRepository reportRepository;
  GetHolidayTypeBloc({required this.reportRepository})
      : super(GetHolidayTypeInitial()) {
    on<FetchHolidayType>(_getHolidayType);
    on<UpdateHolidayType>(_updateHolidayType);
    on<DeleteHolidayType>(_deleteHolidayType);
  }

  Future<void> _getHolidayType(
      GetHolidayTypeEvent event, Emitter<GetHolidayTypeState> emit) async {
    emit(GetHolidayTypeLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await GetHolidayTypeRepository.getHoliday(
          token: MyLocalStorage().getToken(),
        );

        reportRepository.clearReportList();
        reportRepository.dataList = getModel.data;
        Logger.println('getModel::$getModel');
        emit(GetHolidayTypeLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetHolidayTypeError(errors: e.message));
      }
    } else {
      emit(const GetHolidayTypeError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateHolidayType(
      GetHolidayTypeEvent event, Emitter<GetHolidayTypeState> emit) async {
    emit(GetHolidayTypeLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await GetHolidayTypeRepository.updateHolidayType(
            id: event.id, name: event.name, isMulti: event.isMulti);

        emit(UpdateHolidayTypeLoaded(data: getModel.data));
      } on ServiceException catch (e) {
        emit(UpdateHolidayTypeError(errors: e.message));
      }
    } else {
      emit(UpdateHolidayTypeError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteHolidayType(
      GetHolidayTypeEvent event, Emitter<GetHolidayTypeState> emit) async {
    emit(GetHolidayTypeLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await GetHolidayTypeRepository.deleteHolidayType(id: event.id);

        emit(DeleteHolidayTypeLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteHolidayTypeError(errors: e.message));
      }
    } else {
      emit(DeleteHolidayTypeError(errors: Strings.offlineMsg));
    }
  }
}
