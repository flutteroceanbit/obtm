import 'package:bloc/bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/register_bloc/register_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/register_bloc/register_state.dart';
import 'package:oceanbit_timeclock/constant/strings.dart';
import 'package:provider/provider.dart';

import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../login_logic/login_repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState>{
  RegisterBloc() : super(RegisterInitialState()){
    on<FetchRegisterEvent>(_registerEmployee);
  }

  Future<void> _registerEmployee(RegisterEvent event,Emitter<RegisterState>emit) async{
    emit(RegisterLoadingState());
    if(Provider.of<ConnectivityProvider>(event.context,listen:false).isOnline){
      try {
        final model = await AuthRepository.register(
            firstName: event.firstName,
            lastName: event.lastName,
            email: event.email,
            phone: event.phone,
            password: event.password,
            confirmPassword: event.confirmPassword);
        emit(RegisterLoadedState(data: model));
      } on ServiceException catch (e) {
        emit(RegisterErrorState(error: e.message));
      }
    }else{
      emit(RegisterErrorState(error: Strings.offlineMsg));
    }
  }
}