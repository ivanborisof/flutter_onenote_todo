// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onenote/resources/repository.dart';
import 'package:flutter_onenote/ui/home_page.dart';

class AuthCubit extends Cubit<int> {
  AuthCubit() : super(0);

  final _repository = Repository();

  void authWithGoogle(context) {
    _repository.authenticateUser();
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()));
      }
    });
  }
}
