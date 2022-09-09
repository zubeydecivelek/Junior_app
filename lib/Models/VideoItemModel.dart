

import 'package:cloud_firestore/cloud_firestore.dart';

class VideoItemModel {

  String headline;
  String owner;
  String photoLink;
  String videoLink;

  VideoItemModel({
    required this.headline,
    required this.owner,
    required this.photoLink,
    required this.videoLink
});



  factory VideoItemModel.fromSnapshot(DocumentSnapshot doc) {

    return VideoItemModel(
      headline: doc['headline'],
      owner: doc['owner'],
      photoLink: doc['photoLink'],
      videoLink: doc["videoLink"],
    );

  }
}