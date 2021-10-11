import 'dart:io';

import 'package:birlikte_app/main.dart';
import 'package:birlikte_app/model/enums.dart';
import 'package:birlikte_app/providers/name_take_provider.dart';
import 'package:birlikte_app/repo/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:the_apple_sign_in/apple_sign_in_button.dart';
import 'package:http/http.dart' as http;


class Login_Widget extends StatefulWidget {
  @override
  _Login_WidgetState createState() => _Login_WidgetState();
}

class _Login_WidgetState extends State<Login_Widget> {
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late NameTakepProvider _nameTakepProvider;
  late FirebaseAuth _auth;

   String phoneNo="";
       String  verificationId="";
  String smsCode="";

  bool codeSent = false;




  MaskTextInputFormatter _maskFormatter = new MaskTextInputFormatter(
  mask: '+90(###) ### ## ##', filter: {"#": RegExp(r'[0-9]')});


 GoogleSignIn _googleSignIn=GoogleSignIn();
  final _firebaseAuth = FirebaseAuth.instance;


  Future signIn()async {

    GoogleSignInAccount? googleUser=await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth =await googleUser!.authentication;


    AuthCredential credential =GoogleAuthProvider.credential(idToken: googleAuth.idToken,accessToken: googleAuth.accessToken);

    await _auth.signInWithCredential(credential).then((value) {
      Navigator.of(context).pushNamed("/AuthService");

    });
  }


  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
          String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final userCredential =
        await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = userCredential.user!;
        if (scopes.contains(Scope.fullName)) {
          final fullName = appleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
          }
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }


  Future<void> _signInWithApple(BuildContext context) async {
    try {



      final user = await signInWithApple(
          scopes: [Scope.email, Scope.fullName]).then((value) {
        Navigator.of(context).pushNamed("/AuthService");

      });
      print('uid: ${user.uid}');
    } catch (e) {
      // TODO: Show alert here
      print(e);
    }
  }

  Future login_number() async {
    _auth.signInWithEmailAndPassword(
        email: numberController.text, password: passwordController.text).then((
        value) {
      if (value.user!.emailVerified) {
        Navigator.of(context).pushNamed("/AuthService");
      }
    });
  }



    Future<void> verifyPhone(phoneNo) async {
    try{

      final PhoneVerificationCompleted verified = (AuthCredential authResult) {
        /*
        AuthService().signIn(authResult,context);

         */
      };

      final PhoneVerificationFailed verificationfailed =
          (FirebaseAuthException authException) {
        print('${authException.message}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Geçerli bir numara giriniz.")));

          };

      final PhoneCodeSent smsSent = (String verId, [int? forceResend]) {
        this.verificationId = verId;
        setState(() {
          this.codeSent = true;
        });
      };

      final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
        this.verificationId = verId;
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNo,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verified,
          verificationFailed: verificationfailed,
          codeSent: smsSent,
          codeAutoRetrievalTimeout: autoTimeout);

    }catch(e){
      print("hata");
    }

    }

    @override
    void initState() {
      // TODO: implement initState
      _auth = FirebaseAuth.instance;
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
    _nameTakepProvider=Provider.of<NameTakepProvider>(context);
      return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 20.0.w, bottom: 20.0.w, right: 5.w, left: 5.w),
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.0.w, bottom: 10.0.w),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 24.w,
                            width: 24.w,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage("asset/birlikteyuvarlak.png")
                              )
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Padding(
                            padding: EdgeInsets.all(5.0.w),
                            child: TextFormField(
                              onChanged: (s){
                                phoneNo=s.toString();
                              },
                              controller: numberController,

                              cursorColor: Colors.blueAccent,

                              validator: (String? arg) {
                                if (arg!.length <= 0) {
                                  return "Lütfen geçerli bir numara giriniz";
                                }
                              },
                              keyboardType:
                              TextInputType.number,
                              inputFormatters: [_maskFormatter],
                              decoration: new InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blueAccent)

                                  ),

                                  hintText: "  Telefon Numarası",
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

                          codeSent ? Padding(
                              padding: EdgeInsets.only(left: 25.0, right: 25.0),
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueAccent)

                                    ),
                                    hintText: 'Doğrulama Kodunu gir'),
                                onChanged: (val) {
                                  setState(() {
                                    this.smsCode = val;
                                  });
                                },
                              )) : Container(),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h,bottom: 3.h,left: 4.h,right: 4.h),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(2.0.h),
                              ),
                              color: Color(0xff517BED),
                              highlightColor: Colors.grey,
                              onPressed: () {
                                _nameTakepProvider.signType=SIGNTYPE.PHONE;
                                codeSent ? AuthService().signInWithOTP(
                                    smsCode, verificationId,context) : verifyPhone(
                                    phoneNo);
                              },
                              child: Padding(
                                padding:  EdgeInsets.all(2.5.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    Center(
                                        child: codeSent ? Text('Giriş Yap',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),) : Text(
                                            'Doğrulama kodu gönder',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 32.w,
                                color: Colors.grey,
                                height: 1,
                              ),
                              Text(" Ya da ", style: TextStyle(
                                  color: Colors.grey, fontSize: 12.sp),),
                              Container(
                                width: 32.w,
                                color: Colors.grey,
                                height: 1,
                              ),
                            ],
                          ),
                          /*
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h),
                            child: InkWell(
                              onTap: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  await login_number();
                                }
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    Text("Kayıt ol", style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),),
                                  ],
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
                           */
                          Padding(
                            padding: EdgeInsets.only(top: 2.0.h,left: 4.h,right: 4.h),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(2.0.h),
                              ),
                              color:Color(0xff517BED) ,
                              highlightColor: Colors.grey,

                              onPressed: () async{
                                _nameTakepProvider.signType=SIGNTYPE.GOOGLE;
                             await   signIn();
                              },
                              child: Padding(
                                padding:  EdgeInsets.all(2.5.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                    Text("Google ile giriş yap",
                                      style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w700),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 4.0.h,left: 4.h,right: 4.h),
                            child: AppleSignInButton(
                              cornerRadius: 12,

                              type: ButtonType.signIn,
                              onPressed: ()async {



                                final credential = await SignInWithApple.getAppleIDCredential(
                                  scopes: [
                                    AppleIDAuthorizationScopes.email,
                                    AppleIDAuthorizationScopes.fullName,
                                  ],
                                  webAuthenticationOptions: WebAuthenticationOptions(
                                    // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                                    clientId:
                                    'com.aboutyou.dart_packages.sign_in_with_apple.example',
                                    redirectUri: Uri.parse(
                                      'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                                    ),
                                  ),
                                  // TODO: Remove these if you have no need for them
                                  nonce: 'example-nonce',
                                  state: 'example-state',
                                );

                                print(credential);

                                // This is the endpoint that will convert an authorization code obtained
                                // via Sign in with Apple into a session in your system
                                final signInWithAppleEndpoint = Uri(
                                  scheme: 'https',
                                  host: 'flutter-sign-in-with-apple-example.glitch.me',
                                  path: '/sign_in_with_apple',
                                  queryParameters: <String, String>{
                                    'code': credential.authorizationCode,
                                    if (credential.givenName != null)
                                      'firstName': credential.givenName!,
                                    if (credential.familyName != null)
                                      'lastName': credential.familyName!,
                                    'useBundleId':
                                    Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
                                    if (credential.state != null) 'state': credential.state!,
                                  },
                                );

                                final session = await http.Client().post(
                                  signInWithAppleEndpoint,
                                );

                                // If we got this far, a session based on the Apple ID credential has been created in your system,
                                // and you can now set this as the app's session
                                print(session);

                              },
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )

      );
    }
  }

