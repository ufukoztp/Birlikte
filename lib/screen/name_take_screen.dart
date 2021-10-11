import 'package:after_layout/after_layout.dart';
import 'package:birlikte_app/main.dart';
import 'package:birlikte_app/model/enums.dart';
import 'package:birlikte_app/providers/name_take_provider.dart';
import 'package:birlikte_app/repo/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Name_Take extends StatefulWidget {
  @override
  _Name_TakeState createState() => _Name_TakeState();
}

class _Name_TakeState extends State<Name_Take> with AfterLayoutMixin<Name_Take> {
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late FirebaseAuth _auth;
  late NameTakepProvider _nameTakepProvider ;




  @override
  void initState() {
    // TODO: implement initState
    _auth = FirebaseAuth.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _nameTakepProvider=Provider.of<NameTakepProvider>(context);
    _nameTakepProvider.context=context;
    return Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child:_nameTakepProvider.nameIsLoading==true? Padding(
              padding: EdgeInsets.only(
                  top: 60.0.w, bottom: 20.0.w, right: 5.w, left: 5.w),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0.w, bottom: 10.0.w),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(top:8.0.w),
                          child: Text("Size nasıl hitap edelim?"),
                        ),

                        Padding(
                          padding: EdgeInsets.all(5.0.w),
                          child: TextFormField(
                            onChanged: (s){
                            },
                            controller: numberController,

                            cursorColor: Colors.blueAccent,

                            validator: (String? arg) {
                              if (arg!.length <= 0) {
                                return "İsim giriniz";
                              }
                            },
                            decoration: new InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueAccent)

                                ),

                                hintText: "İsim",
                                hintStyle: TextStyle(fontSize: 14.0.sp),

                                counterText: ""),
                          ),
                        ),
                        /*
                      Padding(
                        padding:  EdgeInsets.all(5.0.w),
                        child: TextFormField(
                          controller: passwordController,

                          cursorColor: Colors.blueAccent,

                          validator: (String? arg) {
                            if(arg!.length<=6){
                              return "Lütfen geçerli bir şifre giriniz";
                            }


                          },
                          keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                          decoration: new InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent)

                            ),

                              contentPadding: EdgeInsets.only(top: 10.0),
                              hintText: "  Şifre",
                              hintStyle: TextStyle(fontSize: 14.0.sp),

                              alignLabelWithHint: true,
                              counterText: ""),
                        ),
                      ),
                       */
                        Padding(
                          padding: EdgeInsets.only(top: 2.0.h,bottom: 3.h),
                          child: InkWell(
                            onTap: () async{

                              if(formKey.currentState!.validate()){
                                _nameTakepProvider.name=numberController.text;
                                await _nameTakepProvider.setUserName(_auth.currentUser!.uid);
                              }

                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceEvenly,
                                children: [
                                  Center(
                             child:Text('İlerle',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)
                                  ) ],
                              ),
                              decoration: BoxDecoration(
                                  color: Color(0xff517BED),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              height: 7.0.h,
                              width: 77.0.w,
                            ),
                          ),
                        ),



                      ],
                    ),
                  ),
                ),
              ),
            ):Align(
                alignment: Alignment.center,
                child: Center(child: CircularProgressIndicator()))
          ),
        )

    );
  }

  @override
  void afterFirstLayout(BuildContext context) async{
    // TODO: implement afterFirstLayout
      await _nameTakepProvider.getUserName(_auth.currentUser!.uid);

  }
}

