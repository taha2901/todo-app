import 'package:flutter/material.dart';

class TaskTitleField extends StatelessWidget {
  final TextEditingController controller;

  const TaskTitleField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter task title';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Task Title',
        prefixIcon: Icon(Icons.title),
        border: OutlineInputBorder(),
      ),
    );
  }
}