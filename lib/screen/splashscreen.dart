import 'package:after_layout/after_layout.dart';
import 'package:birlikte_app/providers/splash_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';


class SplashScreen extends StatefulWidget {


  SplashScreen();

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with AfterLayoutMixin<SplashScreen> {
  late VideoPlayerController _controller;

  late SplashProvider splashProvider;

  @override
  void afterFirstLayout(BuildContext context) {
    splashProvider.startTime();

  }



  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'asset/Birlikte.mp4')
      ..initialize().then((_) {
        setState(() {

          _controller.play();

        });
      });
  }


  @override
  Widget build(BuildContext context) {

    splashProvider = Provider.of<SplashProvider>(context);
    splashProvider.context=context;

    return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
          new AspectRatio(
              aspectRatio: 9 / 16,
              child: Container(
                child: (_controller.value.isInitialized
                    ? VideoPlayer(

                  _controller,
                ) : Container()),
              )),
        ]));
  }
}
