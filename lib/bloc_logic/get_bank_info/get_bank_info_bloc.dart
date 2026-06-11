import 'package:bloc/bloc.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_bank_info/get_bank_info_event.dart';
import 'package:oceanbit_timeclock/bloc_logic/get_bank_info/get_bank_info_state.dart';
import 'package:provider/provider.dart';

import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'get_bank_info_repositories.dart';

class BankInfoBloc extends Bloc<BankInfoEvent, GetBankInfoState> {
  BankInfoRepository reportRepository;
  BankInfoBloc({required this.reportRepository}) : super(GetBankInfoInitial()) {
    on<GetBankInfoEvent>(_getBankInfo);
    on<AddBankInfoEvent>(_addBankInfo);
    on<UpdateBankInfoEvent>(_updateBankInfo);
    on<DeleteBankInfoEvent>(_deleteBankInfo);
  }

  Future<void> _getBankInfo(
      GetBankInfoEvent event, Emitter<GetBankInfoState> emit) async {
    emit(GetBankInfoLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await BankInfoRepository.getBankInfo(
          token: MyLocalStorage().getToken(),
          id: event.id.toString(),
        );

        Logger.println('getModel list data::$getModel');
        emit(GetBankInfoLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(GetBankInfoError(errors: e.message));
      }
    } else {
      emit(const GetBankInfoError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addBankInfo(
      AddBankInfoEvent event, Emitter<GetBankInfoState> emit) async {
    emit(AddBankInfoLoading());
    Logger.println('token from add report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await BankInfoRepository.addBankInfo(
          token: MyLocalStorage().getToken(),
          userId: event.userId.toString(),
          accountNo: event.accountNo,
          accountType: event.accountType,
          bankName: event.bankName,
          branch: event.branch,
          ifscCode: event.ifscCode,
        );
        emit(AddBankInfoLoaded(data: model));
      } on ServiceException catch (e) {
        emit(AddBankInfoError(errors: e.message));
      }
    } else {
      emit(const AddBankInfoError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _updateBankInfo(
      UpdateBankInfoEvent event, Emitter<GetBankInfoState> emit) async {
    emit(UpdateBankInfoLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await BankInfoRepository.updateBankInfo(
          id: event.id.toString(),
          userId: event.userId,
          bankName: event.bankName,
          branch: event.branch,
          accountNo: event.accountNo,
          accountType: event.accountType,
          ifscCode: event.ifscCode,
        );

        emit(UpdateBankInfoLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(UpdateBankInfoError(errors: e.message));
      }
    } else {
      emit(const UpdateBankInfoError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _deleteBankInfo(
      DeleteBankInfoEvent event, Emitter<GetBankInfoState> emit) async {
    emit(DeleteBankInfoLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final getModel = await BankInfoRepository.deleteBankInfo(id: event.id);

        emit(DeleteBankInfoLoaded(data: getModel));
      } on ServiceException catch (e) {
        emit(DeleteBankInfoError(errors: e.message));
      }
    } else {
      emit(const DeleteBankInfoError(errors: Strings.offlineMsg));
    }
  }
}
