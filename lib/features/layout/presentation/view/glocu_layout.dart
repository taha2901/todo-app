import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/features/home/ui/widgets/task_search_widget.dart';
import 'package:todo/features/layout/presentation/manager/layout_cubit.dart';
import 'package:todo/features/layout/presentation/view/widgets/task_date_field.dart';
import 'package:todo/features/layout/presentation/view/widgets/task_time_field.dart';
import 'package:todo/features/layout/presentation/view/widgets/task_title_field.dart';

class GlucoLayout extends StatefulWidget {
  const GlucoLayout({super.key});

  @override
  State<GlucoLayout> createState() => _GlucoLayoutState();
}

class _GlucoLayoutState extends State<GlucoLayout> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController timeController;
  late final TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    timeController = TextEditingController();
    dateController = TextEditingController();
  }

  void _scheduleNotification(String title, String date, String time) {
    try {
      DateTime scheduledDateTime =
          DateFormat('MMM dd, yyyy hh:mm a').parse('$date $time');

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'scheduled',
          title: title,
          body:
              'Your task "$title" is scheduled for ${DateFormat('yyyy-MM-dd – kk:mm').format(scheduledDateTime)}',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar.fromDate(date: scheduledDateTime),
      );

      _showSnackBar(
          'Notification scheduled for ${DateFormat('yyyy-MM-dd – kk:mm').format(scheduledDateTime)}');
    } catch (e) {
      _showSnackBar('Error scheduling notification: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = LayoutCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
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
                  showSearch(context: context, delegate: TaskSearchWidget());
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
                        TaskTitleField(controller: titleController),
                        const SizedBox(height: 15),
                        TaskTimeField(controller: timeController),
                        const SizedBox(height: 15),
                        TaskDateField(controller: dateController),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).appBarTheme.backgroundColor),
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
                              Navigator.pop(
                                  context); // Close the modal after adding a task
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

  @override
  void dispose() {
    titleController.dispose();
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
