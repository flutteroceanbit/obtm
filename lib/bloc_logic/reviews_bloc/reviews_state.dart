import 'package:equatable/equatable.dart';

import '../../models/review/add_review_model.dart';
import '../../models/review/get_all_employee_review_model.dart';
import '../../models/review/get_review_model.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();
}

class ReviewInitial extends ReviewState {
  @override
  List<Object?> get props => [];
}

class GetReviewLoading extends ReviewState {
  @override
  List<Object?> get props => [];
}

class GetReviewLoaded extends ReviewState {
  final GetAllEmployeeReviewModel data;
  const GetReviewLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class GetReviewError extends ReviewState {
  final dynamic errors;
  const GetReviewError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

class AddReviewLoading extends ReviewState {
  @override
  List<Object?> get props => [];
}

class AddReviewLoaded extends ReviewState {
  final AddReviewModel data;
  const AddReviewLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class AddReviewError extends ReviewState {
  final dynamic errors;
  const AddReviewError({this.errors});
  @override
  List<Object?> get props => [errors!];
}

// class UpdateReviewLoading extends ReviewState {
//   @override
//   List<Object?> get props => [];
// }
//
// class UpdateReviewLoaded extends ReviewState {
//   final UpdateReviewModel? data;
//   const UpdateReviewLoaded({this.data});
//   @override
//   List<Object?> get props => [];
// }
//
// class UpdateReviewError extends ReviewState {
//   final dynamic errors;
//   const UpdateReviewError({this.errors});
//   @override
//   List<Object?> get props => [errors!];
// }

class DeleteReviewLoading extends ReviewState {
  @override
  List<Object?> get props => [];
}

class DeleteReviewLoaded extends ReviewState {
  final dynamic data;
  const DeleteReviewLoaded({this.data});
  @override
  List<Object?> get props => [];
}

class DeleteReviewError extends ReviewState {
  final dynamic errors;
  const DeleteReviewError({this.errors});
  @override
  List<Object?> get props => [errors!];
}
