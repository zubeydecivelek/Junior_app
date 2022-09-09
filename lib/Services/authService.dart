import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:juniorapp/Models/UserModel.dart';
import '../Pages/RegisterPage.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  ///TODO KULLANICI ÖNCEDEN VAR MI KONTROL ET
  ///USERS.DOC.UID.GET try ile yap hata çıkarsa kullanıcı yok.

  Future<bool> checkRegistered(String uid) async {
    try {
      DocumentSnapshot doc = await users.doc(uid).get();
      String name = doc["name"];
      print(name);
      print(doc);
    } catch (e) {
      print("kullanıcı yok amk");
      return false;
    }
    print("kullanıcı var amk");
    return true;
  }

  Future<void> updateUserInfos(
      String name, String surname, String email) async {
    try {
      await users
          .doc(uid)
          .update({"name": name, "surname": surname, "email": email});
    } catch (e) {
      print("Kullanıcı güncellenemedi");
    }
    print("Kullanıcı güncellendi");
  }

  Future<void> updateSubscription(int type) async {
    if (type == 1) {
      DateTime now = DateTime.now();
      DateTime tomorrow = now.add(Duration(days: 1));
      await users.doc(uid).update({
        "subscriptionType": "Günlük",
        "subscriptionStarting": Timestamp.now(),
        "subscriptionEnding": Timestamp.fromDate(tomorrow)
      });
    } else if (type == 2) {
      DateTime now = DateTime.now();
      DateTime nextWeek = now.add(Duration(days: 7));
      await users.doc(uid).update({
        "subscriptionType": "Haftalık",
        "subscriptionStarting": Timestamp.now(),
        "subscriptionEnding": Timestamp.fromDate(nextWeek)
      });
    } else if (type == 3) {
      DateTime now = DateTime.now();
      DateTime nextMonth = now.add(Duration(days: 30));
      await users.doc(uid).update({
        "subscriptionType": "Aylık",
        "subscriptionStarting": Timestamp.now(),
        "subscriptionEnding": Timestamp.fromDate(nextMonth)
      });
    }
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => RegisterPage()));
    }).onError((error, stackTrace) {
      print("çıkış yapılamadı");
      showSnackBarText(context, "Hata oluştu. Lütfen sonra tekrar deneyin.");
    });
  }

  Future<void> register(String phoneNumber, String uid) async {
    Map<String, dynamic> usermap = {
      "userID": uid,
      "name": "name",
      "surname": "surname",
      "phoneNumber": phoneNumber,
      "ppLink":
          "https://firebasestorage.googleapis.com/v0/b/juniorapp-99648.appspot.com/o/defaultPP%2F360_F_128563455_bGrVZnfDCL0PxH1sU33NpOhGcCc1M7qo.jpg?alt=media&token=14ceeeae-fce3-4288-8ec9-ccd83c65b04c",
      "subscriptionType": "Ücretsiz",
      "email": "email",
      "isAdmin": false,
      "membershipDate": Timestamp.now(),
      "subscriptionStarting": Timestamp.fromDate(DateTime(2001, 6, 4)),
      "subscriptionEnding": Timestamp.fromDate(DateTime(2001, 6, 4)),
      "remainingFreeLecture": 3
    };
    await users.doc(uid).set(usermap).onError((error, stackTrace) {
      print("İLGİLİ HATA:::: $error");
    });
  }

  void showSnackBarText(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Future<void> sendOpinion(String opinion) async {
    UserModel me = await getMe();
    await FirebaseFirestore.instance.collection("opinions").add({
      "opinion": opinion,
      "userName": me.name,
      "userSurname": me.surname,
      "phoneNumber": me.phoneNumber,
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection("opinions")
          .doc(value.id)
          .update({"UID": value.id});
    });
  }

  Future<UserModel> getMe() async {
    DocumentSnapshot doc = await users.doc(uid).get();
    return UserModel.fromSnapshot(doc);
  }


}
