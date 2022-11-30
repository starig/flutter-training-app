// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app_complete/blocs/workouts_cubit.dart';
import 'package:flutter_bloc_app_complete/models/workout.dart';
import 'package:numberpicker/numberpicker.dart';

import '../helpers.dart';

class EditExerciseScreen extends StatefulWidget {
  final Workout? workout;
  final int? index;
  final int? exIndex;

  const EditExerciseScreen({Key? key, this.workout, this.index, this.exIndex})
      : super(key: key);

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  TextEditingController? _title;

  @override
  void initState() {
    _title = TextEditingController(
        text: widget.workout!.exercises[widget.exIndex!].title);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onLongPress: () => showDialog(context: context, builder: (_) {
                  final controller = TextEditingController(
                    text: widget.workout!.exercises[widget.exIndex!].prelude!.toString()
                  );
                  return AlertDialog(
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Prelude (seconds)'
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    actions: [
                      TextButton(onPressed: () {
                        if(controller.text.isNotEmpty) {
                          Navigator.pop(context);
                          setState(() {
                            widget.workout!.exercises[widget.exIndex!] = widget
                                .workout!.exercises[widget.exIndex!]
                                .copyWith(prelude: int.parse(controller.text));
                          });
                        }
                      }, child: Text('save'))
                    ],
                  );
                }),
                child: NumberPicker(
                  itemHeight: 30,
                  value: widget.workout!.exercises[widget.exIndex!].prelude!,
                  minValue: 0,
                  maxValue: 3599,
                  textMapper: (strVal) => formatTime(int.parse(strVal), false),
                  onChanged: (value) => setState(() {
                    widget.workout!.exercises[widget.exIndex!] = widget
                        .workout!.exercises[widget.exIndex!]
                        .copyWith(prelude: value);
                  }),
                ),
              ),
            ),
            Expanded(
              flex: 3,
                child: TextField(
              textAlign: TextAlign.center,
              controller: _title,
              onChanged: (value) {
                setState(() {
                  widget.workout!.exercises[widget.exIndex!] = widget
                      .workout!.exercises[widget.exIndex!]
                      .copyWith(title: value);
                });
                BlocProvider.of<WorkoutsCubit>(context).saveWorkout(
                  widget.workout!,
                  widget.index!,
                );
              },
            )),
            Expanded(
              child: InkWell(
                onLongPress: () => showDialog(context: context, builder: (_) {
                  final controller = TextEditingController(
                      text: widget.workout!.exercises[widget.exIndex!].duration!.toString()
                  );
                  return AlertDialog(
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                          labelText: 'Duration (seconds)'
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    actions: [
                      TextButton(onPressed: () {
                        if(controller.text.isNotEmpty) {
                          Navigator.pop(context);
                          setState(() {
                            widget.workout!.exercises[widget.exIndex!] = widget
                                .workout!.exercises[widget.exIndex!]
                                .copyWith(duration: int.parse(controller.text));
                          });
                        }
                      }, child: Text('save'))
                    ],
                  );
                }),
                child: NumberPicker(
                  itemHeight: 30,
                  value: widget.workout!.exercises[widget.exIndex!].duration!,
                  minValue: 0,
                  maxValue: 3599,
                  textMapper: (strVal) => formatTime(int.parse(strVal), false),
                  onChanged: (value) => setState(() {
                    widget.workout!.exercises[widget.exIndex!] = widget
                        .workout!.exercises[widget.exIndex!]
                        .copyWith(duration: value);
                  }),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
