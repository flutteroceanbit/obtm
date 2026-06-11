import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:oceanbit_timeclock/models/get_salary_model.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../local_storage/my_local_storage.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'salary_repository.dart';
part 'salary_event.dart';
part 'salary_state.dart';

class SalaryBloc extends Bloc<SalaryEvent, SalaryState> {
  SalaryRepository repository;

  SalaryBloc({required this.repository}) : super(SalaryInitial()) {
    on<FetchSalaryEvent>(_getSalary);
  }

  Future<void> _getSalary(SalaryEvent event, Emitter<SalaryState> emit) async {
    emit(SalaryLoading());
    Logger.println('token from add report::${MyLocalStorage().getToken()}');

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        if (repository.page == 1) {
          repository.clearReportList();
        }
        final model = await SalaryRepository.getSalary(
            userId: event.userId,
            page: repository.page,
            limit: repository.limit,
            token: MyLocalStorage().getToken());

        repository.page++;
        repository.reportList = model.data;
        repository.totalReports = model.total;
        repository.isLastPage =
            repository.reportList.length >= repository.totalReports;

        emit(SalaryLoaded(data: model));
      } on ServiceException catch (e) {
        emit(SalaryError(errors: e.message));
      }
    } else {
      emit(const SalaryError(errors: Strings.offlineMsg));
    }
  }
}
