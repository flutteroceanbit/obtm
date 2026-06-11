import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';

import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'reset_password_event.dart';
import 'reset_password_repository.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<ResetEvent>(_addHoliday);
  }

  Future<void> _addHoliday(
      ResetEvent event, Emitter<ResetPasswordState> emit) async {
    emit(ResetPasswordLoading());
    Logger.println('token resetPassword ::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await ResetPassword.resetPassword(
          token: MyLocalStorage().getToken(),
          id: event.id,
        );
        emit(ResetPasswordLoaded(data: model));
      } on ServiceException catch (e) {
        emit(ResetPasswordError(errors: e.message));
      }
    } else {
      emit(const ResetPasswordError(errors: Strings.offlineMsg));
    }
  }
}
