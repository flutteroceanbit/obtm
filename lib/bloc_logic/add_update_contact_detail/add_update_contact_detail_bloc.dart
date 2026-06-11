import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import 'add_update_contact_detail_event.dart';
import 'add_update_contact_detail_repository.dart';
import 'add_update_contact_detail_state.dart';

class AddUpdateContactDetailBloc extends Bloc<AddUpdateContactDetailEvent,AddUpdateContactDetailState>{
  AddUpdateContactDetailBloc():super(AddUpdateContactDetailInitialState()){
    on<FetchAndUpdateContactDetailEvent>(_fetchAddUpdatePersonalDetail);
  }

  Future<void> _fetchAddUpdatePersonalDetail(AddUpdateContactDetailEvent event,Emitter<AddUpdateContactDetailState>emit) async{
    emit(AddUpdateContactDetailLoading());

    if(Provider.of<ConnectivityProvider>(event.context,listen:false).isOnline){
      try {
        final model =
            await AddUpdateContactDetailRepository.getAddUpdatePersonalDetail(
                token: MyLocalStorage().getToken(),
                id: event.id,
                email: event.email,
                permanentAddress: event.permanentAddress,
                correspondenceAddress: event.correspondenceAddress,
                parentsPhone: event.parentsPhone);
        emit(AddUpdateContactDetailLoaded(addUpdateContactDetailModel: model));
      } on ServiceException catch (e) {
        emit(AddUpdateContactDetailError(error: e.message));
      }
    }else{
      emit(AddUpdateContactDetailError(error: Strings.offlineMsg));
    }
  }
}