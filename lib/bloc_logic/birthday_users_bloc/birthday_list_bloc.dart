import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:oceanbit_timeclock/bloc_logic/birthday_users_bloc/birthday_list_repository.dart';
import 'package:provider/provider.dart';

import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../models/birthday_of_month_model.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
part 'birthday_list_event.dart';
part 'birthday_list_state.dart';

class BirthdayListBloc extends Bloc<BirthdayListEvent,BirthdayListState>{
  BirthdayListBloc():super(UserBirthdayInitialState()){
    on<FetchUserBirthdayEvent>(_fetchUserBirthday);
  }

  Future<void> _fetchUserBirthday(BirthdayListEvent event,Emitter<BirthdayListState>emit) async{
    emit(UserBirthdayLoadingState());

    if(Provider.of<ConnectivityProvider>(event.context,listen:false).isOnline){
      try {
        final model = await BirthdayListRepository.getUsersBirthday(
          token: MyLocalStorage().getToken(),
          currentMonth: event.month,
        );
        emit(UserBirthdayLoadedState(data: model));
        Logger.println("Get birthday Detail Model ::: ${model.data}");
      } on ServiceException catch (e) {
        emit(UserBirthdayErrorState(error: e.message));
      }
    }else{
      emit(UserBirthdayErrorState(error: Strings.offlineMsg));
    }
  }
}