import 'package:bloc/bloc.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'designation_event.dart';
import 'designation_repository.dart';
import 'designation_state.dart';

class DesignationBloc extends Bloc<DesignationEvent, DesignationState> {
  DesignationRepository reportRepository;
  DesignationBloc({required this.reportRepository})
      : super(DesignationInitial()) {
    on<GetDesignation>(_getDesignation);
    on<AddDesignationEvent>(_addDesignation);
    on<UpdateDesignation>(_updateDesignation);
    on<DeleteDesignation>(_deleteDesignationType);
  }

  Future<void> _getDesignation(
      DesignationEvent event, Emitter<DesignationState> emit) async {
    emit(GetDesignationLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await DesignationRepository.getDesignation(
          token: MyLocalStorage().getToken(),
        );

        reportRepository.clearReportList();
        reportRepository.dataList = getModel.data;
        Logger.println('getModel list data::$getModel');
        emit(GetDesignationLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetDesignationError(errors: e.message));
      }
    } else {
      emit(const GetDesignationError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addDesignation(
      AddDesignationEvent event, Emitter<DesignationState> emit) async {
    emit(GetDesignationLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await DesignationRepository.addDesignation(
          token: MyLocalStorage().getToken(),
          name: event.name,
          shortName: event.shortName,
        );

        Logger.println('getModel list data::$getModel');
        emit(AddDesignationLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(AddDesignationError(errors: e.message));
      }
    } else {
      emit(const AddDesignationError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateDesignation(
      DesignationEvent event, Emitter<DesignationState> emit) async {
    emit(UpdateDesignationLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await DesignationRepository.updateDesignation(
          id: event.id.toString(),
          name: event.name,
          shortName: event.shortName,
        );

        emit(UpdateDesignationLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdateDesignationError(errors: e.message));
      }
    } else {
      emit(const UpdateDesignationError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteDesignationType(
      DesignationEvent event, Emitter<DesignationState> emit) async {
    emit(GetDesignationLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await DesignationRepository.deleteDesignation(id: event.id);

        emit(DeleteDesignationLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteDesignationError(errors: e.message));
      }
    } else {
      emit(const DeleteDesignationError(errors: Strings.offlineMsg));
    }
  }
}
