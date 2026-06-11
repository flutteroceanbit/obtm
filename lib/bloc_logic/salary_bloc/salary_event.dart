part of 'salary_bloc.dart';

abstract class SalaryEvent extends Equatable {
  const SalaryEvent();

  get userId => null;

  get context => null;
}

class FetchSalaryEvent extends SalaryEvent {
  @override
  final int? userId;
  @override
  final BuildContext context;
  const FetchSalaryEvent({
    this.userId,
    required this.context,
  });

  @override
  List<Object?> get props => [];
}
