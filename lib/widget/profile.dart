import 'package:birlikte_app/repo/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sizer/sizer.dart';
class Profile_Screen extends StatefulWidget {

  @override
  _Profile_ScreenState createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {

  FirebaseAuth _auth =FirebaseAuth.instance;
  GoogleSignIn _googleSignIn =GoogleSignIn();


  @override
  Widget build(BuildContext context) {
    Size phoneSize=MediaQuery.of(context).size;

    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: [Color(0xFAFAFA), Color(0xffE8ECF4)])
        ),
        width: phoneSize.width,
        height: phoneSize.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Center(
              child: Container(

                decoration: BoxDecoration(
                  image:DecorationImage(
                    image: AssetImage("asset/birlikteyuvarlak.png")
                  )
                ),
                width: MediaQuery.of(context).size.width-60.w,
                height: 70.w,
              ),
            ),
            Center(child: InkWell(
                onTap:()async{
                  try{
                    await _googleSignIn.disconnect();

                  }catch(e){

                  }finally{
                    await  _auth.signOut().onError((error, stackTrace)async {
                      await _googleSignIn.signOut().then((value) {
                        Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);
                      });
                    }).then((value) {
                      Navigator.of(context).pushNamedAndRemoveUntil("/login", (route) => false);

                    });



                  }



                } ,
                child: Text("ÇIKIŞ YAP",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 4.w,))),)


          ],
        ),

      ),
    );
  }
}
