import 'package:bloc/bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/transport_bloc/transport_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/transport_bloc/transport_repository.dart';
import 'package:oceanbit_timeclock/bloc_logic/transport_bloc/transport_state.dart';
import 'package:provider/provider.dart';

import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';

class TransportBloc extends Bloc<TransportEvent, TransportState> {
  TransportRepository transportRepository;
  TransportBloc({required this.transportRepository})
      : super(TransportInitial()) {
    on<GetTransportEvent>(_getTransport);
    on<AddTransportEvent>(_addTransport);
    on<DeleteTransportEvent>(_deleteTransport);
  }

  Future<void> _getTransport(
      GetTransportEvent event, Emitter<TransportState> emit) async {
    emit(GetTransportLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await TransportRepository.getTransport(
          token: MyLocalStorage().getToken(),
          userId: event.userId.toString(),
        );

        Logger.println('getModel list data::$getModel');
        emit(GetTransportLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetTransportError(errors: e.message));
      }
    } else {
      emit(const GetTransportError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addTransport(
      AddTransportEvent event, Emitter<TransportState> emit) async {
    emit(AddTransportLoading());
    Logger.println('token from add report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        Logger.println('enter');
        final model = await TransportRepository.addTransport(
          token: MyLocalStorage().getToken(),
          transportName: event.transportName,
          transportNumber: event.transportNumber,
          filePath: event.rcBook,
          file: event.file,
          userId: event.userId.toString(),
        );
        Logger.println('add transport model :: ${model.data}');
        emit(AddTransportLoaded(data: model));
      } on ServiceException catch (e) {
        emit(AddTransportError(errors: e.message));
      }
    } else {
      emit(const AddTransportError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteTransport(
      DeleteTransportEvent event, Emitter<TransportState> emit) async {
    emit(DeleteTransportLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await TransportRepository.deleteTransport(id: event.id);

        emit(DeleteTransportLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteTransportError(errors: e.message));
      }
    } else {
      emit(const DeleteTransportError(errors: Strings.offlineMsg));
    }
  }
}
