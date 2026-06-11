import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/add_update_personal_detail_bloc/add_updtae_personal_detail_repository.dart';
import 'package:oceanbit_timeclock/models/add_update_profile_model.dart';
import 'package:oceanbit_timeclock/models/update_user.dart';
import 'package:provider/provider.dart';

import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
part 'add_update_personal_detail_event.dart';
part 'add_update_personal_detail_state.dart';

class AddUpdatePersonalDetailBloc
    extends Bloc<AddUpdatePersonalDetailEvent, AddUpdatePersonalDetailState> {
  AddUpdatePersonalDetailBloc() : super(AddUpdatePersonalDetailInitialState()) {
    on<FetchAddUpdatePersonalDetailEvent>(_fetchAddUpdatePersonalDetail);
    on<FetchUpdateUserEvent>(_fetchUpdateUser);
    on<FetchUpdateUserWithImageEvent>(_fetchUpdateUserWithImage);
    on<FetchUpdateUserStatusEvent>(_fetchUpdateUserStatus);
  }

  Future<void> _fetchAddUpdatePersonalDetail(AddUpdatePersonalDetailEvent event,
      Emitter<AddUpdatePersonalDetailState> emit) async {
    emit(AddUpdatePersonalDetailLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model =
            await AddUpdatePersonalDetailRepository.getAddUpdatePersonalDetail(
          token: MyLocalStorage().getToken(),
          id: event.id,
          middleName: event.middleName,
          fatherFullName: event.fatherFullName,
          fatherOccupation: event.fatherOccupation,
          dob: event.dob,
          education: event.education,
          gender: event.gender,
          boolGroup: event.bloodGroup,
          aadharCardNumber: event.aadharNumber,
          panCardNumber: event.panNumber,
        );
        emit(AddUpdatePersonalDetailLoaded(dataModel: model));
        Logger.println("Get User Detail Model id :::  ${event.id}");
        Logger.println("Get User Detail Model ::: ${model.data?.id}");
      } on ServiceException catch (e) {
        emit(AddUpdatePersonalDetailError(error: e.message));
      }
    } else {
      emit(AddUpdatePersonalDetailError(error: Strings.offlineMsg));
    }
  }

  Future<void> _fetchUpdateUser(AddUpdatePersonalDetailEvent event,
      Emitter<AddUpdatePersonalDetailState> emit) async {
    emit(UserUpdateLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await AddUpdatePersonalDetailRepository.updateUser(
          token: MyLocalStorage().getToken(),
          id: event.id,
          firstName: event.firstName,
          lastName: event.lastName,
        );
        emit(UserUpdateLoaded(dataModel: model));
      } on ServiceException catch (e) {
        emit(UserUpdateError(error: e.message));
      }
    } else {
      emit(UserUpdateError(error: Strings.offlineMsg));
    }
  }

  Future<void> _fetchUpdateUserWithImage(AddUpdatePersonalDetailEvent event,
      Emitter<AddUpdatePersonalDetailState> emit) async {
    emit(UserUpdateLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model =
            await AddUpdatePersonalDetailRepository.updateUserWithImage(
          token: MyLocalStorage().getToken(),
          id: event.id,
          firstName: event.firstName,
          lastName: event.lastName,
          image: event.imageUrl,
          file: event.file,
        );
        emit(UserUpdateLoaded(dataModel: model));
      } on ServiceException catch (e) {
        emit(UserUpdateError(error: e.message));
      }
    } else {
      emit(UserUpdateError(error: Strings.offlineMsg));
    }
  }

  Future<void> _fetchUpdateUserStatus(AddUpdatePersonalDetailEvent event,
      Emitter<AddUpdatePersonalDetailState> emit) async {
    emit(UserStatusUpdateLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await AddUpdatePersonalDetailRepository.updateUserStatus(
            token: MyLocalStorage().getToken(),
            id: event.id,
            isActive: event.isActive);
        emit(UserStatusUpdateLoaded(dataModel: model));
      } on ServiceException catch (e) {
        emit(UserStatusUpdateError(error: e.message));
      }
    } else {
      emit(UserStatusUpdateError(error: Strings.offlineMsg));
    }
  }
}
