import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juniorapp/Models/UserModel.dart';

class LectureModel{

  String lectureID;
  String imageLink;
  Timestamp time;
  String title;
  Map<String, String> publishedByNameAndPP;
  String statement;
  String requirements;
  String liveVideoLink;
  bool isStreaming;

  LectureModel(this.lectureID, this.imageLink, this.time, this.title, this.publishedByNameAndPP,
      this.statement, this.requirements,this.liveVideoLink,this.isStreaming);

  factory LectureModel.fromSnapshot(DocumentSnapshot doc){
    return LectureModel(
      doc["lectureID"],
      doc["imageLink"],//
      doc["time"],//
      doc["title"],//
      doc["publishedByNameAndPP"].cast<String,String>(),//
      doc["statement"],//
      doc["requirements"],//
      doc["liveVideoLink"],//
      doc["isStreaming"],//
    );
  }
}