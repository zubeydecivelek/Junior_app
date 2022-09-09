import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juniorapp/Models/UserModel.dart';

class LectureModel{

  String lectureID;
  String imageLink;
  Timestamp time;
  String title;
  UserModel publishedBy;
  String statement;
  String requirements;

  LectureModel(this.lectureID, this.imageLink, this.time, this.title, this.publishedBy,
      this.statement, this.requirements);
}