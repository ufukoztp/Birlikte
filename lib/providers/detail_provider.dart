import 'package:birlikte_app/model/campaigns.dart';
import 'package:birlikte_app/model/detail_arguments.dart';
import 'package:birlikte_app/model/enums.dart';
import 'package:birlikte_app/repo/remote_repo.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Detail_Provider with ChangeNotifier{
  DETAILROUTE? routeType;

  String _name="";
  bool _nameLoading=false;

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  late Campaigns? _campaigns;

  late int _win_cost;

  int get win_cost => _win_cost;

  set win_cost(int value) {
    _win_cost = value;
    notifyListeners();
  }

  int _pop_up_user_points=0;

  int get pop_up_user_points => _pop_up_user_points;

  set pop_up_user_points(int value) {
    _pop_up_user_points = value;
    notifyListeners();
  }

  late int _complete_cost;

   bool _sharePopUpViewState=false;


  bool get sharePopUpViewState => _sharePopUpViewState;

  set sharePopUpViewState(bool value) {
    _sharePopUpViewState = value;
    notifyListeners();
  }

  int get complete_cost => _complete_cost;

  set complete_cost(int value) {
    _complete_cost = value;
    notifyListeners();
  }

  Campaigns? get campaigns => _campaigns;

  set campaigns(Campaigns? value) {
    _campaigns = value;
    notifyListeners();
  }

  late RewardedAd reward;
  String _campaign_name="";
  int all_points=0;
  Remote_Repo _remote_repo=Remote_Repo();
  bool _campaign_request_is_done=false;
  var _user_points;


  Remote_Repo get remote_repo => _remote_repo;

  set remote_repo(Remote_Repo value) {
    _remote_repo = value;
    notifyListeners();
  }

  bool _isLoading_user_points=false;

  bool _isLoading_reward=false;


  String get campaign_name => _campaign_name;

  set campaign_name(String value) {
    _campaign_name = value;
    notifyListeners();
  }

  bool get isLoading_reward => _isLoading_reward;

  set isLoading_reward(bool value) {
    _isLoading_reward = value;
    notifyListeners();
  }

  bool get isLoading_user_points => _isLoading_user_points;

  set isLoading_user_points(bool value) {
    _isLoading_user_points = value;
    notifyListeners();
  }



   get user_points => _user_points;

  set user_points(var value) {
    _user_points = value;
    notifyListeners();
  }

  bool get campaign_request_is_done => _campaign_request_is_done;

  set campaign_request_is_done(bool value) {
    _campaign_request_is_done = value;
    notifyListeners();
  }




  Future setPoints(campaign_name,points,uid)async{
    await _remote_repo.setCampaign(campaign_name,points,uid).then((value) {
      complete_cost=user_points;
      campaigns!.allPoints-=user_points as int;
      user_points=0;
    });

  }
  Future setUserPoints(campaign_name,uid,points)async{
    await _remote_repo.setUserPoints(campaign_name,uid,points);

  }


  Future getUserPoints(campaign_name,uid)async{
    await _remote_repo.getUserPoints(campaign_name, uid).then((value) {
      print("gelen değer"+value.toString());
      _user_points=value;
      isLoading_user_points=true;
    });
  }


  Future<bool> showRewarded(campaign_name,uid)async{

     await reward.show(onUserEarnedReward: (RewardedAd ad, RewardItem rewardItem) {
      }).then((value) async{
        print("kapatıldı");
        });
     notifyListeners();
     return true;

  }



  Future getCampaigns(campaign_name)async{

      await _remote_repo.getCampaign(campaign_name).then((value) {
        if(value!=null){
          campaigns=value;
          print("campaigns done");
        }
      });
      campaign_request_is_done=true;



  }



  Future getUserName(uid)async{
    try{
      // ignore: null_check_always_fails
      (await _remote_repo.getUserName(uid).then((value) {
        nameLoading=true;
        name=value!;
      }))!;
    }catch(e){

    }
    notifyListeners();
  }

  bool get nameLoading => _nameLoading;

  set nameLoading(bool value) {
    _nameLoading = value;
    notifyListeners();
  }
}