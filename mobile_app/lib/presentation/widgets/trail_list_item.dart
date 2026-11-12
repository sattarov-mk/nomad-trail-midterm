import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/trail_model.dart';
import '../../logic/bloc/trail_bloc.dart';
import '../../logic/bloc/trail_event.dart';

class TrailListItem extends StatelessWidget {
  final TrailModel trail;
  
  const TrailListItem({super.key, required this.trail});

  Color _difficultyColor(String diff) {
    if (diff == 'Лёгкая') return Colors.green;
    if (diff == 'Сложная') return Colors.redAccent;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: Checkbox(
          value: trail.isCompleted,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (_) => context.read<TrailBloc>().add(ToggleTrailStatusEvent(trail.id)),
        ),
        title: Text(
          trail.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: trail.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Icon(Icons.landscape, size: 16, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 4),
              Text('${trail.altitude} м', style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _difficultyColor(trail.difficulty).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  trail.difficulty,
                  style: TextStyle(fontSize: 12, color: _difficultyColor(trail.difficulty), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.grey),
          onPressed: () => context.read<TrailBloc>().add(DeleteTrailEvent(trail.id)),
        ),
      ),
    );
  }
}
