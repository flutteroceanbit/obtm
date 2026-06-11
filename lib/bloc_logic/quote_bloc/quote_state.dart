import 'package:equatable/equatable.dart';

import '../../models/quotes/add_quotes_model.dart';
import '../../models/quotes/get_quotes_model.dart';
import '../../models/quotes/update_quotes_model.dart';

abstract class QuoteState extends Equatable {
  const QuoteState();
}

class QuoteInitial extends QuoteState {
  @override
  List<Object?> get props => [];
}

class GetQuoteLoading extends QuoteState {
  @override
  List<Object?> get props => [];
}

class GetQuoteLoaded extends QuoteState {
  final GetQuoteModel data;
  const GetQuoteLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class GetQuoteError extends QuoteState {
  final dynamic errors;
  const GetQuoteError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class AddQuoteLoading extends QuoteState {
  @override
  List<Object?> get props => [];
}

class AddQuoteLoaded extends QuoteState {
  final AddQuoteModel data;
  const AddQuoteLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class AddQuoteError extends QuoteState {
  final dynamic errors;
  const AddQuoteError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class UpdateQuoteLoading extends QuoteState {
  @override
  List<Object?> get props => [];
}

class UpdateQuoteLoaded extends QuoteState {
  final UpdateQuoteModel? data;
  const UpdateQuoteLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class UpdateQuoteError extends QuoteState {
  final dynamic errors;
  const UpdateQuoteError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class DeleteQuoteLoading extends QuoteState {
  @override
  List<Object?> get props => [];
}

class DeleteQuoteLoaded extends QuoteState {
  final dynamic data;
  const DeleteQuoteLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class DeleteQuoteError extends QuoteState {
  final dynamic errors;
  const DeleteQuoteError({this.errors});
  @override
  List<Object?> get props => [errors!];
}
