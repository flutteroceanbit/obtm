import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class BankInfoEvent extends Equatable {
  const BankInfoEvent();

  get context => null;
  get id => null;
  get userId => null;
  get bankName => null;
  get branch => null;
  get accountNo => null;
  get accountType => null;
  get ifscCode => null;
}

class GetBankInfoEvent extends BankInfoEvent {
  const GetBankInfoEvent({required this.context, required this.id});

  @override
  final BuildContext context;
  @override
  final int id;

  @override
  List<Object?> get props => [];
}

class AddBankInfoEvent extends BankInfoEvent {
  @override
  final int userId;
  @override
  final String bankName;
  @override
  final String branch;
  @override
  final String accountType;
  @override
  final String accountNo;
  @override
  final String ifscCode;
  @override
  final BuildContext context;

  const AddBankInfoEvent(this.userId, this.bankName, this.branch,
      this.accountType, this.accountNo, this.ifscCode,
      {required this.context});

  @override
  List<Object?> get props => [];
}

class UpdateBankInfoEvent extends BankInfoEvent {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String bankName;
  @override
  final String branch;
  @override
  final String accountType;
  @override
  final String accountNo;
  @override
  final String ifscCode;
  @override
  final BuildContext context;

  const UpdateBankInfoEvent(this.id, this.userId, this.bankName, this.branch,
      this.accountType, this.accountNo, this.ifscCode,
      {required this.context});

  @override
  List<Object?> get props => [];
}

class DeleteBankInfoEvent extends BankInfoEvent {
  const DeleteBankInfoEvent({
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
