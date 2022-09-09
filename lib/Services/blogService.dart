import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:juniorapp/Models/BlogItemModel.dart';
import 'package:url_launcher/url_launcher.dart';
class BlogService{
  CollectionReference blog = FirebaseFirestore.instance.collection("blog");
  Future<void> createBlog()async {
    await blog.add({

    });
  }

  Future<List<BlogItemModel>> getBlogs()async{
    List<BlogItemModel> objList=[];
    QuerySnapshot querySnapshot = await blog.get();
    for(int i=0;i<querySnapshot.docs.length;i++){
      DocumentSnapshot advantageDoc = querySnapshot.docs[i];
      objList.add(BlogItemModel.fromSnapshot(advantageDoc));
    }
    return objList;
  }

  Future<void>getBlog()async{
    List<BlogItemModel> blogList=[];
   // QuerySnapshot querySnapshot = blog.getDocuments();
   }



  Future<void> launchURL(String url,String path) async{
    final Uri uri = Uri(scheme: "https",host: url,path:path );
    if(!await launchUrl(
      uri,
      mode: LaunchMode.inAppWebView,

    )){
throw("olmadı");
    }
  }
}