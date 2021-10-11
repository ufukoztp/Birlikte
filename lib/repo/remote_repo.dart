import 'package:birlikte_app/model/campaigns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Remote_Repo{

  Query query =
  FirebaseFirestore.instance.collection('campaign');



  ///parklist
  Future<List<Campaigns>> getCampaignList()async{

    List<Campaigns> campaignList=[];
    await query.get().then((querySnapshot) async {
      print(querySnapshot.size.toString()+'  gelen kampanya sayısı');

      querySnapshot.docs.forEach((document) {

        Map<String,dynamic> t=document.data() as Map<String,dynamic>;

        campaignList.add(Campaigns.fromJsonMap(t));

      });
    });
    return campaignList;
  }

  Future<Campaigns> getCampaign(campaign_name)async{
    DocumentReference query =
    FirebaseFirestore.instance.collection('campaign').doc(campaign_name);
    var campaigns;

try{
  await query.get().then((querySnapshot) async {

    Map<String,dynamic> t=querySnapshot.data() as Map<String,dynamic>;

    campaigns=Campaigns.fromJsonMap(t);


  });
}catch(e){
  campaigns=null;
}


    return campaigns as Campaigns;

  }


  ///ratings
  Future setCampaign(campaign_name,points,uid) async{

    DocumentReference query2 =  FirebaseFirestore.instance.collection('campaign').doc(campaign_name);

    await query2.update({
      'all_points': FieldValue.increment(-points)
    }).then((value)async {

      DocumentReference query2 =  FirebaseFirestore.instance.collection('User').doc("campaigns").collection("uid").doc(uid);

      try {
        await query2.update({
          'point': 0
        });
        print("puan arttırıldı");

      }catch(e){


      }




    });

    print("puan arttırıldı");
  }

  ///ratings
  Future setUserPoints(campaign_name,uid,points) async{

    DocumentReference query2 =  FirebaseFirestore.instance.collection('User').doc("campaigns").collection("uid").doc(uid);

    try {
      await query2.update({
        'point': FieldValue.increment(points)
      });
      print("puan arttırıldı");

    }catch(e){
      await query2.set({
        'point': FieldValue.increment(points)
      });
      print("puan arttırıldı");

    }




}

  Future setUserName(uid,name) async{

    DocumentReference query2 =  FirebaseFirestore.instance.collection("Names").doc(uid);


      await query2.set({
        'name': name
      });
      print("name set complete");

  }

  Future<String?> getUserName(uid) async{
    String? name;
    try{
      DocumentReference query2 =  FirebaseFirestore.instance.collection('Names').doc(uid);

      await query2.get().then((querySnapshot) {
        Map<String,dynamic> t=querySnapshot.data() as Map<String,dynamic>;

        name= t["name"] as String;

        print(name);
      });

      return name;


    }catch(e){
      return null;

    }




  }


  ///ratings
  Future<int?> getUserPoints(campaign_name,uid) async{
    int? point;
    try{
      DocumentReference query2 =  FirebaseFirestore.instance.collection('User').doc("campaigns").collection("uid").doc(uid);

      await query2.get().then((querySnapshot) {
        Map<String,dynamic> t=querySnapshot.data() as Map<String,dynamic>;

         point= t["point"] as int;

        print(point);
      });

      return point;


    }catch(e){
      return 0;

    }




  }




}