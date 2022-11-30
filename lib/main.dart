// ignore_for_file: prefer_const_constructor

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app_complete/blocs/workouts_cubit.dart';
import 'package:flutter_bloc_app_complete/screens/edit_workout_screen.dart';
import 'package:flutter_bloc_app_complete/screens/home_page.dart';
import 'package:flutter_bloc_app_complete/screens/workout_progress.dart';
import 'package:flutter_bloc_app_complete/states/workout_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'blocs/workout_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  HydratedBlocOverrides.runZoned(() => runApp(WorkoutTime()), storage: storage);
}

class WorkoutTime extends StatelessWidget {
  const WorkoutTime({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My workouts',
      theme: ThemeData(
          primaryColor: Colors.yellow,
          textTheme: const TextTheme(
            bodyText2: TextStyle(color: Color.fromARGB(255, 66, 74, 96)),
          )),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<WorkoutsCubit>(
            create: (BuildContext context) {
              WorkoutsCubit workoutsCubit = WorkoutsCubit();
              if (workoutsCubit.state.isEmpty) {
                print('loading state');
                workoutsCubit.getWorkouts();
              } else {
                //print('state is not null');
              }
              return workoutsCubit;
            },
          ),
          BlocProvider<WorkoutCubit>(
              create: (BuildContext context) => WorkoutCubit())
        ],
        child: BlocBuilder<WorkoutCubit, WorkoutState>(
          builder: (context, state) {
            if (state is WorkoutInitial) {
              return const HomePage();
            } else if (state is WorkoutEditing) {
              return const EditWorkoutScreen();
            }
            return const WorkoutProgress();
          },
        ),
      ),
    );
  }
}
