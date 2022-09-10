import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:juniorapp/Models/UserModel.dart';
import 'package:juniorapp/Models/VideoItemModel.dart';
import 'package:juniorapp/Services/authService.dart';
import '../Pages/RegisterPage.dart';
import 'package:firebase_storage/firebase_storage.dart';


class VideoService{
  CollectionReference videos= FirebaseFirestore.instance.collection("videos");

  Future<List<VideoItemModel>> getVideos()async{
    List<VideoItemModel> videoList = [];
    QuerySnapshot querySnapshot = await videos.get();
    for(int i=0;i<querySnapshot.docs.length;i++){
      DocumentSnapshot videoDoc = querySnapshot.docs[i];
      videoList.add(VideoItemModel.fromSnapshot(videoDoc));
    }
    return videoList;
}


}