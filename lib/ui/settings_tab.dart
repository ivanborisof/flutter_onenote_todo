import 'dart:developer';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onenote/resources/onenote_provider.dart';
import 'package:flutter_onenote/resources/repository.dart';
import 'package:flutter_onenote/ui/auth_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsButton(
          text: "Profile",
          onTap: null,
        ),
        Divider(height: 1),
        SettingsButton(
          text: "Auth in OneNote",
          onTap: () async {
            print(await OneNoteProvider().signIn());
          },
        ),
        Divider(height: 1),
        SettingsButton(
          text: "Sunc with OneNote",
          onTap: () async {
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () => Future.value(false),
                  child: AlertDialog(
                    title: Text('Synchronize tasks with OneNote'),
                    content: SingleChildScrollView(
                      child: SizedBox(
                        height: 300.h,
                        child: Center(
                          child: SizedBox(
                              width: 100.w,
                              height: 100.w,
                              child: CircularProgressIndicator()),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
            await OneNoteProvider().syncOneNoteWithFirebase();
            Navigator.of(context).pop();
          },
        ),
        Divider(height: 1),
        SettingsButton(
          text: "About",
          onTap: () {},
        ),
        Divider(height: 1),
        SettingsButton(
          text: "Sign out",
          onTap: () async {
            FirebaseAuth.instance.signOut();
          },
        ),
      ],
    );
  }
}

class SettingsButton extends StatelessWidget {
  final String text;
  final onTap;
  const SettingsButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        height: 40.h,
        child: Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: Align(
            child: Text(text),
            alignment: Alignment.centerLeft,
          ),
        ),
      ),
    );
  }
}
