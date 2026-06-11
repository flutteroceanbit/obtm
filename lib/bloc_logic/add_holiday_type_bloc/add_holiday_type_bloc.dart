import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';

import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'add_holiday_type_event.dart';
import 'add_holiday_type_repository.dart';
import 'add_holiday_type_state.dart';

class AddHolidayTypeBloc
    extends Bloc<AddHolidayTypeEvent, AddHolidayTypeState> {
  AddHolidayTypeBloc() : super(AddHolidayTypeInitial()) {
    on<AddHolidayTypeForEvent>(_addHolidayType);
  }

  Future<void> _addHolidayType(
      AddHolidayTypeForEvent event, Emitter<AddHolidayTypeState> emit) async {
    emit(AddHolidayTypeLoading());
    Logger.println('token from add report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await AddHolidayType.addHolidayType(
            name: event.name,
            isMulti: event.isMulti,
            token: MyLocalStorage().getToken());
        emit(AddHolidayTypeLoaded(data: model));
      } on ServiceException catch (e) {
        emit(AddHolidayTypeError(errors: e.message));
      }
    } else {
      emit(const AddHolidayTypeError(errors: Strings.offlineMsg));
    }
  }
}
