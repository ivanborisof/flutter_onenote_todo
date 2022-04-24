import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onenote/models/task.dart';
import 'package:flutter_onenote/resources/repository.dart';

class TasksCubit extends Cubit<Task> {
  Task task;
  String id;
  TasksCubit(this.task, this.id) : super(task);

  final _repository = Repository();

  void addTitle(String pickedTitle) {
    task.title = pickedTitle;
    emit(task);
    print(task.toJson());
  }

  void addDescription(String pickedDesc) {
    task.description = pickedDesc;
    emit(task);
  }

  void addDate(DateTime pickedDate) {
    task.scheduled = Timestamp.fromDate(pickedDate);
    emit(task);
  }

  void addTime(TimeOfDay pickedTime) {
    var pickedDate = task.scheduled.toDate();
    print(DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
        pickedTime.hour, pickedTime.minute));

    task.scheduled = Timestamp.fromDate(DateTime(pickedDate.year,
        pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute));
    emit(task);
  }

  void addTag(String pickedTag) {
    task.tag = pickedTag;
    emit(task);
  }

  void addTaskToDB() {
    _repository.addTask(task.toJson());
  }

  void updateTask() {
    _repository.updateTask(task.toJson(), id);
  }
}
