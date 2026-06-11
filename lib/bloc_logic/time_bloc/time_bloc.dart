import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:oceanbit_timeclock/models/add_time_slot_model.dart';
import 'package:oceanbit_timeclock/models/chart_data_model.dart';
import 'package:oceanbit_timeclock/models/get_all_time_slot_model.dart';
import 'package:provider/provider.dart';
import '../../constant/strings.dart';
import '../../models/add_local_time_slot_model.dart';
import '../../utils/check_network/connectivity_provider.dart';
import '../../utils/exceptions/service_exception.dart';
import '../../utils/logger.dart';
import 'time_repository.dart';

part 'time_event.dart';
part 'time_state.dart';

class TimeBloc extends Bloc<TimeEvent, TimeState> {
  TimeBloc(this.timeRepository) : super(TimeInitial()) {
    on<AddTimeSlotEvent>(_addTimeSlot);
    on<AddLocalTimeSlotEvent>(_addLocalTimeSlot);
    on<FetchTime>(_getAllTimeSlot);
    on<FetchTodayLastTimeSlot>(_getTodayLastTimeSlot);
    on<FetchCurrentMonthChartData>(_getCurrentMonthChartData);
  }

  final TimeRepository timeRepository;

  Future<void> _addTimeSlot(TimeEvent event, Emitter<TimeState> emit) async {
    // if (event is FetchTime) {
    emit(AddTimeSlotLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await TimeRepository.addTimeWithStatus(
            timerStatus: event.timerStatus, dateTime: event.dateTime);

        emit(AddTimeSlotLoaded(data: model));
      } on ServiceException catch (e) {
        emit(AddTimeSlotError(errors: e.message));
      }
    } else {
      emit(AddTimeSlotError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _addLocalTimeSlot(
      TimeEvent event, Emitter<TimeState> emit) async {
    // if (event is FetchTime) {
    emit(AddLocalTimeSlotLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await TimeRepository.addLocalTimeWithStatus(
            data: {'data': event.localTimeSlotList});

        Logger.println('add local time slot data response==$model');
        emit(const AddLocalTimeSlotLoaded());
      } on ServiceException catch (e) {
        emit(AddLocalTimeSlotError(errors: e.message));
      }
    } else {
      emit(AddLocalTimeSlotError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _getAllTimeSlot(TimeEvent event, Emitter<TimeState> emit) async {
    // if (event is FetchTime) {
    emit(GetTimeSlotLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await TimeRepository.getAllTimeSlotData();

        emit(GetTimeSlotLoaded(data: model));
      } on ServiceException catch (e) {
        emit(GetTimeSlotError(errors: e.message));
      }
    } else {
      emit(GetTimeSlotError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _getTodayLastTimeSlot(
      TimeEvent event, Emitter<TimeState> emit) async {
    // if (event is FetchTime) {
    emit(GetLastTimeSlotLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await TimeRepository.getTodayLastTimeSlotData();

        emit(GetLastTimeSlotLoaded(data: model));
      } on ServiceException catch (e) {
        emit(GetLastTimeSlotError(errors: e.message));
      }
    } else {
      emit(GetLastTimeSlotError(errors: Strings.offlineMsg));
    }
  }

  Future<void> _getCurrentMonthChartData(
      TimeEvent event, Emitter<TimeState> emit) async {
    // if (event is FetchTime) {
    emit(GetCurrentMonthChartDataLoading());

    if (Provider.of<ConnectivityProvider>(event.context, listen: false)
        .isOnline) {
      try {
        final model = await TimeRepository.getCurrentMonthChartData();

        emit(GetCurrentMonthChartDataLoaded(data: model));
      } on ServiceException catch (e) {
        emit(GetCurrentMonthChartDataError(errors: e.message));
      }
    } else {
      emit(GetCurrentMonthChartDataError(errors: Strings.offlineMsg));
    }
  }
}
