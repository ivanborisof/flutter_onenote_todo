import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onenote/blocs/tasks_cubit.dart';
import 'package:flutter_onenote/models/task.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TasksCubit(
          Task(
            title: "",
            description: "description",
            scheduled: Timestamp.fromDate(DateTime.now()),
            creationDate: FieldValue.serverTimestamp(),
            tag: "#tag",
            done: false,
          ),
          "id"),
      child: Builder(builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
              20.w, 20.w, 20.w, MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 60.h,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) =>
                      context.read<TasksCubit>().addTitle(value),
                  autofocus: true,
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Business check tomorrow at 9:30'),
                ),
                BlocBuilder<TasksCubit, Task>(builder: (context, state) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: state.getScheduled(false),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 5),
                            ).then((pickedDate) {
                              if (pickedDate == null) {
                                return;
                              } else {
                                context.read<TasksCubit>().addDate(pickedDate);
                              }
                            });
                          },
                          child: Text(
                            state.getScheduled(true),
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(width: 30.w),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((pickedTime) {
                              if (pickedTime == null) {
                                return;
                              } else {
                                context.read<TasksCubit>().addTime(pickedTime);
                              }
                            });
                          },
                          child: Text(
                            state.getScheduledTime,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      SizedBox(width: 30.w),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                            onTap: () {},
                            child: TextField(
                              onChanged: (value) =>
                                  context.read<TasksCubit>().addTag(value),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 10.w),
                                hintText: '#tag',
                              ),
                            )),
                      ),
                      const Expanded(flex: 1, child: SizedBox()),
                      InkWell(
                        onTap: () {
                          context.read<TasksCubit>().addTaskToDB();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  );
                })
              ],
            ),
          ),
        );
      }),
    );
  }
}
