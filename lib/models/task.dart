import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Task {
  String title;
  String description;
  Timestamp scheduled;
  var creationDate;
  String tag;
  bool done;
  bool fromOneNote;

  get getFromOneNote => this.fromOneNote;

  set setFromOneNote(bool fromOneNote) => this.fromOneNote = fromOneNote;

  get getDone => done;

  set setDone(bool done) => this.done = done;

  get getTitle => title;

  set setTitle(final title) => this.title = title;

  get getDescription => description;

  set setDescription(description) => this.description = description;

  getScheduled(bool string) {
    if (string) {
      return DateFormat("yyyy/MM/dd").format(scheduled.toDate());
    } else {
      return scheduled.toDate();
    }
  }

  set setScheduled(date) => scheduled = date;

  get getScheduledTime => DateFormat("hh:mm a").format(scheduled.toDate());

  get getCreationDate => creationDate;

  set setCreationDate(creationDate) => this.creationDate = creationDate;

  get getTag => tag;

  set setTag(tag) => this.tag = tag;

  Task({
    this.title = "",
    this.description = "",
    required this.scheduled,
    required this.creationDate,
    this.tag = "#tag",
    this.done = false,
    this.fromOneNote = false,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "done": done,
        "tag": tag,
        "scheduled": scheduled,
        "creationDate": creationDate,
        "fromOneNote": fromOneNote,
        "dateForSort": DateFormat('yyyy-MM-dd').format(DateTime(
            scheduled.toDate().year,
            scheduled.toDate().month,
            scheduled.toDate().day))
      };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json["title"],
      description: json["description"],
      scheduled: json["scheduled"],
      creationDate: json["creationDate"],
      tag: json["tag"],
      done: json["done"],
    );
  }
}
