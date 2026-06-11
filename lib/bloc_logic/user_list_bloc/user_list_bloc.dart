import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:oceanbit_timeclock/bloc_logic/user_list_bloc/user_list_repository.dart';
import 'package:oceanbit_timeclock/local_storage/my_local_storage.dart';
import 'package:oceanbit_timeclock/utils/exceptions/service_exception.dart';
import 'package:oceanbit_timeclock/utils/logger.dart';
import 'package:provider/provider.dart';

import '../../constant/strings.dart';
import '../../models/user_list_model.dart';
import '../../utils/check_network/connectivity_provider.dart';
part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent,UserListState>{
  UserListBloc() : super(GetUserListInitialState()) {
    on<FetchUserListEvent>(_getUserList);
  }
  Future<void> _getUserList(UserListEvent event, Emitter<UserListState> emit) async{
    emit(GetUserListLoadingState());

    if(Provider.of<ConnectivityProvider>(event.context,listen:false).isOnline){
      try {
        final model = await UserListRepository.getUserList(
            token: MyLocalStorage().getToken());
        emit(GetUserListLoadedState(data: model));
        Logger.println("Get User Model ::: $model");
      } on ServiceException catch (e) {
        emit(GetUserListErrorState(error: e.message));
      }
    }else{
      emit(GetUserListErrorState(error: Strings.offlineMsg));
    }
  }

}