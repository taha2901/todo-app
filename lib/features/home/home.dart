import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo/features/layout/presentation/manager/layout_cubit.dart';
import 'package:todo/features/layout/presentation/view/edit_task_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {
        if (state is AppInsertDatabaseState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var tasks = LayoutCubit.get(context).tasks;
        return tasks.isEmpty
            ? const Center(child: Text('No tasks yet!'))
            : ListView.separated(
                itemBuilder: (context, index) {
                  return BuildTaskItem(
                    tasks: tasks[index],
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: tasks.length,
              );
      },
    );
  }
}

class BuildTaskItem extends StatelessWidget {
  final Map tasks;

  const BuildTaskItem({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Text(
              tasks['time'],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tasks['title'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  tasks['date'],
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: Colors.orange),
                    SizedBox(width: 8),
                    Text("Edit"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share, color: Colors.grey),
                    SizedBox(width: 8),
                    Text("Share"),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text("Delete"),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => EditTaskSheet(
                    task: tasks,
                  ),
                );
              } else if (value == 'share') {
                shareTask(context);
              } else if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Delete"),
                      content: const Text(
                          "Are you sure you want to delete this task?"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text("Delete"),
                          onPressed: () {
                            LayoutCubit.get(context)
                                .deleteData(id: tasks['id']);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
          IconButton(
            onPressed: () {
              LayoutCubit.get(context)
                  .updateData(status: 'done', id: tasks['id']);
            },
            icon: const Icon(Icons.check_box),
            color: Colors.green,
          ),
          IconButton(
            onPressed: () {
              // LayoutCubit.get(context)
              //     .updateData(status: 'share', id: tasks['id']);
            },
            icon: const Icon(Icons.archive),
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  void shareTask(BuildContext context) {
    final taskDetails =
        'Task: ${tasks['title']}\nDate: ${tasks['date']}\nTime: ${tasks['time']}';
    Share.share(taskDetails);
  }
}





class TaskSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // إعادة تعيين الاستعلام عند الضغط على زر المسح
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // يمكن تنفيذ البحث هنا
    final cubit = LayoutCubit.get(context);
    return FutureBuilder<List<Map>>(
      future: cubit.searchTasks(query), // استدعاء وظيفة البحث
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return BuildTaskItem(tasks: snapshot.data![index]);
            },
          );
        } else {
          return const Center(child: Text('No tasks found'));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // يمكن تقديم الاقتراحات هنا إذا كنت ترغب في ذلك
    return Container(); // أو أي شيء آخر تراه مناسبًا
  }
}
