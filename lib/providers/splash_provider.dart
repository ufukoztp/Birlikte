import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

abstract class SplashProviderUseCases {
  startTime();

  navigationPage();

  initializeVideo();
}

class SplashProvider with ChangeNotifier implements SplashProviderUseCases {

   late VideoPlayerController _playerController;
   late VoidCallback _listener;
   late BuildContext _context;
    bool _initailizePlayer=false;

  bool get initailizePlayer => _initailizePlayer;

  set initailizePlayer(bool value) {
    _initailizePlayer = value;
    notifyListeners();
  }

  SplashProvider() {

    this._listener = listener = () {
      notifyListeners();
    };


    notifyListeners();
  }

  reSplashProvider() {
    notifyListeners();
  }


  @override
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  @override
  navigationPage() async {


    Navigator.of(context).pushNamedAndRemoveUntil("/onboarding", (route) => false);



  }

  @override
  initializeVideo() {
    playerController = VideoPlayerController.asset('asset/Birlikte.mp4')
      ..addListener(listener)
      ..setVolume(0.0)
      ..initialize()
      ..play();
    notifyListeners();
  }

  ///Getters
  ///
  VoidCallback get listener => _listener;

  VideoPlayerController get playerController => _playerController;

  // ignore: unnecessary_getters_setters
  BuildContext get context => _context;

  // ignore: unnecessary_getters_setters

  ///Setters
  ///
  set listener(VoidCallback value) {
    _listener = value;
    notifyListeners();
  }

  set playerController(VideoPlayerController value) {
    _playerController = value;
    notifyListeners();
  }

  // ignore: unnecessary_getters_setters
  set context(BuildContext value) {
    _context = value;
  }

  // ignore: unnecessary_getters_setters

  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    //super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('Provider', Provider));
  }
}
