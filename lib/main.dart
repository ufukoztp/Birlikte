
import 'dart:io';

import 'package:birlikte_app/Utils/slide_left_route.dart';
import 'package:birlikte_app/flappy_bird_game/main.dart';
import 'package:birlikte_app/model/detail_arguments.dart';
import 'package:birlikte_app/providers/detail_provider.dart';
import 'package:birlikte_app/providers/home_provider.dart';
import 'package:birlikte_app/providers/name_take_provider.dart';
import 'package:birlikte_app/providers/splash_provider.dart';
import 'package:birlikte_app/repo/auth_service.dart';
import 'package:birlikte_app/screen/congratulations_screen.dart';
import 'package:birlikte_app/screen/detail.dart';
import 'package:birlikte_app/screen/game_select_page.dart';
import 'package:birlikte_app/screen/layout.dart';
import 'package:birlikte_app/screen/name_take_screen.dart';
import 'package:birlikte_app/screen/onboarding_screen.dart';
import 'package:birlikte_app/screen/preloader_screen.dart';
import 'package:birlikte_app/screen/slidePuzzle.dart';
import 'package:birlikte_app/screen/splashscreen.dart';
import 'package:birlikte_app/widget/category_widget.dart';
import 'package:birlikte_app/widget/login_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();


  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context)=>Home_Provider()),
    ChangeNotifierProvider(create: (context)=>Detail_Provider()),
    ChangeNotifierProvider(create: (context)=>SplashProvider()),
    ChangeNotifierProvider(create: (context)=>NameTakepProvider()),
  ],
  child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'BİRLİKTE',
          theme: ThemeData.light(),

            routes: {
              "/": (context) {
                return SplashScreen();
              },

            },
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case "/detail":
                  return SlideLeftRoute(
                      page: Detail_Page(detail_arguments: settings.arguments as Detail_Arguments,)
                  );
                case "/category":
                  return SlideLeftRoute(
                      page: Category_Screen()
                  );
                case "/AuthService":
                  return SlideLeftRoute(
                      page: AuthService().handleAuth()
                  );
                case "/home":
                  return SlideLeftRoute(
                      page: Home_Page()
                  );
                case "/login":
                  return SlideLeftRoute(
                      page: Login_Widget()
                  );
                case "/name":
                  return SlideLeftRoute(
                      page: Name_Take()
                  );
                case "/game_select":
                  return SlideLeftRoute(
                      page: Game_Select(campaign_photo: settings.arguments as String,)
                  );
                case "/puzzle":
                  return SlideLeftRoute(
                      page: SlidePuzzle(image: settings.arguments as String,)
                  );
                case "/flappy_bird":
                  return SlideLeftRoute(
                      page: Flappy_Bird()
                  );
                case "/congratulations":
                  return SlideLeftRoute(
                      page: Congratulations_Screen(detail_provider:settings.arguments as Detail_Provider,)
                  );
                case "/onboarding":
                  return SlideLeftRoute(
                      page: IntroScreen()
                  );

                  break;
              }
            });
      },
    );
  }
}
 Preloader? preloader ;

//Preloader preloader =null;

void showPreloader(cxt, message) {
  if (preloader == null) {
    preloader = Preloader(message);
    Navigator.of(cxt).push(preloader!);
  } else
    preloader!.updateText(message);
}


void hidePreloader(context) {
  preloader = null;
  Navigator.of(context).pop();
}

