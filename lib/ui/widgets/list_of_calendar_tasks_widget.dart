import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onenote/blocs/calendar_cubit.dart';
import 'package:flutter_onenote/models/task.dart';
import 'package:flutter_onenote/ui/widgets/task_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListOfCalendarTasks extends StatelessWidget {
  const ListOfCalendarTasks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<CalendarCubit,
              Stream<QuerySnapshot<Map<String, dynamic>>>>(
          builder: (context, stream) {
        return StreamBuilder(
            stream: stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Task task =
                        Task.fromJson(document.data() as Map<String, dynamic>);
                    return Padding(
                      padding: EdgeInsets.only(top: 15.h),
                      child: TaskWidget(
                        id: document.id,
                        task: task,
                        showTimePart: true,
                      ),
                    );
                  }).toList(),
                );
              }
              return Container();
            });
      }),
    );
  }
}
