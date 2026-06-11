import 'package:equatable/equatable.dart';
import 'package:oceanbit_timeclock/models/add_bank_info_model.dart';
import 'package:oceanbit_timeclock/models/update_bank_info_model.dart';

import '../../models/get_bank_info.dart';
import '../../models/success_model.dart';

abstract class GetBankInfoState extends Equatable {
  const GetBankInfoState();
}

class GetBankInfoInitial extends GetBankInfoState {
  @override
  List<Object> get props => [];
}

class GetBankInfoLoading extends GetBankInfoState {
  @override
  List<Object> get props => [];
}

class GetBankInfoLoaded extends GetBankInfoState {
  const GetBankInfoLoaded({this.data});
  final GetBankInfoModel? data;
  @override
  List<Object> get props => [data!];
}

class GetBankInfoError extends GetBankInfoState {
  const GetBankInfoError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class AddBankInfoLoading extends GetBankInfoState {
  @override
  List<Object> get props => [];
}

class AddBankInfoLoaded extends GetBankInfoState {
  const AddBankInfoLoaded({this.data});
  final AddBankInfoModel? data;
  @override
  List<Object> get props => [data!];
}

class AddBankInfoError extends GetBankInfoState {
  const AddBankInfoError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class UpdateBankInfoLoading extends GetBankInfoState {
  @override
  List<Object> get props => [];
}

class UpdateBankInfoLoaded extends GetBankInfoState {
  const UpdateBankInfoLoaded({this.data});
  final UpdateBankInfoModel? data;
  @override
  List<Object> get props => [data!];
}

class UpdateBankInfoError extends GetBankInfoState {
  const UpdateBankInfoError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}

class DeleteBankInfoLoading extends GetBankInfoState {
  @override
  List<Object> get props => [];
}

class DeleteBankInfoLoaded extends GetBankInfoState {
  const DeleteBankInfoLoaded({this.data});
  final SuccessModel? data;
  @override
  List<Object> get props => [data!];
}

class DeleteBankInfoError extends GetBankInfoState {
  const DeleteBankInfoError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
