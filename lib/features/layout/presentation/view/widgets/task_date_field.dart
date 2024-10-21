import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskDateField extends StatelessWidget {
  final TextEditingController controller;

  const TaskDateField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.datetime,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter task date';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Task Date',
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(),
      ),
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.parse('2025-12-31'),
        ).then((value) {
          if (value != null) {
            controller.text = DateFormat.yMMMd().format(value);
          }
        });
      },
    );
  }
}
