import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/features/home/home.dart';
import 'package:todo/features/layout/presentation/manager/layout_cubit.dart';


class GlucoLayout extends StatefulWidget {
  const GlucoLayout({super.key});

  @override
  State<GlucoLayout> createState() => _GlucoLayoutState();
}

class _GlucoLayoutState extends State<GlucoLayout> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  void _scheduleNotification(String title, String date, String time) {
  try {
    DateTime scheduledDateTime = DateFormat('MMM dd, yyyy hh:mm a').parse('$date $time');

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'scheduled',
        title: title,
        body: 'Your task "$title" is scheduled for ${DateFormat('yyyy-MM-dd – kk:mm').format(scheduledDateTime)}',
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar.fromDate(date: scheduledDateTime),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification scheduled for ${DateFormat('yyyy-MM-dd – kk:mm').format(scheduledDateTime)}')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error scheduling notification: ${e.toString()}')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {
        // if (state is AppInsertDatabaseState) {
        //   Navigator.pop(context);
        // }
      },
      builder: (context, state) {
        var cubit = LayoutCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.person, color: Colors.blue),
              onPressed: () {},
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.blue),
                onPressed: () {
                  showSearch(
                      context: context, delegate: TaskSearchDelegate());
                },
              ),
              IconButton(
                icon: Icon(
                  cubit.isDark ? Icons.wb_sunny : Icons.nights_stay,
                  color: Colors.blue,
                ),
                onPressed: () {
                  cubit.toggleTheme();
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                context: context,
                isScrollControlled: true,
                builder: (context) => Padding(
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
                                dateController.text =
                                    DateFormat.yMMMd().format(value);
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).appBarTheme.backgroundColor,
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              cubit.insertToDatabase(
                                title: titleController.text,
                                time: timeController.text,
                                date: dateController.text,
                              );

                              _scheduleNotification(
                                titleController.text,
                                dateController.text,
                                timeController.text,
                              );
                            }
                          },
                          child: const Text('Add Task'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNavBar(index);
            },
            items: cubit.getBottomItems(),
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
          ),
        );
      },
    );
  }
}
