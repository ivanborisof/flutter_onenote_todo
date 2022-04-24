import 'dart:convert';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_onenote/models/task.dart';
import 'package:flutter_onenote/resources/repository.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:html/parser.dart' show parse;

class OneNoteProvider {
  static String tenant = "common";
  static String clientId = "7c428a7a-1057-4f26-bfa4-e7f171fd5b4d";
  static String scope =
      "User.Read User.Read.All Notes.ReadWrite.All Notes.Read.All Notes.Read Notes.Create Notes.ReadWrite Notes.ReadWrite.CreatedByApp";
  static String redirectUri =
      "https://login.microsoftonline.com/common/oauth2/nativeclient";
  static Config config = Config(
    tenant: tenant,
    clientId: clientId,
    scope: scope,
    redirectUri: redirectUri,
  );

  final AadOAuth oauth = AadOAuth(config);

  Future<String?> signIn() async {
    try {
      await oauth.login();
    } catch (e) {
      print(e);
    }
    String? accessToken = await oauth.getAccessToken();
    return accessToken;
  }

  Future<List<String>> getSectionsUrls(accessToken) async {
    List<String> noteBooks = [];

    Response res = await http.get(
        Uri.parse("https://graph.microsoft.com/v1.0/me/onenote/notebooks"),
        headers: {
          'Authorization': "Bearer " + accessToken,
        });
    Map<String, dynamic> json = jsonDecode(res.body);
    for (int x = 0; x < json["value"].length; x++) {
      noteBooks.add(json["value"][x]["sectionsUrl"]);
    }

    return noteBooks;
  }

  Future<List<String>> getPagesUrls(accessToken) async {
    List<String> pages = [];

    List<String> sectionsUrls = await getSectionsUrls(accessToken);
    for (int x = 0; x < sectionsUrls.length; x++) {
      Response res = await http.get(Uri.parse(sectionsUrls[x]), headers: {
        'Authorization': "Bearer " + accessToken,
      });
      Map<String, dynamic> json = jsonDecode(res.body);
      for (int x = 0; x < json["value"].length; x++) {
        pages.add(json["value"][x]["pagesUrl"]);
      }
    }

    return pages;
  }

  getContentUrls(accessToken) async {
    List<String> contents = [];

    List<String> pagesUrls = await getPagesUrls(accessToken);

    for (int x = 0; x < pagesUrls.length; x++) {
      Response res = await http.get(Uri.parse(pagesUrls[x]), headers: {
        'Authorization': "Bearer " + accessToken,
      });
      Map<String, dynamic> json = jsonDecode(res.body);
      print(json);
      for (int x = 0; x < json["value"].length; x++) {
        contents.add(json["value"][x]["contentUrl"]);
      }
    }
    return contents;
  }

  Future<List<Task>> getNotesWithTags(accessToken) async {
    List<Task> tasks = [];

    List<String> contents = await getContentUrls(accessToken);
    for (int x = 0; x < contents.length; x++) {
      Response res = await http.get(Uri.parse(contents[x]), headers: {
        'Authorization': "Bearer " + accessToken,
      });
      var document = parse(res.body);
      var list = document
          .getElementsByTagName("p")
          .where((element) => element.attributes["data-tag"] != null)
          .map((item) => Task(
                fromOneNote: true,
                title: item.text,
                tag: "#" + item.attributes["data-tag"].toString(),
                scheduled: Timestamp.fromDate(DateTime.now()),
                creationDate: Timestamp.fromDate(DateTime.now()),
              ))
          .toList();

      for (int x = 0; x < list.length; x++) {
        tasks.add(list[x]);
      }
    }

    return tasks;
  }

  syncOneNoteWithFirebase() async {
    String? accessToken = await oauth.getAccessToken();
    if (accessToken != null) {
      try {
        Repository().removeAllOneNoteTasks();
        List<Task> tasks = await getNotesWithTags(accessToken);
        for (int x = 0; x < tasks.length; x++) {
          Repository().addTask(tasks[x].toJson());
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("pizda");
    }
  }
}
