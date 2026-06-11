part of 'birthday_list_bloc.dart';

abstract class BirthdayListState extends Equatable{
  @override
  List<Object?> get props => [];
}

class UserBirthdayInitialState extends BirthdayListState{
  @override
  List<Object?> get props => [];
}

class UserBirthdayLoadingState extends BirthdayListState{
  @override
  List<Object?> get props => [];
}

class UserBirthdayLoadedState extends BirthdayListState{
  final BirthdayOfMonthModel? data;
  UserBirthdayLoadedState({this.data});
  @override
  List<Object?> get props => [data!];
}

class UserBirthdayErrorState extends BirthdayListState{
  final dynamic error;
  UserBirthdayErrorState({this.error});
  @override
  List<Object?> get props => [error];
}