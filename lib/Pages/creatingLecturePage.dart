import 'dart:io';
import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:image_picker/image_picker.dart';
class CreatingLecture extends StatefulWidget {
  const CreatingLecture({Key? key}) : super(key: key);

  @override
  State<CreatingLecture> createState() => _CreatingLectureState();
}

class _CreatingLectureState extends State<CreatingLecture> {
  dynamic file;
  final title = TextEditingController();
  final requirements = TextEditingController();
  final statement = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios,color: ColorPalette().blue,),
          onTap: (){},
        ),
        title: Text("Ders Oluşturma",style: TextStyle(color: ColorPalette().blue),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.width*0.4,
                  width: MediaQuery.of(context).size.width*0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.rectangle,
                    image: (file!=null)? DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file),
                    ): null,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.5,
              child: ElevatedButton(
                onPressed: (){
                  imagePicker();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image),
                    Text("Görsel Yükle"),
                  ],
                ),
              ),

            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Ders Başlığı",style: TextStyle(fontWeight: FontWeight.bold,color: ColorPalette().blue),),
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0,bottom: 8),
                  child: Text("Gereksinimler",style: TextStyle(fontWeight: FontWeight.bold,color: ColorPalette().blue),),
                ),
                TextField(
                  controller: requirements,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0,bottom: 8),
                  child: Text("Ders İçeriği",style: TextStyle(fontWeight: FontWeight.bold,color: ColorPalette().blue),),

                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  child: TextField(
                    controller: statement,
                    maxLines: 10,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  void imagePicker()async {
    XFile? image= await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        file= File(image.path);
      });
    }
  }
}
