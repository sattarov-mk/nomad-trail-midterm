import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/trail_bloc.dart';
import '../../logic/bloc/trail_event.dart';
import '../../logic/bloc/trail_state.dart';
import '../widgets/trail_list_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showAddDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final altCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String diff = 'Средняя';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Новый маршрут'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Название (Ала-Арча)')),
                TextField(controller: altCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Высота (м)')),
                DropdownButtonFormField<String>(
                  value: diff,
                  decoration: const InputDecoration(labelText: 'Сложность'),
                  items: ['Лёгкая', 'Средняя', 'Сложная'].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (val) => setState(() => diff = val!),
                ),
                TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Заметки')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
            FilledButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty) {
                  context.read<TrailBloc>().add(AddTrailEvent(
                    nameCtrl.text, int.tryParse(altCtrl.text) ?? 0, diff, notesCtrl.text,
                  ));
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nomad Trail Log 🏔️', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск вершины...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
              onChanged: (val) => context.read<TrailBloc>().add(LoadTrailsEvent(searchQuery: val)),
            ),
          ),
        ),
      ),
      body: BlocBuilder<TrailBloc, TrailState>(
        builder: (context, state) {
          if (state is TrailLoading || state is TrailInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TrailError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Переподключиться'),
                      onPressed: () => context.read<TrailBloc>().add(const LoadTrailsEvent()),
                    )
                  ],
                ),
              ),
            );
          } else if (state is TrailLoaded) {
            final completedCount = state.trails.where((t) => t.isCompleted).length;
            final maxAlt = state.trails.isEmpty ? 0 : state.trails.map((t) => t.altitude).reduce((a, b) => a > b ? a : b);

            return RefreshIndicator(
              onRefresh: () async => context.read<TrailBloc>().add(const LoadTrailsEvent()),
              child: Column(
                children: [
                  // Блок статистики
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.tertiary]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Восхождения', style: TextStyle(color: Colors.white70, fontSize: 14)),
                            Text('$completedCount / ${state.trails.length}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Макс. высота', style: TextStyle(color: Colors.white70, fontSize: 14)),
                            Text('$maxAlt м', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Фильтры
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'all', label: Text('Все')),
                        ButtonSegment(value: 'completed', label: Text('Пройдены')),
                        ButtonSegment(value: 'planned', label: Text('В планах')),
                      ],
                      selected: {state.currentFilter},
                      onSelectionChanged: (val) => context.read<TrailBloc>().add(LoadTrailsEvent(filter: val.first)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Список
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.trails.length,
                      itemBuilder: (ctx, i) => TrailListItem(trail: state.trails[i]),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Маршрут'),
      ),
    );
  }
}