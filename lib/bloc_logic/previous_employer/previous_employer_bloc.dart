import 'package:bloc/bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/previous_employer/previous_employer_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/previous_employer/previous_employer_state.dart';
import 'package:provider/provider.dart';

import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'previous_employer_repositories.dart';

class PreviousEmployerBloc
    extends Bloc<PreviousEmployerEvent, PreviousEmployerState> {
  PreviousEmployerRepository reportRepository;
  PreviousEmployerBloc({required this.reportRepository})
      : super(PreviousEmployerInitial()) {
    on<GetPreviousEmployerEvent>(_getPreviousEmployer);
    on<AddPreviousEmployerEvent>(_addPreviousEmployer);
    on<UpdatePreviousEmployerEvent>(_updatePreviousEmployer);
    on<DeletePreviousEmployerEvent>(_deletePreviousEmployer);
  }

  Future<void> _getPreviousEmployer(GetPreviousEmployerEvent event,
      Emitter<PreviousEmployerState> emit) async {
    emit(GetPreviousEmployerLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await PreviousEmployerRepository.getPreviousEmployer(
          token: MyLocalStorage().getToken(),
          id: event.id.toString(),
        );

        Logger.println('getModel list data::$getModel');
        emit(GetPreviousEmployerLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetPreviousEmployerError(errors: e.message));
      }
    } else {
      emit(const GetPreviousEmployerError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addPreviousEmployer(AddPreviousEmployerEvent event,
      Emitter<PreviousEmployerState> emit) async {
    emit(AddPreviousEmployerLoading());
    Logger.println('token from add report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await PreviousEmployerRepository.addPreviousEmployer(
          token: MyLocalStorage().getToken(),
          userId: event.userId.toString(),
          companyName: event.companyName,
          profileDesignation: event.profileDesignation,
          salaryPerYear: event.salaryPerYear,
          companyMail: event.companyMail,
          companyWebsite: event.companyWebsite,
          companyContactNo: event.companyContactNo,
        );
        emit(AddPreviousEmployerLoaded(data: model));
      } on ServiceException catch (e) {
        emit(AddPreviousEmployerError(errors: e.message));
      }
    } else {
      emit(const AddPreviousEmployerError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updatePreviousEmployer(UpdatePreviousEmployerEvent event,
      Emitter<PreviousEmployerState> emit) async {
    emit(UpdatePreviousEmployerLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await PreviousEmployerRepository.updatePreviousEmployer(
          id: event.id.toString(),
          userId: event.userId,
          companyName: event.companyName,
          profileDesignation: event.profileDesignation,
          salaryPerYear: event.salaryPerYear,
          companyMail: event.companyMail,
          companyWebsite: event.companyWebsite,
          companyContactNo: event.companyContactNo,
        );

        emit(UpdatePreviousEmployerLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdatePreviousEmployerError(errors: e.message));
      }
    } else {
      emit(const UpdatePreviousEmployerError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deletePreviousEmployer(DeletePreviousEmployerEvent event,
      Emitter<PreviousEmployerState> emit) async {
    emit(DeletePreviousEmployerLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel =
            await PreviousEmployerRepository.deletePreviousEmployer(
                id: event.id);

        emit(DeletePreviousEmployerLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeletePreviousEmployerError(errors: e.message));
      }
    } else {
      emit(const DeletePreviousEmployerError(errors: Strings.offlineMsg));
    }
  }
}
