import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/trail_repository.dart';
import 'trail_event.dart';
import 'trail_state.dart';

class TrailBloc extends Bloc<TrailEvent, TrailState> {
  final TrailRepository repository;
  
  String _currentFilter = 'all';
  String _currentSearch = '';

  TrailBloc({required this.repository}) : super(TrailInitial()) {
    on<LoadTrailsEvent>(_onLoadTrails);
    on<AddTrailEvent>(_onAddTrail);
    on<ToggleTrailStatusEvent>(_onToggleStatus);
    on<DeleteTrailEvent>(_onDeleteTrail);
  }

  Future<void> _onLoadTrails(LoadTrailsEvent event, Emitter<TrailState> emit) async {
    if (event.filter != null) _currentFilter = event.filter!;
    if (event.searchQuery != null) _currentSearch = event.searchQuery!;

    emit(TrailLoading());
    try {
      final trails = await repository.fetchTrails(filter: _currentFilter, search: _currentSearch);
      emit(TrailLoaded(trails, _currentFilter, _currentSearch));
    } catch (e) {
      emit(TrailError('Ошибка подключения к серверу. Убедитесь, что backend запущен.\n$e'));
    }
  }

  Future<void> _onAddTrail(AddTrailEvent event, Emitter<TrailState> emit) async {
    try {
      await repository.addTrail(event.name, event.altitude, event.difficulty, event.notes);
      add(const LoadTrailsEvent());
    } catch (e) {
      emit(TrailError(e.toString()));
    }
  }

  Future<void> _onToggleStatus(ToggleTrailStatusEvent event, Emitter<TrailState> emit) async {
    try {
      await repository.toggleTrailStatus(event.id);
      add(const LoadTrailsEvent());
    } catch (e) {
      emit(TrailError(e.toString()));
    }
  }

  Future<void> _onDeleteTrail(DeleteTrailEvent event, Emitter<TrailState> emit) async {
    try {
      await repository.deleteTrail(event.id);
      add(const LoadTrailsEvent());
    } catch (e) {
      emit(TrailError(e.toString()));
    }
  }
}