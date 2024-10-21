import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/features/layout/presentation/manager/layout_cubit.dart';

class EditTaskSheet extends StatefulWidget {
  final Map task;

  const EditTaskSheet({super.key, required this.task});

  @override
  // ignore: library_private_types_in_public_api
  _EditTaskSheetState createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<EditTaskSheet> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController timeController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task['title']);
    timeController = TextEditingController(text: widget.task['time']);
    dateController = TextEditingController(text: widget.task['date']);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
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
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: timeController,
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
                    timeController.text = value.format(context);
                  }
                });
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: dateController,
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
                    dateController.text = DateFormat.yMMMd().format(value);
                  }
                });
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  LayoutCubit.get(context).updateTask(
                    id: widget.task['id'],
                    title: titleController.text,
                    time: timeController.text,
                    date: dateController.text,
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
