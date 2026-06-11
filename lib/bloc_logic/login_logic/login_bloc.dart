import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constant/local_key.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/auth_model.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../common_repositories/preference_repository.dart';
import 'login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.preferenceManagerRepository) : super(LoginInitial()) {
    on<LoginEvent>(_fetchLogin);
  }

  final PreferenceManagerRepository preferenceManagerRepository;

  Future<void> _fetchLogin(LoginEvent event, Emitter<LoginState> emit) async {
    // if (event is FetchLogin) {
    emit(LoginLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await AuthRepository.login(
          email: event.email,
          password: event.password,
        );

        preferenceManagerRepository.user = model.data[0].user;
        /*SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          LocalStorageKeys.userData, jsonEncode(model.user));*/
        MyLocalStorage().write(LocalStorageKeys.token, model.token);
        MyLocalStorage()
            .write(LocalStorageKeys.userData, jsonEncode(model.data[0].user));

        MyLocalStorage().write(LocalStorageKeys.leaveData,
            jsonEncode(model.data[0].leaveBalances));

        // Strings.leaveList = model.data[0].leaveBalances.isEmpty
        //     ? [
        //         'Leave Without Pay(LWP)',
        //         'Sick Leave(SL)',
        //         'Privilege Leave(PL)',
        //         'Casual Leave(CL)'
        //       ]
        //     : [
        //         'Leave Without Pay(LWP)',
        //         'Sick Leave(SL)(${(MyLocalStorage().getLeave()?[0].remainingLeaves).toString().padLeft(2, '0')})',
        //         'Privilege Leave(PL)',
        //         'Casual Leave(CL)(${(MyLocalStorage().getLeave()?[1].remainingLeaves).toString().padLeft(2, '0')})'
        //       ];
        emit(LoginLoaded(data: model));
      } on ServiceException catch (e) {
        emit(LoginError(errors: e.message));
      }
    } else {
      emit(const LoginError(errors: Strings.offlineMsg));
    }
  }
}
