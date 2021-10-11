import 'package:after_layout/after_layout.dart';
import 'package:birlikte_app/model/detail_arguments.dart';
import 'package:birlikte_app/providers/home_provider.dart';
import 'package:birlikte_app/widget/refresh_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class Home_Widget extends StatefulWidget {
  @override
  _Home_WidgetState createState() => _Home_WidgetState();
}

class _Home_WidgetState extends State<Home_Widget> with AfterLayoutMixin<Home_Widget> {
  late Home_Provider _home_provider;
  late FirebaseAuth _auth ;


  @override
  void initState() {
    // TODO: implement initState
    _auth=FirebaseAuth.instance;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;

    _home_provider=Provider.of<Home_Provider>(context);
    return _home_provider.campaign_request_is_done==true&&_home_provider.nameLoading==true? Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: ()async{
             await canLaunch("https://www.instagram.com/birlikteapp/")?await launch("https://www.instagram.com/birlikteapp/"):print("url açılamıyor.");
              },

              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0.w),
                ),
                color: Colors.white,

                child: Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Container(
                      width: MediaQuery.of(context).size.width-14.w,
                      child:Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 10.w,
                                height: 10.w,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.contain,
                                        image: AssetImage("asset/birlikteyuvarlak.png")
                                    )
                                ),),
                              SizedBox(width: 3.w,),
                              Text("Birlikte",style: TextStyle(fontWeight: FontWeight.w700),)

                            ],
                          ),
                          Padding(
                            padding:  EdgeInsets.all(2.w),
                            child: Text("Kampanyalarla ilgili güncel bilgiler için bizi sosyal medya hesaplarımızdan takip etmeyi unutma!",style: TextStyle(fontWeight: FontWeight.w600),),
                          )
                        ],
                      )
                  ),
                ),
              ),
            ),
            Column(children: List.generate( _home_provider.campaigns.length, (index) {

              return Padding(
                padding:  EdgeInsets.all(4.0.w),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0.w),
                  ),
                  color: Colors.white,

                  child: Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.all(6.0.w),
                        child: Container(
                          height: 65.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(_home_provider.campaigns[index].photo)
                              )
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:  EdgeInsets.all(5.0.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_home_provider.campaigns[index].title,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 17),),
                                  SizedBox(height: 15,),
                                  Text(_home_provider.campaigns[index].description,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 11),),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding:  EdgeInsets.all(5.0.w),
                            child: RaisedButton(onPressed: ()async{
                              /*

                                await   _home_provider.setPoints(_home_provider.campaigns[index].campaignName);

                                 */




                              Navigator.of(context).pushNamed("/detail",arguments:Detail_Arguments(campaign_name: _home_provider.campaigns[index].campaignName, image: _home_provider.campaigns[index].photo));

                            },color: Color(0xff517BED),child: Text("Katıl",style: TextStyle(color: Colors.white),),),
                          )

                        ],
                      ),

                    ],
                  ),
                ),
              );

            }
            ),),

/*
            Expanded(
              child: ListView.builder(itemCount: _home_provider.campaigns.length,itemBuilder: (context,index){
                return Padding(
                  padding:  EdgeInsets.all(4.0.w),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0.w),
                    ),
                    color: Colors.white,

                    child: Column(
                      children: [
                        Padding(
                          padding:  EdgeInsets.all(6.0.w),
                          child: Container(
                            height: 65.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(_home_provider.campaigns[index].photo)
                                )
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:  EdgeInsets.all(5.0.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_home_provider.campaigns[index].title,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 17),),
                                    SizedBox(height: 15,),
                                    Text(_home_provider.campaigns[index].description,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 11),),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.all(5.0.w),
                              child: RaisedButton(onPressed: ()async{
                                /*

                              await   _home_provider.setPoints(_home_provider.campaigns[index].campaignName);

                               */




                                Navigator.of(context).pushNamed("/detail",arguments:Detail_Arguments(campaign_name: _home_provider.campaigns[index].campaignName, image: _home_provider.campaigns[index].photo));

                              },color: Color(0xff517BED),child: Text("Katıl",style: TextStyle(color: Colors.white),),),
                            )

                          ],
                        ),

                      ],
                    ),
                  ),
                );
              }),
            ),

 */


          ],
        ),
      ),
    ):Expanded(
      child: Container(
          height: size.height,
          width:size.width,
          child: Center(child: CircularProgressIndicator(),)),
    );
  }

  @override
  void afterFirstLayout(BuildContext context)async {
  
   await _home_provider.getCampaigns();
  }
}
