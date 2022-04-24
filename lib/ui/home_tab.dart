import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onenote/models/task.dart';
import 'package:flutter_onenote/resources/repository.dart';
import 'package:flutter_onenote/ui/widgets/task_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today",
                      style: TextStyle(
                          fontSize: 22.sp, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5.h),

            // ---------------- Green line ------------------

            StreamBuilder(
              stream: Repository().myTaskList(DateTime(DateTime.now().year,
                  DateTime.now().month, DateTime.now().day)),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  int doneCount = 0;
                  int allCount = snapshot.data!.docs.length;
                  for (var i = 0; i < allCount; i++) {
                    if (snapshot.data!.docs[i]["done"] == true) {
                      doneCount++;
                    }
                  }
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      color: Colors.green,
                      minHeight: 6.h,
                      backgroundColor: Colors.grey.shade300,
                      value: allCount != 0
                          ? (((doneCount * 100) / allCount) / 100)
                          : 0,
                    ),
                  );
                }
                return SizedBox(height: 6.h);
              },
            ),

            // ---------------- /Green line ------------------

            SizedBox(height: 15.h),

            // ---------------- Task list ------------------

            Expanded(
              child: StreamBuilder(
                stream: Repository().myTaskList(DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day)),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.hasData) {
                    return ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Task task = Task.fromJson(
                            document.data() as Map<String, dynamic>);
                        // print(task.scheduled.toDate().toString() +
                        //     " " +
                        //     task.getTitle);
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15.h),
                          child: TaskWidget(
                              id: document.id, task: task, showTimePart: false),
                        );
                      }).toList(),
                    );
                  }
                  return Container();
                },
              ),
            ),

            // ---------------- /Task list ------------------
          ],
        ),
      ),
    );
  }
}
