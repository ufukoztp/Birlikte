
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:birlikte_app/main.dart';
import 'package:birlikte_app/model/detail_arguments.dart';
import 'package:birlikte_app/model/enums.dart';
import 'package:birlikte_app/providers/detail_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

class Congratulations_Screen extends StatefulWidget {
 late Detail_Provider detail_provider;

 Congratulations_Screen({required this.detail_provider});
  @override
  _Congratulations_ScreenState createState() => _Congratulations_ScreenState();
}

class _Congratulations_ScreenState extends State<Congratulations_Screen> with AfterLayoutMixin<Congratulations_Screen> {
  late ScreenshotController screenshotController =ScreenshotController();


  late FirebaseAuth _auth;
  @override
  void initState() {
    // TODO: implement initState
    _auth=FirebaseAuth.instance;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.detail_provider.routeType!=DETAILROUTE.COMPLETE?Padding(padding: EdgeInsets.only(top:8.w),
        child: Center(
          child: Container(
            color: Colors.white,
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 80.0.w,
                        width: 80.0.w,
                        decoration: BoxDecoration(image:DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("asset/tebrikler.png")
                        )),
                      ),
                    ),


                    SizedBox(height: 2.0.h,),
                    _auth.currentUser!.displayName!=null?
                    Padding(
                      padding:  EdgeInsets.only(left:10.0.w),
                      child: Text("TEBRİKLER "+_auth.currentUser!.displayName.toString(),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 22),),
                    ):Padding(
                      padding:  EdgeInsets.only(left:10.0.w),
                      child: Text("TEBRİKLER ${widget.detail_provider.name}",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 22),),
                    ),
                    SizedBox(height: 2.0.h,),
                    Padding(
                      padding:  EdgeInsets.only(left:10.0.w),
                      child: Text("${widget.detail_provider.win_cost} puan kazandın",style: TextStyle(fontSize: 17),),
                    ),                SizedBox(height: 2.0.h,),
                    Padding(
                      padding:  EdgeInsets.only(left:10.0.w,right:10.0.w ),
                      child: Text("Hadi bu puanlar ile dilediğin kampanyanın kahramanı ol",style: TextStyle(fontSize: 17),),
                    ),
                    SizedBox(height: 4.0.h,),
                    Center(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(widget.detail_provider.user_points.toString(),style: TextStyle(fontWeight: FontWeight.w700),),
                            Text("Sahip olduğun",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w700),),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black45,blurRadius: 10)],
                            borderRadius: BorderRadius.circular(10)
                        ),
                        height: 10.0.h,
                        width: 43.0.w,
                      ),
                    ),
                    SizedBox(height: 3.0.h,),
                    /*
                    widget.detail_provider.routeType==DETAILROUTE.REDWARD?
                    InkWell(
                      onTap: (){
                        widget.detail_provider.isLoading_reward==true?
                            widget.detail_provider.showRewarded(widget.detail_provider.campaign_name, _auth.currentUser!.uid):null;
                      },
                      child: Center(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Tekrar kazan",style: TextStyle(color:Colors.white,fontWeight: FontWeight.w700),),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: widget.detail_provider.isLoading_reward==true? Colors.blueAccent:Colors.grey,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          height: 7.0.h,
                          width: 91.0.w,
                        ),
                      ),
                    ):Container(),

                     */
                    SizedBox(height: 0.0.h,),

                    InkWell(
                      onTap: (){

                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Kampanyaya geri dön",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xff4462C7),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          height: 7.0.h,
                          width: 91.0.w,
                        ),
                      ),
                    ),






                  ],
                ),
              ),
            ),
          ),
        ),

      ):Padding(padding: EdgeInsets.only(top:0.w),
        child: Screenshot(
          controller: screenshotController,
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          height: 47.0.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(image:DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget.detail_provider.campaigns!.photo)
                          )),
                        ),
                      ),
                      widget.detail_provider.sharePopUpViewState==true?

                      Padding(
                        padding:  EdgeInsets.only(left:2.0.h,top:5.h),
                        child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.chevron_left,color: Colors.white,size: 5.h,)),
                      ):Container()

                    ],
                  ),
                  SizedBox(height: 5.0.h,),

                  _auth.currentUser!.displayName!=null?
                  Center(child: Text("TEŞEKKÜRLER "+_auth.currentUser!.displayName.toString(),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 5.w,),)):Padding(
                    padding:  EdgeInsets.only(left:10.0.w),
                    child: Text("TEŞEKKÜRLER ${widget.detail_provider.name} ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 4.w,),),
                  ),
                  SizedBox(height: 2.0.h,),

                  Center(child: Text("Sayende dünya daha güzel :)",style: TextStyle(fontSize: 3.w,fontWeight: FontWeight.w600),)),                SizedBox(height: 2.0.h,),
                  SizedBox(height: 2.0.h,),
                  _auth.currentUser!.displayName!=null?
                  Padding(
                    padding:  EdgeInsets.only(left:10.0.w,right:8.0.w),
                    child: Center(child: Text("${_auth.currentUser!.displayName} sayesinde '${widget.detail_provider.campaigns!.title}' kampanyası gerçek olmaya bir adım daha yakın. Sen de ücretsiz olarak bu kampanyanın kahramanı olmak istemez misin?  ",style: TextStyle(fontSize: 17),)),
                  ):
                  Padding(
                    padding:  EdgeInsets.only(left:10.0.w,right:8.0.w),
                    child: Center(child: Text("'${widget.detail_provider.campaigns!.title}' kampanyası gerçek olmaya bir adım daha yakın. Sen de ücretsiz olarak bu kampanyanın kahramanı olmak istemez misin?  ",style: TextStyle(fontSize: 4.w),)),
                  ),

                  Center(
                    child: Container(
                      height: 35.0.w,
                      width: 35.0.w,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("asset/alticoncomplete.png")

                        )
                      ),

                    ),
                  ),






                ],
              ),
            ),
          ),
        ),

      )
    );
  }

  Future shareAndTakeSS()async{
    showPreloader(context, "");

    final imageFile= await screenshotController.capture(pixelRatio: MediaQuery.of(context).devicePixelRatio);
    print(imageFile.toString());
    final directory = await getApplicationDocumentsDirectory();
    final pathOfImage = await File('${directory.path}/bagis.jpg').create();
    await pathOfImage.writeAsBytes(imageFile!.buffer.asUint8List());
    hidePreloader(context);
    await Share.shareFiles([pathOfImage.path],sharePositionOrigin:Rect.zero );

  }

  showPopUp(){
    showDialog(context: context, builder: (BuildContext context) {
      return new AlertDialog(
        actions: [
         InkWell(
           onTap:()async{
             widget.detail_provider.sharePopUpViewState=true;

             await shareAndTakeSS().then((value) {
              Navigator.pop(context);
              setState(() {

              });


            });

           },
           child: Container(
             height: 5.h,
             width: 10.w,
             child: Text("EVET",style: TextStyle(fontSize: 3.w),),
           ),
         ),
         InkWell(
           onTap: (){
             widget.detail_provider.sharePopUpViewState=true;
             setState(() {

             });
             Navigator.pop(context);
           },
           child: Container(
             height: 5.h,
             width: 10.w,
             child: Text("HAYIR",style: TextStyle(fontSize: 3.w),),
           ),
         ),
        ],
        content: new Text("Bu başarını sosyal medya hesaplarında paylaşarak kampanyaya destek olmak ister misin ?",style: TextStyle(fontSize: 4.w),),
      );
    }
    );}

  @override
  void afterFirstLayout(BuildContext context) async{
    widget.detail_provider.routeType==DETAILROUTE.COMPLETE?
  await shareAndTakeSS():null;
    // TODO: implement afterFirstLayout
  }
}
