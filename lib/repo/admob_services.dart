
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState{
  late RewardedAd reward;


  static final AdState _dbHelper = AdState._internal();


  factory AdState() => _dbHelper;

  AdState._internal();


  String get bannerAdUnitId{
    if(Platform.isAndroid){
      return "";
    }else{
      return "";
    }
  }

/*

  Future showRewarded()async{

    RewardedAd.load(
        adUnitId: 'ca-app-pub-9790530714505384/4156815087',
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('DENEME + $ad loaded.');
            // Keep a reference to the ad so you can show it later.
            reward = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {

            print('RewardedAd failed to load: $error');

          },
        )).then((value) {



    });








  }


 */



}