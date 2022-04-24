import 'package:flutter/material.dart';
import 'package:flutter_onenote/models/task.dart';
import 'package:flutter_onenote/resources/repository.dart';
import 'package:flutter_onenote/ui/edit_task_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TaskWidget extends StatefulWidget {
  final String id;
  final Task task;
  final bool showTimePart;
  const TaskWidget(
      {Key? key,
      required this.id,
      required this.task,
      required this.showTimePart})
      : super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool check = true;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Repository().changeDoneOfTask(widget.id, widget.task.getDone);
      },
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditTaskPage(
                    id: widget.id,
                    task: widget.task,
                  )),
        );
      },
      child: Row(
        children: [
          widget.showTimePart
              ? Row(
                  children: [
                    SizedBox(width: 5.w),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          borderRadius: BorderRadius.circular(2.r)),
                      padding: EdgeInsets.all(4.w),
                      child: Text(
                        widget.task.getScheduledTime,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 10.w)
                  ],
                )
              : Container(),
          Icon(
            widget.task.getDone
                ? Icons.check_circle
                : Icons.check_circle_outline_rounded,
            color: widget.task.getDone
                ? Colors.green.shade200
                : Colors.grey.shade500,
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.getTitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 15.sp,
                      color: widget.task.getDone
                          ? Colors.grey.shade400
                          : Colors.black),
                ),
                widget.task.getTag != "#tag"
                    ? Column(children: [
                        SizedBox(height: 2.h),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: Colors.blue.shade200,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.w),
                            child: Text(
                              widget.task.getTag,
                              style: TextStyle(fontSize: 10.sp),
                            ),
                          ),
                        ),
                      ])
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
