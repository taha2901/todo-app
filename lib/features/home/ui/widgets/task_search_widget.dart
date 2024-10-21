import 'package:flutter/material.dart';
import 'package:todo/features/home/ui/widgets/task_item_widget.dart';
import 'package:todo/features/layout/presentation/manager/layout_cubit.dart';

class TaskSearchWidget extends SearchDelegate {
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
    final cubit = LayoutCubit.get(context);
    return FutureBuilder<List<Map>>(
      future: cubit.searchTasks(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return TaskItemWidget(tasks: snapshot.data![index]);
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
    return Container(); // يمكن تقديم الاقتراحات هنا
  }
}
