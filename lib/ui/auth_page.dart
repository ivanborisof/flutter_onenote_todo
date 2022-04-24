import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_onenote/blocs/auth_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // signInWithGoogle() async {
    //   // Trigger the authentication flow
    //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //   // Obtain the auth details from the request
    //   final GoogleSignInAuthentication? googleAuth =
    //       await googleUser?.authentication;

    //   // Create a new credential
    //   final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth?.accessToken,
    //     idToken: googleAuth?.idToken,
    //   );

    //   // Once signed in, return the UserCredential
    //   return await FirebaseAuth.instance.signInWithCredential(credential);
    // }

    return BlocProvider(create: (_) => AuthCubit(), child: NewWidget());
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInButton(
                Buttons.Google,
                text: "Sign in with Google",
                onPressed: () =>
                    context.read<AuthCubit>().authWithGoogle(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
