import 'package:equatable/equatable.dart';

import '../../models/get_ocean_team_model.dart';

abstract class OceanTeamState extends Equatable {
  const OceanTeamState();
}

class OceanTeamInitial extends OceanTeamState {
  @override
  List<Object?> get props => [];
}

class GetOceanTeamLoading extends OceanTeamState {
  @override
  List<Object?> get props => [];
}

class GetOceanTeamLoaded extends OceanTeamState {
  final OceanTeamModel data;
  const GetOceanTeamLoaded({required this.data});
  @override
  List<Object?> get props => [];
}

class GetOceanTeamError extends OceanTeamState {
  final dynamic errors;
  const GetOceanTeamError({this.errors});
  @override
  List<Object?> get props => [errors!];
}
