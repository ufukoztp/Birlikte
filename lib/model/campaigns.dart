class Campaigns{
   String photo="";
   int allPoints=0;
   String title="";
   String description="";
   String campaign_puzzle_photo="";
   String campaignName="";
   String descriptionDetail="";
   String inst_url="";

   Campaigns({required this.title,required this.photo,required this.description,required this.allPoints});

   Campaigns.fromJsonMap(Map<String, dynamic> map):
          description = map["description"],
          allPoints = map["all_points"],
          campaignName = map["campaign_name"],
          campaign_puzzle_photo = map["campaign_puzzle_photo"],
          title = map["title"],
          inst_url = map["inst_url"],
          descriptionDetail = map["description_detail"],
          photo = map["photo"];
}