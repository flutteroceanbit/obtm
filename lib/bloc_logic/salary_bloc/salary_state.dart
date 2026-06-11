part of 'salary_bloc.dart';

abstract class SalaryState extends Equatable {
  const SalaryState();
}

class SalaryInitial extends SalaryState {
  @override
  List<Object> get props => [];
}

class SalaryLoading extends SalaryState {
  @override
  List<Object> get props => [];
}

class SalaryLoaded extends SalaryState {
  const SalaryLoaded({required this.data});
  final SalaryModel data;
  @override
  List<Object> get props => [data];
}

class SalaryError extends SalaryState {
  const SalaryError({this.errors});
  final dynamic errors;
  @override
  List<Object> get props => [errors!];
}
