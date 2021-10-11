import 'dart:async';
import 'dart:io';

import 'package:birlikte_app/flappy_bird_game/bird.dart';
import 'package:birlikte_app/model/enums.dart';
import 'package:birlikte_app/providers/detail_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'barriers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirebaseAuth _auth;
  int sayac=3;
  late Detail_Provider _detail_provider;



  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  double barrierXone = 1.8;
  double barrierXtwo = 1.8 + 1.5;
  double barrierXthree = 1.8 + 3;
  bool gameStarted = false;
  int score = 0;
  int highscore = 0;

  @override
  void initState() {
    setState(() {
      birdYaxis = 0;
      time = 0;
      height = 0;
      initialHeight = birdYaxis;
      barrierXone = 1.8;
      barrierXtwo = 1.8 + 1.5;
      barrierXthree = 1.8 + 3;
      gameStarted = false;
      score = 0;
    });
    _auth=FirebaseAuth.instance;
  }

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  bool checkLose() {
    if (barrierXone < 0.2 && barrierXone > -0.2) {
      if (birdYaxis < -0.3 || birdYaxis > 0.7) {
        return true;
      }
    }
    if (barrierXtwo < 0.2 && barrierXtwo > -0.2) {
      if (birdYaxis < -0.8 || birdYaxis > 0.4) {
        return true;
      }
    }
    if (barrierXthree < 0.2 && barrierXthree > -0.2) {
      if (birdYaxis < -0.4 || birdYaxis > 0.7) {
        return true;
      }
    }
    return false;
  }

  void startGame()async {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 60), (timer)async {
      time += 0.05;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
        if (barrierXone < -2) {
          score++;
          barrierXone += 4.5;
        } else {
          barrierXone -= 0.04;
        }
        if (barrierXtwo < -2) {
          score++;

          barrierXtwo += 4.5;
        } else {
          barrierXtwo -= 0.04;
        }
        if (barrierXthree < -2) {
          score++;

          barrierXthree += 4.5;
        } else {
          barrierXthree -= 0.04;
        }
      });
      if (birdYaxis > 1.3 || checkLose()) {
        setState(() {
          sayac-=1;
        });
          if(sayac==0){
            _detail_provider.routeType=DETAILROUTE.GAME;

            print("success true");
            await   _detail_provider.setUserPoints(_detail_provider.campaign_name,_auth.currentUser!.uid,1);
            _detail_provider.user_points+=1;
            _detail_provider.win_cost=1;
            setState(() {
              sayac=3;
            });
            await _detail_provider.showRewarded(_detail_provider.campaign_name,_auth.currentUser!.uid).then((value) {
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
              
                  Navigator.of(context).pushNamed("/congratulations",arguments: _detail_provider);
                });

              }

            });


          }

        timer.cancel();
        _showDialog();
      }
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Text(
              "GAME OVER",
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              "Score: " + score.toString(),
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              FlatButton(
                child: Text(
                  "PLAY AGAIN",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  if (score > highscore) {
                    highscore = score;
                  }
                  initState();
                  setState(() {
                    gameHasStarted = false;
                  });
                  Navigator.of(context).pop();
                  
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _detail_provider=Provider.of<Detail_Provider>(context);

    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          actions: [
            Center(child: Text("Kalan can: ${sayac}")),
            SizedBox(width:5.w),

          ],

        ),
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(0, birdYaxis),
                      duration: Duration(milliseconds: 0),
                      color: Colors.blue,
                      child: MyBird(),
                    ),
                    Container(
                      alignment: Alignment(0, -0.3),
                      child: gameHasStarted
                          ? Text(" ")
                          : Text("T A P  T O  P L A Y",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                    AnimatedContainer(
                  alignment: Alignment(barrierXone, 1.1),
                  duration: Duration(milliseconds: 0),
                  child: MyBarrier(
                    size: 200.0,
                  ),
                ),
                AnimatedContainer(
                  alignment: Alignment(barrierXtwo, 1.1),
                  duration: Duration(milliseconds: 0),
                  child: MyBarrier(
                    size: 300.0,
                  ),
                ),
                AnimatedContainer(
                  alignment: Alignment(barrierXthree, 1.1),
                  duration: Duration(milliseconds: 0),
                  child: MyBarrier(
                    size: 100.0,
                  ),
                ),
                AnimatedContainer(
                  alignment: Alignment(barrierXone, -1.1),
                  duration: Duration(milliseconds: 0),
                  child: MyBarrier(
                    size: 150.0,
                  ),
                ),
                AnimatedContainer(
                  alignment: Alignment(barrierXtwo, -1.1),
                  duration: Duration(milliseconds: 0),
                  child: MyBarrier(
                    size: 100.0,
                  ),
                ),
                AnimatedContainer(
                  alignment: Alignment(barrierXthree, -1.1),
                  duration: Duration(milliseconds: 0),
                  child: MyBarrier(
                    size: 200.0,
                  ),
                ),
                  ],
                )),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("SCORE",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        SizedBox(
                          height: 20,
                        ),
                        Text(score.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 35)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("BEST",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        SizedBox(
                          height: 20,
                        ),
                        Text(highscore.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 35)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
