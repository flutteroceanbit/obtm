part of 'add_update_personal_detail_bloc.dart';

abstract class AddUpdatePersonalDetailEvent extends Equatable {
  const AddUpdatePersonalDetailEvent();

  get id => null;

  get firstName => null;

  get lastName => null;
  get imageUrl => null;
  get file => null;
  get middleName => null;
  get fatherFullName => null;
  get fatherOccupation => null;

  get dob => null;

  get education => null;

  get gender => null;

  get bloodGroup => null;

  get aadharNumber => null;

  get panNumber => null;

  get context => null;
  get isActive => null;
}

class FetchAddUpdatePersonalDetailEvent extends AddUpdatePersonalDetailEvent {
  @override
  final int id;
  @override
  final String dob;
  @override
  final String gender;
  @override
  final String? middleName;
  @override
  final String? fatherFullName;
  @override
  final String? fatherOccupation;
  @override
  final String? education;
  @override
  final String? bloodGroup;
  @override
  final String? aadharNumber;
  @override
  final String? panNumber;
  @override
  final BuildContext context;

  const FetchAddUpdatePersonalDetailEvent(
      {required this.id,
      required this.dob,
      required this.gender,
      required this.context,
      this.middleName,
      this.fatherOccupation,
      this.fatherFullName,
      this.education,
      this.bloodGroup,
      this.aadharNumber,
      this.panNumber});

  @override
  List<Object?> get props => [];
}

class FetchUpdateUserEvent extends AddUpdatePersonalDetailEvent {
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final int id;
  @override
  final BuildContext context;

  const FetchUpdateUserEvent(
      {this.lastName, this.firstName, required this.id, required this.context});

  @override
  List<Object?> get props => [];
}

class FetchUpdateUserWithImageEvent extends AddUpdatePersonalDetailEvent {
  @override
  final String? firstName;
  @override
  final String? lastName;
  @override
  final String? imageUrl;
  @override
  final PlatformFile? file;
  @override
  final int id;
  @override
  final BuildContext context;

  const FetchUpdateUserWithImageEvent(this.imageUrl, this.file,
      {this.lastName, this.firstName, required this.id, required this.context});

  @override
  List<Object?> get props => [];
}

class FetchUpdateUserStatusEvent extends AddUpdatePersonalDetailEvent {
  @override
  final String? isActive;
  @override
  final int id;
  @override
  final BuildContext context;

  const FetchUpdateUserStatusEvent(this.isActive,
      {required this.id, required this.context});

  @override
  List<Object?> get props => [];
}
