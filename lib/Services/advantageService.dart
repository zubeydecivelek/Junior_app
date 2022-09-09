import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juniorapp/Models/AdvantageItemModel.dart';

class AdvantageService{
  CollectionReference advantages= FirebaseFirestore.instance.collection("advantages");


  Future<List<AdvantageItemModel>> getAdvantages()async{
    List<AdvantageItemModel> objList=[];
   QuerySnapshot querySnapshot = await advantages.get();
   for(int i=0;i<querySnapshot.docs.length;i++){
     DocumentSnapshot advantageDoc = querySnapshot.docs[i];
     objList.add(AdvantageItemModel.fromSnapshot(advantageDoc));
   }
   return objList;
  }


}