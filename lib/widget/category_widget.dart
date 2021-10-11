import 'package:birlikte_app/repo/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class Category_Screen extends StatefulWidget {

  @override
  _Category_ScreenState createState() => _Category_ScreenState();
}

class _Category_ScreenState extends State<Category_Screen> {

  FirebaseAuth _auth =FirebaseAuth.instance;


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
            Text("Henüz test aşamasındayız... :(",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w700,fontSize: 5.w),),




          ],
        ),

      ),
    );
  }
}
