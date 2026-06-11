import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class QuoteEvent extends Equatable {
  const QuoteEvent();
  get context => null;
  get id => null;
  get quotes => null;
}

class GetQuoteEvent extends QuoteEvent {
  const GetQuoteEvent({required this.context});

  @override
  final BuildContext context;

  @override
  List<Object?> get props => [];
}

class AddQuoteEvent extends QuoteEvent {
  const AddQuoteEvent({
    required this.context,
    required this.quotes,
  });

  @override
  final BuildContext context;
  @override
  final String quotes;

  @override
  List<Object?> get props => [];
}

class UpdateQuote extends QuoteEvent {
  const UpdateQuote(
      {required this.context, required this.quotes, required this.id});

  @override
  final BuildContext context;
  @override
  final int id;
  @override
  final String quotes;

  @override
  List<Object?> get props => [];
}

class DeleteQuote extends QuoteEvent {
  const DeleteQuote({
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
