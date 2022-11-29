// ignore_for_file: prefer_const_constructor

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app_complete/blocs/workouts_cubit.dart';
import 'package:flutter_bloc_app_complete/screens/edit_workout_screen.dart';
import 'package:flutter_bloc_app_complete/screens/home_page.dart';
import 'package:flutter_bloc_app_complete/states/workout_state.dart';

import 'blocs/workout_cubit.dart';

void main() => runApp(WorkoutTime());

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
      home: /*BlocProvider<WorkoutCubit>(
        create: (BuildContext context) {
          WorkoutCubit workoutsCubit = WorkoutCubit();
          if (workoutsCubit.state.isEmpty) {
            print('loading state');
            workoutsCubit.getWorkouts();
          } else {
            print('state is not null');
          }
          return workoutsCubit;
        },
        child: BlocBuilder<WorkoutCubit, List<Workout>>(
          builder: (context, state) {
            return const HomePage();
          },
        ),
      )*/MultiBlocProvider(
          providers: [
            BlocProvider<WorkoutsCubit>(
              create: (BuildContext context) {
                WorkoutsCubit workoutsCubit = WorkoutsCubit();
                if (workoutsCubit.state.isEmpty) {
                  print('loading state');
                  workoutsCubit.getWorkouts();
                } else {
                  print('state is not null');
                }
                return workoutsCubit;
              },
            ),
            BlocProvider<WorkoutCubit>(create: (BuildContext context) => WorkoutCubit())
      ],
      child: BlocBuilder<WorkoutCubit, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutInitial) {
            return const HomePage();
          } else if (state is WorkoutEditing) {
            return EditWorkoutScreen();
          }
          return Container();
        },
      ),
    ),);
  }
}
