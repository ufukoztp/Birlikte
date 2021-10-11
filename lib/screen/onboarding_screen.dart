import 'package:birlikte_app/screen/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sizer/sizer.dart';



class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  FirebaseAuth _auth=FirebaseAuth.instance;



  @override
  void initState() {

    super.initState();
    if(_auth.currentUser!=null){
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        print(_auth.currentUser!.uid);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Home_Page()));
      });    }

  }
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {

  }

  Widget _buildFullscrenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Stack(
      children: [IntroductionScreen(

        key: introKey,
        globalBackgroundColor: Colors.white,

        pages: [
          PageViewModel(
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 70.0.w,
                  width: 70.0.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image:AssetImage("asset/onboard1.png")
                      )
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.all(1.0.w),
                  child: Text("Sadece 20 saniyelik reklamlar izleyerek ya da basit bulmaca oyununu oynayarak gerçekleşmesini istediğin kampanyanın kahramanı ol!",style: TextStyle(fontSize: 4.w,fontWeight: FontWeight.w600),),
                ),
                InkWell(

                  onTap:()async {
                    introKey.currentState!.controller.jumpToPage(1);
                  },
                  child: Padding(
                    padding:   EdgeInsets.only(top:5.0.h),
                    child: Container(
                      child: Center(child:Text("İlerle ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 4.w),)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:Color(0xffffde6d),

                      ),
                      height: 7.0.h,
                      width: 50.0.w,
                    ),
                  ),
                ),
                InkWell(

                  onTap:()async {
                    introKey.currentState!.controller.jumpToPage(2);
                  },
                  child: Padding(
                    padding:   EdgeInsets.only(top:2.0.h),
                    child: Center(child:Text("Geç ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 4.w,color: Colors.grey),)),
                  ),
                ),

              ],
            ),
            title: " ",
            decoration: pageDecoration,
          ),
          PageViewModel(
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 70.0.w,
                  width: 70.0.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("asset/onboard2.png")
                      )
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.all(1.0.w),
                  child: Text("Reklam izleyerek ya da bulmaca oyununu oynayarak puanları toplayabilirsin",style: TextStyle(fontSize: 4.w,fontWeight: FontWeight.w600),),
                ),
                InkWell(
                  onTap:()=>introKey.currentState!.controller.jumpToPage(2),
                  child: Padding(
                    padding:   EdgeInsets.only(top:5.0.h),
                    child: Container(
                      child: Center(child:Text("İlerle ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 4.w),)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:Color(0xFFffDE6D),

                      ),
                      height: 7.0.h,
                      width: 50.0.w,
                    ),
                  ),
                ),
                InkWell(
                  onTap:()=>introKey.currentState!.controller.jumpToPage(2),
                  child: Padding(
                    padding:   EdgeInsets.only(top:2.0.h),
                    child: Center(child:Text("Geç ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 4.w,color: Colors.grey),)),
                  ),
                ),

              ],
            ),
            title: " ",
            decoration: pageDecoration,
          ),
          PageViewModel(
            bodyWidget: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 70.0.w,
                  width: 70.0.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("asset/onboard3.png")
                      )
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.all(2.0.w),
                  child: Text("Topladığın puanlar ile istediğin kampanyanın kahramanı olabilir, bu başarilarını sevdiklerinle paylaşabilirsin",style: TextStyle(fontSize: 4.w,fontWeight: FontWeight.w600),),
                ),
                InkWell(
                  onTap:()=> Navigator.of(context).pushReplacementNamed("/AuthService"),
                  child: Padding(
                    padding:   EdgeInsets.only(top:2.0.h),
                    child: Container(
                      child: Center(child:Text("Başla! ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 4.w),)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:Color(0xFffFDE6D),

                      ),
                      height: 7.0.h,
                      width: 50.0.w,
                    ),
                  ),
                ),

              ],
            ),
            title: " ",
            decoration: pageDecoration,
          ),




        ],
        onDone: () => _onIntroEnd(context),
        //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: false,
        skipFlex: 0,
        showNextButton: false,
        showDoneButton: false,
        nextFlex: 0,
        //rtl: true, // Display as right-to-left
        skip: const Text('Skip'),
        done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      )],
    );
  }
}

