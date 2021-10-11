import 'package:after_layout/after_layout.dart';
import 'package:birlikte_app/providers/home_provider.dart';
import 'package:birlikte_app/repo/auth_service.dart';
import 'package:birlikte_app/repo/remote_repo.dart';
import 'package:birlikte_app/widget/begeniler_widget.dart';
import 'package:birlikte_app/widget/category_widget.dart';
import 'package:birlikte_app/widget/home.dart';
import 'package:birlikte_app/widget/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';


class Home_Page extends StatefulWidget {
  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page>with AfterLayoutMixin<Home_Page> {
  int selected_index=0;

  late FirebaseAuth _auth;

  late Home_Provider _home_provider;


  GoogleSignIn _googleSignIn=GoogleSignIn();


  Future signIn()async{


    GoogleSignInAccount? googleUser=await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth =await googleUser!.authentication;

    AuthCredential credential =GoogleAuthProvider.credential(idToken: googleAuth.idToken,accessToken: googleAuth.accessToken);

    await _auth.signInWithCredential(credential);
  }



  Widget header(phoneSize){

    return Container(
      decoration: BoxDecoration(
          color: Color(0xFAFAFA),
      ),
      width: phoneSize.width,
      height: 12.0.h,
      child: Padding(
        padding:  EdgeInsets.all(5.0.w),
        child: Padding(
          padding:  EdgeInsets.only(left:0.0.w),
          child: _auth.currentUser!.displayName!=null?Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  Container(
                    height: 10.w,
                    width: 10.w,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("asset/profil.png")
                        )
                    ),
                  ),
                  SizedBox(width: 3.w,),
                  Text("Merhaba,  ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15.0.sp),),
                  _auth.currentUser!.displayName!=null?
                  Text(_auth.currentUser!.displayName!,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15.0.sp),):  Text("",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15.0.sp),),
                ],
              ),

            //  Icon(Icons.notifications,color: Colors.grey,)

              Stack(
                children: [
                  selected_index==3&&_auth.currentUser==null?
                  InkWell(onTap: ()async{

                    await signIn().then((value) {
                      setState(() {

                      });
                    });


                  },child: Padding(
                    padding: EdgeInsets.only(left:45.0.w,top:15),
                    child: Icon(Icons.person,color: Colors.grey,),
                  )):Container(),
                  /*
                  selected_index==3&&_auth.currentUser!=null?
                  Padding(
                    padding:  EdgeInsets.only(top:3.9.w),
                    child: InkWell(onTap: ()async{

                      AuthService().signOutWithGoogle(context).then((value) {
                        setState(() {
                          Navigator.of(context).pushReplacementNamed("/login");

                        });
                      });

                 AuthService().signOut().then((value) {
                     setState(() {

                     });
                 });
                    },child: Icon(Icons.clear,color: Colors.red,)),
                  ):Container()


                   */

                ],
              ),


            ],
          ):Row(
            children: [
              Container(
                height: 10.w,
                width: 10.w,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("asset/profil.png")
                    )
                ),
              ),
              SizedBox(width: 3.w,),

              Text("Merhaba ${_home_provider.name}",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 15.0.sp),),
              //  Icon(Icons.notifications,color: Colors.grey,)

              /*
              Padding(
                padding: EdgeInsets.only(left:55.0.w,top:15),
                child: Stack(
                  children: [
                    selected_index==3&&_auth.currentUser==null?
                    InkWell(onTap: ()async{

                      await signIn().then((value) {
                        setState(() {

                        });
                      });


                    },child: Icon(Icons.person,color: Colors.grey,)):Container(),
                    selected_index==3&&_auth.currentUser!=null?
                    InkWell(onTap: ()async{
                      _auth.currentUser!.displayName!=null?
                      await AuthService().signOutWithGoogle(context):AuthService().signOut(context);
                    },child: Icon(Icons.clear,color: Colors.red,)):Container()


                  ],
                ),
              ),

               */

            ],
          )
        ),
      ),
    );

  }

  Widget bottomBar(phoneSize){
    return  Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(39),
        color: Color(0xffFAFAFA),
      ),
      width: phoneSize.width-10.w,
      height: 9.0.h,
      child: Padding(
        padding:  EdgeInsets.all(5.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: (){
                  selected_index=0;
                  setState(() {

                  });
                },
                child:ImageIcon(
                  AssetImage("asset/home.png"),
                  color:selected_index==0?Color(0xff2D85EB):Colors.grey,
                ),

            ),

            InkWell(
                onTap: (){
                  selected_index=1;
                  setState(() {

                  });
                },
                child: ImageIcon(
                  AssetImage("asset/kategori.png"),
                  color:selected_index==1?Color(0xff2D85EB):Colors.grey,
                ),),
            InkWell(
                onTap: (){
                  selected_index=2;
                  setState(() {

                  });
                },
                child: ImageIcon(
                  AssetImage("asset/begeniler.png"),
                  color:selected_index==2?Color(0xff2D85EB):Colors.grey,
                ),),



            InkWell(
                onTap: (){
                  selected_index=3;
                  setState(() {

                  });
                },
                child: ImageIcon(
                  AssetImage("asset/profilalt.png"),
                  color:selected_index==3?Color(0xff2D85EB):Colors.grey,
                ),),

          ],
        ),
      ),
    );

  }

  List<Widget> bodyList=[];

  @override
  void initState() {
    _auth =FirebaseAuth.instance;
    // TODO: implement initState
    bodyList.add(Home_Widget());
    bodyList.add(Category_Screen());
    bodyList.add(Begeni_Screen());
    bodyList.add(Profile_Screen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size phoneSize=MediaQuery.of(context).size;
    _home_provider=Provider.of<Home_Provider>(context);
    return Scaffold(

    body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: [Color(0xFAFAFA), Color(0xffE8ECF4)])
        ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 4.w,),
              header(phoneSize),
              SizedBox(height: 4.w,),

              bodyList[selected_index],
              Padding(
                padding:  EdgeInsets.only(bottom:8.0.w,),
                child: bottomBar(phoneSize),
              )
            ],
          ),

        ],
      ),
    ),

    );
  }

  @override
  void afterFirstLayout(BuildContext context)async {
  await  _home_provider.getUserName(_auth.currentUser!.uid);

  }
}
