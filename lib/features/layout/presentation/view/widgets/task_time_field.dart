import 'package:flutter/material.dart';

class TaskTimeField extends StatelessWidget {
  final TextEditingController controller;

  const TaskTimeField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.datetime,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter task time';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Task Time',
        prefixIcon: Icon(Icons.watch_later),
        border: OutlineInputBorder(),
      ),
      onTap: () {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((value) {
          if (value != null) {
            controller.text = value.format(context);
          }
        });
      },
    );
  }
}