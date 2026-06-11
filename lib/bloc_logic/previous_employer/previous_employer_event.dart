import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class PreviousEmployerEvent extends Equatable {
  const PreviousEmployerEvent();

  get context => null;
  get id => null;
  get userId => null;
  get companyName => null;
  get profileDesignation => null;
  get salaryPerYear => null;
  get companyMail => null;
  get companyWebsite => null;
  get companyContactNo => null;
}

class GetPreviousEmployerEvent extends PreviousEmployerEvent {
  const GetPreviousEmployerEvent({required this.context, required this.id});

  @override
  final BuildContext context;
  @override
  final int id;

  @override
  List<Object?> get props => [];
}

class AddPreviousEmployerEvent extends PreviousEmployerEvent {
  @override
  final int userId;
  @override
  final String companyName;
  @override
  final String profileDesignation;
  @override
  final String salaryPerYear;
  @override
  final String companyMail;
  @override
  final String companyWebsite;
  @override
  final String companyContactNo;
  @override
  final BuildContext context;

  const AddPreviousEmployerEvent(
      this.userId,
      this.companyName,
      this.profileDesignation,
      this.salaryPerYear,
      this.companyMail,
      this.companyWebsite,
      this.companyContactNo,
      {required this.context});

  @override
  List<Object?> get props => [];
}

class UpdatePreviousEmployerEvent extends PreviousEmployerEvent {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String companyName;
  @override
  final String profileDesignation;
  @override
  final String salaryPerYear;
  @override
  final String companyMail;
  @override
  final String companyWebsite;
  @override
  final String companyContactNo;
  @override
  final BuildContext context;

  const UpdatePreviousEmployerEvent(
      this.id,
      this.userId,
      this.companyName,
      this.profileDesignation,
      this.salaryPerYear,
      this.companyMail,
      this.companyWebsite,
      this.companyContactNo,
      {required this.context});

  @override
  List<Object?> get props => [];
}

class DeletePreviousEmployerEvent extends PreviousEmployerEvent {
  const DeletePreviousEmployerEvent({
    required this.context,
    required this.id,
  });

  @override
  final BuildContext context;
  @override
  final String id;

  @override
  List<Object?> get props => [];
}
