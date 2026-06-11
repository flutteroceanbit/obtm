import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';

import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'add_holiday_event.dart';
import 'add_holiday_repository.dart';
import 'add_holiday_state.dart';

class AddHolidayBloc extends Bloc<AddHolidayWithType, AddHolidayState> {
  AddHolidayBloc() : super(AddHolidayInitial()) {
    on<AddHolidayWithType>(_addHoliday);
  }

  Future<void> _addHoliday(
      AddHolidayWithType event, Emitter<AddHolidayState> emit) async {
    emit(AddHolidayLoading());
    Logger.println('token from add report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await AddHoliday.addHoliday(
            token: MyLocalStorage().getToken(),
            holidayTypeId: event.holidayTypeId,
            startDate: event.startDate,
            endDate: event.endDate,
            desc: event.description);
        emit(AddHolidayLoaded(data: model));
      } on ServiceException catch (e) {
        emit(AddHolidayError(errors: e.message));
      }
    } else {
      emit(const AddHolidayError(errors: Strings.offlineMsg));
    }
  }
}
