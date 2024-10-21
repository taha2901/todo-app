import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/features/home/ui/widgets/task_item_widget.dart';
import 'package:todo/features/layout/presentation/manager/layout_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutCubit, LayoutState>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = LayoutCubit.get(context).tasks;
        return Scaffold(
          body: tasks.isEmpty
              ? const Center(child: Text('No tasks yet!'))
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return TaskItemWidget(tasks: tasks[index]);
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: tasks.length,
                ),
        );
      },
    );
  }
}
