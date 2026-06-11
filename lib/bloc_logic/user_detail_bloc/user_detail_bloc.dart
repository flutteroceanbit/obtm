import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/user_detail_bloc/user_detail_repository.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/user_detail_model.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
part 'user_detail_event.dart';
part 'user_detail_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  UserDetailBloc() : super(UserDetailInitialState()) {
    on<FetchUserDetailEvent>(_fetchUserDetail);
    on<FetchUserProfileEvent>(_fetchUserProfile);
  }

  Future<void> _fetchUserDetail(
      UserDetailEvent event, Emitter<UserDetailState> emit) async {
    emit(UserDetailLoadingState());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await UserDetailRepository.getUserDetail(
            token: MyLocalStorage().getToken(), id: event.id);
        emit(UserDetailLoadedState(data: model.userData));
        Logger.println("Get User Detail Model id :::  ${event.id}");
        Logger.println("Get User Detail Model ::: ${model.userData?.id}");
      } on ServiceException catch (e) {
        emit(UserDetailErrorState(error: e.message));
      }
    } else {
      emit(UserDetailErrorState(error: Strings.offlineMsg));
    }
  }

  Future<void> _fetchUserProfile(
      UserDetailEvent event, Emitter<UserDetailState> emit) async {
    emit(UserProfileLoadingState());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await UserDetailRepository.getUserProfile(
          token: MyLocalStorage().getToken(),
        );
        emit(UserProfileLoadedState(data: model.userData));
        Logger.println("Get User Profile Model id :::  ${event.id}");
        Logger.println("Get User Profile Model ::: ${model.userData?.id}");
      } on ServiceException catch (e) {
        emit(UserProfileErrorState(error: e.message));
      }
    } else {
      emit(UserProfileErrorState(error: Strings.offlineMsg));
    }
  }
}
