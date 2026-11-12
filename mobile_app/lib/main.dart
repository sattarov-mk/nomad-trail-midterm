import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/trail_repository.dart';
import 'logic/bloc/trail_bloc.dart';
import 'logic/bloc/trail_event.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const NomadApp());
}

class NomadApp extends StatelessWidget {
  const NomadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => TrailRepository(),
      child: BlocProvider(
        create: (context) => TrailBloc(repository: context.read<TrailRepository>())..add(const LoadTrailsEvent()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Nomad Trail Log',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32), brightness: Brightness.light),
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
