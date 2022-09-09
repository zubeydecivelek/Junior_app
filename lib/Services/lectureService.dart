import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:juniorapp/Models/UserModel.dart';
import 'package:juniorapp/Services/authService.dart';
import '../Pages/RegisterPage.dart';
import 'package:firebase_storage/firebase_storage.dart';


class LectureService{
  String uid =FirebaseAuth.instance.currentUser!.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference lectures = FirebaseFirestore.instance.collection('lectures');


  Future<String> takeNewImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      var file = File(image.path);
      print("meraba uykum var");
      CroppedFile? crp = await imageCropper(file);
      if (crp != null) {
        file = File(crp.path);
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference reference =
        storage.ref().child('lectureImages/${uid}/${Timestamp.now()}');
        UploadTask task = reference.putFile(file);
        await task.whenComplete(() {
          print("uploaded");
        });
        String url = await reference.getDownloadURL();
        return url;
      }
    }
    return "";
  }

  Future<CroppedFile?> imageCropper(File file) async {
    CroppedFile? croppedphoto = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
      //aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      //maxWidth: 800,
    );

    return croppedphoto;
  }

  Future createLecture(String imageURL, Timestamp time, String title,String statement,String requirements)async{
    UserModel user = await AuthService().getMe();
    await lectures.add({
      "imageLink":imageURL,
      "time": time,
      "title":title,
      "publishedBy": "${user.name} ${user.surname}",
      "statement": statement,
      "requirements":requirements,
    }).then((value) async{
      await lectures.doc(value.id).update({"lectureID": value.id});
    });

  }
}