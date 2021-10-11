import 'package:birlikte_app/model/campaigns.dart';
import 'package:birlikte_app/model/enums.dart';
import 'package:birlikte_app/repo/remote_repo.dart';
import 'package:flutter/material.dart';

class Home_Provider with ChangeNotifier{


  bool _nameLoading=false;

  bool get nameLoading => _nameLoading;

  set nameLoading(bool value) {
    _nameLoading = value;
    notifyListeners();
  }

   String _name="";

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  Remote_Repo _remote_repo=Remote_Repo();
  List<Campaigns> campaigns=[];
  bool _campaign_request_is_done=false;

  bool get campaign_request_is_done => _campaign_request_is_done;

  set campaign_request_is_done(bool value) {
    _campaign_request_is_done = value;
    notifyListeners();
  }

  getCampaigns()async{

    try{
      campaigns=await _remote_repo.getCampaignList();
      campaign_request_is_done=true;
      print(campaigns[0].title);

    }catch(e){
      print("hata");
    }


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





}