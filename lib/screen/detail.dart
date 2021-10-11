import 'dart:io';
import 'dart:typed_data';

import 'package:after_layout/after_layout.dart';
import 'package:birlikte_app/main.dart';
import 'package:birlikte_app/model/detail_arguments.dart';
import 'package:birlikte_app/model/enums.dart';
import 'package:birlikte_app/providers/detail_provider.dart';
import 'package:birlikte_app/providers/home_provider.dart';
import 'package:birlikte_app/repo/admob_services.dart';
import 'package:birlikte_app/widget/refresh_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: camel_case_types
class Detail_Page extends StatefulWidget {
   final Detail_Arguments detail_arguments;
  Detail_Page({required this.detail_arguments});

  @override
  _Detail_PageState createState() => _Detail_PageState();
}

class _Detail_PageState extends State<Detail_Page> with AfterLayoutMixin<Detail_Page>{
  late Detail_Provider _detail_provider;
  late FirebaseAuth _auth ;
  final keyRefresh = GlobalKey<RefreshIndicatorState>();




  late AdState _adState;
  @override
  void initState() {



    // TODO: implement initState
    _auth=FirebaseAuth.instance;
    _adState=AdState();



    super.initState();
  }


  Future onRefresh()async{
    _detail_provider.campaign_request_is_done=false;
    _detail_provider.getCampaigns(_detail_provider.campaigns!.campaignName);

  }
  @override
  Widget build(BuildContext context) {
    _detail_provider=Provider.of<Detail_Provider>(context);

    return Scaffold(

      body: _detail_provider.isLoading_user_points==true&&_detail_provider.campaign_request_is_done==true?

      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: [Color(0xFAFAFA), Color(0xffE8ECF4)])
        ),
        child: RefreshWidget(
          keyRefresh: keyRefresh,
          onRefresh:  onRefresh,
          child: ListView.builder(itemCount: 1,itemBuilder: (context,index){
            return Stack(
              children: [

                Padding(
                  padding:  EdgeInsets.only(top:10.0.w),
                  child: Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0.w),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(bottom:8.0.w),
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding:  EdgeInsets.all(4.0.w),
                                  child: Container(
                                    height: 25.0.h,
                                    width: 80.0.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(fit: BoxFit.cover,image: NetworkImage(_detail_provider.campaigns!.photo)


                                        )
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.only(top:2.0.w),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.only(left:9.w,top:4.0.w),
                                        child: InkWell(
                                          onTap: ()async{
                                            await canLaunch(_detail_provider.campaigns!.inst_url,)?await launch( _detail_provider.campaigns!.inst_url):print("url açılamıyor.");

                                          },
                                            child: ImageIcon(AssetImage("asset/instagram.png",),)),
                                      ),


                                      Padding(
                                        padding:  EdgeInsets.only(right:0.0.w,top:4.w,left: 2.w),
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                                onTap: ()async{
                                                  await canLaunch(_detail_provider.campaigns!.inst_url,)?await launch( _detail_provider.campaigns!.inst_url):print("url açılamıyor.");

                                                },
                                                child: Text("Kampanya detayını gör",style: TextStyle(fontWeight: FontWeight.w700),))),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 3.0.h,),

                                Padding(
                                  padding:  EdgeInsets.only(left:8.0.w,right:8.0.w),
                                  child: ReadMoreText(
                                    _detail_provider.campaigns!.descriptionDetail,
                                    colorClickableText: Colors.blueAccent,
                                    trimMode: TrimMode.Line,
                                    lessStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.blueAccent),
                                    style: TextStyle(color: Colors.black,fontSize: 11.sp),
                                    trimCollapsedText: 'Daha Fazlası',
                                    trimLines: 3,
                                    trimExpandedText: 'Gizle',
                                    moreStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.blueAccent),
                                  ),
                                ),
                               SizedBox(height: 5.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(_detail_provider.campaigns!.allPoints.toString(),style: TextStyle(fontWeight: FontWeight.w700),),
                                          Text("İhtiyaç duyulan",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w700),),
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
                                    SizedBox(width: 5.0.w,),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(_detail_provider.user_points.toString(),style: TextStyle(fontWeight: FontWeight.w700),),
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

                                  ],
                                ),
                                SizedBox(height: 2.0.h,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(2.0.h),
                                      ),

                                      highlightColor: Colors.grey,
                                      onPressed: (){
                                        Navigator.pushNamed(context, "/game_select",arguments: _detail_provider.campaigns!.campaign_puzzle_photo).then((value)async {
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
                                      color: Color(0Xff7FB1B0),
                                      child: Container(
                                        width: 35.w,
                                        child: Padding(
                                          padding:  EdgeInsets.all(1.0.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text("Oyun oyna",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 3.h,
                                                    width: 5.w,
                                                    decoration: BoxDecoration(image: DecorationImage(
                                                        image: AssetImage("asset/puan.png")
                                                    )),),
                                                  Text("1",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)

                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5.0.w,),
                                    RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(2.0.h),
                                      ),
                                     color: _detail_provider.isLoading_reward==true?Color(0xff517BED):Colors.grey,
                                      splashColor: Colors.white30,

                                      onPressed: ()async{

                                        _detail_provider.isLoading_reward==true?
                                        await _detail_provider.showRewarded(_detail_provider.campaign_name,_auth.currentUser!.uid).then((value) {

                                          _detail_provider.isLoading_reward=false;

                                          if(Platform.isAndroid==true){
                                            RewardedAd.load(
                                                adUnitId: 'ca-app-pub-9790530714505384/6332101026',
                                                request: AdRequest(nonPersonalizedAds: true),
                                                rewardedAdLoadCallback: RewardedAdLoadCallback(
                                                  onAdLoaded: (RewardedAd ad) {
                                                    _detail_provider.isLoading_reward=true;
                                                    print('DENEME + $ad loaded.');
                                                    // Keep a reference to the ad so you can show it later.
                                                    _detail_provider.reward = ad;
                                                  },
                                                  onAdFailedToLoad: (LoadAdError error) {
                                                    print('RewardedAd failed to load: $error');
                                                  },
                                                )).then((value) async{


                                              await  _detail_provider.setUserPoints(_detail_provider.campaign_name, _auth.currentUser!.uid,15);
                                              _detail_provider.user_points+=15;
                                              _detail_provider.win_cost=15;
                                              _detail_provider.routeType=DETAILROUTE.REDWARD;
                                              Navigator.of(context).pushNamed("/congratulations",arguments: _detail_provider);
                                            });

                                          }else{
                                            RewardedAd.load(
                                                adUnitId: 'ca-app-pub-9790530714505384/2507204378',
                                                request: AdRequest(nonPersonalizedAds: true),
                                                rewardedAdLoadCallback: RewardedAdLoadCallback(
                                                  onAdLoaded: (RewardedAd ad) {
                                                    _detail_provider.isLoading_reward=true;
                                                    print('DENEME + $ad loaded.');
                                                    // Keep a reference to the ad so you can show it later.
                                                    _detail_provider.reward = ad;
                                                  },
                                                  onAdFailedToLoad: (LoadAdError error) {
                                                    print('RewardedAd failed to load: $error');
                                                  },
                                                )).then((value) async{


                                              await  _detail_provider.setUserPoints(_detail_provider.campaign_name, _auth.currentUser!.uid,15);
                                              _detail_provider.user_points+=15;
                                              _detail_provider.win_cost=15;
                                              _detail_provider.routeType=DETAILROUTE.REDWARD;
                                              Navigator.of(context).pushNamed("/congratulations",arguments: _detail_provider);
                                            });

                                          }




                                        }): showDialog(context: context, builder: (BuildContext context) {
                                          return new AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                                              ),

                                              content: Container(
                                                height: 90.w,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              fit: BoxFit.fill,
                                                              image: AssetImage("asset/onboard1.png")
                                                          )
                                                      ),
                                                      height: 45.w,
                                                      width: 45.w,
                                                    ),
                                                    SizedBox(height: 10.w,),
                                                    Center(child: Text("Şu anda izlenecek reklam bulunmamaktadır.Lüten bekleyiniz",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 3.w,),)),
                                                    SizedBox(height: 8.w,),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                          },
                                                          child: Container(
                                                            child: Center(child: Text("Geri dön",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 3.w),)),
                                                            decoration: BoxDecoration(
                                                                color: Colors.grey,
                                                                boxShadow: [BoxShadow(color: Colors.black45,blurRadius: 10)],
                                                                borderRadius: BorderRadius.circular(10)
                                                            ),
                                                            height: 5.0.h,
                                                            width: 40.0.w,
                                                          ),
                                                        ),

                                                      ],
                                                    )
                                                  ],
                                                ),
                                              )
                                          );
                                        }
                                        );



                                      },
                                      child: Container(
                                        width: 35.w
                                        ,
                                        child: Padding(
                                          padding:  EdgeInsets.all(1.0.h),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text("Reklam izle",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 3.h,
                                                    width: 5.w,
                                                    decoration: BoxDecoration(image: DecorationImage(
                                                    image: AssetImage("asset/puan.png")
                                                  )),),
                                                  Text("15",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)

                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: 2.0.h,),
                                Padding(
                                  padding:  EdgeInsets.only(left:2.0.h,right: 2.h),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(2.0.h),
                                    ),
                                    color:  Color(0xffE08D79),
                                    onPressed: (){
                                      if(_detail_provider.campaigns!.allPoints>0&&_detail_provider.user_points>0){
                                        showPreloader(context,"");
                                        _detail_provider.setPoints(_detail_provider.campaign_name, _detail_provider.user_points,_auth.currentUser!.uid).then((value) {
                                          hidePreloader(context);
                                          _detail_provider.routeType=DETAILROUTE.COMPLETE;
                                          showPopUp();


                                        });

                                      }

                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(2.0.h),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("KAHRAMAN OL",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),


                              ],
                            ),
                            /*
                          Positioned(
                            left: 2.h,
                            top: 29.h,
                            child: Container(
                              child: Center(child: Text("0/0")),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.black45,blurRadius: 10)],
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              height: 12.h,
                              width: 12.h,
                            ),
                          ),

                           */
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding:  EdgeInsets.only(top:2.0.w,left:1.0.w),
                    child: Icon(Icons.chevron_left,color: Colors.black,size: 40,),
                  ),
                ),


              ],
            );
          }),
        ),
      ):Center(
        child: CircularProgressIndicator(),
      )
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async{


    await  _detail_provider.getUserName(_auth.currentUser!.uid);

    await _detail_provider.getUserPoints(_detail_provider.campaign_name, _auth.currentUser!.uid);

    _detail_provider.campaign_name=widget.detail_arguments.campaign_name;

    await _detail_provider.getCampaigns(_detail_provider.campaign_name);
    if(Platform.isAndroid==true){
      RewardedAd.load(
          adUnitId: 'ca-app-pub-9790530714505384/6332101026',
          request: AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              _detail_provider.isLoading_reward=true;
              print('DENEME + $ad loaded.');
              // Keep a reference to the ad so you can show it later.
              _detail_provider.reward = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('RewardedAd failed to load: $error');
            },
          )).then((value) {
      });
    }else{
      print("ios için çalıştı. ");
      RewardedAd.load(
          adUnitId: 'ca-app-pub-9790530714505384/2507204378',
          request: AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              _detail_provider.isLoading_reward=true;
              print('DENEME + $ad loaded.');
              // Keep a reference to the ad so you can show it later.
              _detail_provider.reward = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {
              print('RewardedAd failed to load: $error');
            },
          )).then((value) {


      });
    }


  }
  showPopUp(){
    showDialog(context: context, builder: (BuildContext context) {
      return new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),

        content: Container(
          height: 90.w,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("asset/onboard1.png")
                  )
                ),
                height: 45.w,
                width: 45.w,
              ),
              SizedBox(height: 10.w,),
              _auth.currentUser!.displayName!=null?
              Center(child: Text("Teşekkürler ${_auth.currentUser!.displayName}",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 5.w,),)):Center(child: Text("Teşekkürler")),
              SizedBox(height: 5.w,),
              Center(child: Text("Kampanyaya ${_detail_provider.complete_cost} puan katkı sağladın ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 3.w,),)),
              SizedBox(height: 8.w,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: (){
                      _detail_provider.sharePopUpViewState=true;
                      setState(() {

                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Center(child: Text("Geri dön",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 3.w),)),
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          boxShadow: [BoxShadow(color: Colors.black45,blurRadius: 10)],
                          borderRadius: BorderRadius.circular(10)
                      ),
                      height: 5.0.h,
                      width: 25.0.w,
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      _detail_provider.sharePopUpViewState=true;
                      Navigator.of(context).pushNamed("/congratulations",arguments: _detail_provider).then((value) {
                        _detail_provider.sharePopUpViewState=false;

                      });

                    },
                    child: Container(
                      child: Center(child: Text("Paylaş",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 3.w),)),
                      decoration: BoxDecoration(
                          color: Color(0xff517BED),
                          boxShadow: [BoxShadow(color: Colors.black45,blurRadius: 10)],
                          borderRadius: BorderRadius.circular(10)
                      ),
                      height: 5.0.h,
                      width: 25.0.w,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      );
    }
    );}


}
