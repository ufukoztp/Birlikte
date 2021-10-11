import 'package:birlikte_app/model/enums.dart';
import 'package:birlikte_app/providers/detail_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Game_Select extends StatefulWidget {
   final String campaign_photo;
  Game_Select({required this.campaign_photo});
  @override
  _Game_SelectState createState() => _Game_SelectState();
}

class _Game_SelectState extends State<Game_Select> {
  late Detail_Provider _detail_provider;
  late FirebaseAuth _auth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _auth= FirebaseAuth.instance;
  }
  @override
  Widget build(BuildContext context) {
    _detail_provider=Provider.of<Detail_Provider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding:  EdgeInsets.only(top:15.0.h,bottom: 15.0.h,left: 2.h,right: 2.h),
        child: Center(
          child: Card(
            elevation: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Lütfen bir oyun seçiniz",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15)),

              Padding(
                  padding:  EdgeInsets.all(4.w),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(2.0.h),
                    ),
                    color: Color(0xff517BED),
                    highlightColor: Colors.grey,
                    onPressed: () {
                      Navigator.pushNamed(context, "/flappy_bird");
                    },
                    child: Padding(
                      padding:  EdgeInsets.all(2.5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly,
                        children: [
                            Text('Uçan kuş',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.all(4.w),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(2.0.h),
                    ),
                    color: Color(0xff517BED),
                    highlightColor: Colors.grey,
                    onPressed: () {
                      Navigator.pushNamed(context, "/puzzle",arguments: widget.campaign_photo).then((value)async {
                        if(value==true){
                          _detail_provider.routeType=DETAILROUTE.GAME;
                          print("success true");
                          await   _detail_provider.setUserPoints(_detail_provider.campaign_name,_auth.currentUser!.uid,1);
                          _detail_provider.user_points+=1;
                          _detail_provider.win_cost=1;
                          Navigator.pushNamed(context, "/congratulations",arguments: _detail_provider);
                        }
                      });

                    },
                    child: Padding(
                      padding:  EdgeInsets.all(2.5.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceEvenly,
                        children: [
                            Text('Puzzle',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
