import 'package:cloud_firestore/cloud_firestore.dart';

class AdvantageItemModel {
  String advantageID;
  String imageLink;
  String title;
  String subtitle;
  String ownerWebsite;
  String statement;
  Timestamp initDate;
  Timestamp expireDate;
  //expireDate??

  AdvantageItemModel(this.expireDate,this.subtitle,this.advantageID, this.imageLink, this.title, this.ownerWebsite, this.statement, this.initDate);

  factory AdvantageItemModel.fromSnapshot(DocumentSnapshot doc){
    return AdvantageItemModel(
        doc["expireDate"],
        doc["subtitle"],
        doc["advantageID"],
        doc["imageLink"],
        doc["title"],
        doc["ownerWebsite"],
        doc["statement"],
        doc["initDate"]);
  }
}