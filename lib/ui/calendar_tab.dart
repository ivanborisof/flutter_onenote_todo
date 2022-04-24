import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:flutter_onenote/blocs/calendar_cubit.dart';
import 'package:flutter_onenote/models/task.dart';
import 'package:flutter_onenote/ui/widgets/list_of_calendar_tasks_widget.dart';
import 'package:flutter_onenote/ui/widgets/task_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarTab extends StatelessWidget {
  const CalendarTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarCubit(),
      child: Builder(builder: (context) {
        return Calendar(
          onDateSelected: (value) =>
              context.read<CalendarCubit>().getTasksByDay(value),
          startOnMonday: true,
          isExpandable: true,
          eventDoneColor: Colors.green,
          selectedColor: Colors.blue,
          todayColor: Colors.blue,
          eventListBuilder: (BuildContext context,
              List<NeatCleanCalendarEvent> _selectesdEvents) {
            return const ListOfCalendarTasks();
          },
          eventColor: Colors.grey,
          locale: 'EN',
          todayButtonText: 'Today',
          expandableDateFormat: 'EEEE, dd, MMMM yyyy',
          dayOfWeekStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w800, fontSize: 11),
        );
      }),
    );
  }
}
