import 'package:equatable/equatable.dart';
import '../../data/models/trail_model.dart';

abstract class TrailState extends Equatable {
  const TrailState();
  @override
  List<Object?> get props => [];
}

class TrailInitial extends TrailState {}

class TrailLoading extends TrailState {}

class TrailLoaded extends TrailState {
  final List<TrailModel> trails;
  final String currentFilter;
  final String currentSearch;

  const TrailLoaded(this.trails, this.currentFilter, this.currentSearch);

  @override
  List<Object?> get props => [trails, currentFilter, currentSearch];
}

class TrailError extends TrailState {
  final String message;
  const TrailError(this.message);
  @override
  List<Object?> get props => [message];
}