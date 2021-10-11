import 'package:birlikte_app/main.dart';
import 'package:birlikte_app/screen/layout.dart';
import 'package:birlikte_app/screen/name_take_screen.dart';
import 'package:birlikte_app/widget/login_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {
  GoogleSignIn _googleSignIn=GoogleSignIn();

  //Handles Auth
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return Name_Take();
          } else {
            return Login_Widget();
          }

        });
  }

  //Sign out
 Future signOut(context) async{
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pushReplacementNamed("/login");

    });
  }

  Future signOutWithGoogle(context) async{
    await _googleSignIn.signOut();
  }
  //SignIn
  signIn(AuthCredential authCreds,context) async{
  await    FirebaseAuth.instance.signInWithCredential(authCreds).catchError((onError) {
    hidePreloader(context);
    ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Kod geçersizdir.")));
        print(onError.toString()+"eror in service");
      }).then((value) {
        hidePreloader(context);
        Navigator.of(context).pushNamed("/name");
  });


  }

  signInWithOTP(smsCode, verId,context) {
    showPreloader(context, "");

    try{
      AuthCredential authCreds = PhoneAuthProvider.credential(
          verificationId: verId, smsCode: smsCode);

      signIn(authCreds,context);

    }catch(e){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kod geçersizdir. ")));
    }

  }
}