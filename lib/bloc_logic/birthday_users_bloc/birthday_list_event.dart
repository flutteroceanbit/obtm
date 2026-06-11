part of 'birthday_list_bloc.dart';

abstract class BirthdayListEvent extends Equatable {
  const BirthdayListEvent();

  get month => null;
  get context => null;
}

class FetchUserBirthdayEvent extends BirthdayListEvent {
  @override
  final String month;
  @override
  final BuildContext context;
  const FetchUserBirthdayEvent({required this.month, required this.context});
  @override
  List<Object?> get props => [];
}
