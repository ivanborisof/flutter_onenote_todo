import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onenote/resources/repository.dart';

class CalendarCubit extends Cubit<Stream<QuerySnapshot<Map<String, dynamic>>>> {
  CalendarCubit()
      : super(Repository().myTaskList(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)));

  void getTasksByDay(DateTime date) => emit(Repository().myTaskList(date));
}
