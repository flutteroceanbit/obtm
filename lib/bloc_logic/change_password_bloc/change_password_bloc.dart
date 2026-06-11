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
import 'change_password_repository.dart';
part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ChangePasswordInitial()) {
    on<PasswordEvent>(_addDailyReport);
  }

  Future<void> _addDailyReport(
      ChangePasswordEvent event, Emitter<ChangePasswordState> emit) async {
    emit(ChangePasswordLoading());
    Logger.println('token from add report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await ChangePasswordRepository.changePassword(
            currentPassword: event.currentPassword,
            newPassword: event.newPassword,
            confirmPassword: event.confirmPassword,
            token: MyLocalStorage().getToken());
        emit(ChangePasswordLoaded(data: model));
      } on ServiceException catch (e) {
        emit(ChangePasswordError(errors: e.message));
      }
    } else {
      emit(const ChangePasswordError(errors: Strings.offlineMsg));
    }
  }
}
