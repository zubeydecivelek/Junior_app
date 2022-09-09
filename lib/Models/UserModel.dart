import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String userID;
  String name;
  String surname;
  String phoneNumber;
  String ppLink;
  String subscriptionType;
  String email;
  bool isAdmin;
  Timestamp membershipDate;
  Timestamp subscriptionStarting;
  Timestamp subscriptionEnding;
  int remainingFreeLecture;

  static String gunluk ="Günlük"; //1
  static String haftalik ="Haftalık"; //2
  static String ucretsiz ="Ücretsiz"; //0
  static String aylik ="Aylık"; //3

  UserModel(
      this.userID,
      this.name,
      this.surname,
      this.phoneNumber,
      this.ppLink,
      this.subscriptionType,
      this.email,
      this.isAdmin,
      this.membershipDate,
      this.subscriptionStarting,
      this.subscriptionEnding,
      this.remainingFreeLecture);

  factory UserModel.fromSnapshot(DocumentSnapshot doc){
    return UserModel(
      doc["userID"],
      doc["name"],
      doc["surname"],
      doc["phoneNumber"],
      doc["ppLink"],
      doc["subscriptionType"],
      doc["email"],
      doc["isAdmin"],
      doc["membershipDate"],
      doc["subscriptionStarting"],
      doc["subscriptionEnding"],
      doc["remainingFreeLecture"],
    );
  }
}