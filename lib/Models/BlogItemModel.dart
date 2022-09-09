import 'package:cloud_firestore/cloud_firestore.dart';

class BlogItemModel {
  String blogID;
  String category;
  String title;

  String blogLinkHost;
  String blogLinkPath;

  String imageLink;
  Timestamp time;

  static String eglence = "Eğlence";

  static String seyehat = "Seyahat";
  ///TODO diğer türleri belirt

  BlogItemModel(
      this.blogID, this.category, this.title, this.blogLinkHost,this.blogLinkPath, this.imageLink, this.time);


  factory BlogItemModel.fromSnapshot(DocumentSnapshot doc){
    return BlogItemModel(
        doc["blogID"],
        doc["category"],
        doc["title"],
        doc["blogLinkHost"],
        doc["blogLinkPath"],
        doc["imageLink"],
        doc["time"],
      );
  }
}