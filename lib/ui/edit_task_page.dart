import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onenote/blocs/tasks_cubit.dart';
import 'package:flutter_onenote/models/task.dart';
import 'package:flutter_onenote/resources/repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditTaskPage extends StatelessWidget {
  final Task task;
  final String id;
  const EditTaskPage({Key? key, required this.task, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController tagController = TextEditingController();

    titleController.text = task.getTitle;
    descriptionController.text = task.getDescription;
    tagController.text = task.getTag;

    return Scaffold(
        appBar: AppBar(
          title: const Text("Edit task"),
          actions: [RemoveButton(id: id)],
        ),
        body: BlocProvider(
          create: (_) => TasksCubit(task, id),
          child: Builder(builder: (context) {
            return Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  TextField(
                    onChanged: (value) =>
                        context.read<TasksCubit>().addTitle(value),
                    controller: titleController,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.w),
                      hintText: 'Title',
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextField(
                    onChanged: (value) =>
                        context.read<TasksCubit>().addDescription(value),
                    controller: descriptionController,
                    decoration: InputDecoration(
                      isCollapsed: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.w),
                      hintText: 'Description',
                    ),
                  ),
                  SizedBox(height: 20.h),
                  BlocBuilder<TasksCubit, Task>(builder: (context, localTask) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: localTask.getScheduled(false),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 5),
                              ).then((pickedDate) {
                                if (pickedDate == null) {
                                  return;
                                } else {
                                  context
                                      .read<TasksCubit>()
                                      .addDate(pickedDate);
                                }
                              });
                            },
                            child: Text(
                              localTask.getScheduled(true),
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        SizedBox(width: 30.w),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now())
                                  .then((pickedTime) {
                                if (pickedTime == null) {
                                  return;
                                } else {
                                  context
                                      .read<TasksCubit>()
                                      .addTime(pickedTime);
                                }
                              });
                            },
                            child: Text(
                              localTask.getScheduledTime,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        SizedBox(width: 30.w),
                        Expanded(
                          child: TextField(
                            onChanged: (value) =>
                                context.read<TasksCubit>().addTag(value),
                            controller: tagController,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.w),
                              hintText: '#tag',
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  const Expanded(child: SizedBox()),
                  Builder(builder: (context) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<TasksCubit>().updateTask();
                          Navigator.of(context).pop();
                        },
                        child: const Text("Apply"),
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
        ));
  }
}

class RemoveButton extends StatelessWidget {
  const RemoveButton({
    Key? key,
    required this.id,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 0) {
          Repository().removeTask(id);
          Navigator.pop(context);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          child: Text("Remove task"),
          value: 0,
        ),
      ],
    );
  }
}
