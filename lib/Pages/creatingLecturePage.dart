import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:image_picker/image_picker.dart';
import 'package:juniorapp/Services/authService.dart';

import '../Services/lectureService.dart';

class CreatingLecturePage extends StatefulWidget {
  const CreatingLecturePage({Key? key}) : super(key: key);

  @override
  State<CreatingLecturePage> createState() => _CreatingLecturePageState();
}

class _CreatingLecturePageState extends State<CreatingLecturePage> {
  DateTime dateTime = DateTime.now();
  dynamic file;
  final title = TextEditingController();
  final lectureMinutes = TextEditingController();
  final lectureLink = TextEditingController();
  final requirements = TextEditingController();
  final statement = TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;
  String picUrl="";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorPalette().blue,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Ders Oluşturma",
          style: TextStyle(color: ColorPalette().blue),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Container(
            height: screenHeight * 0.1,
            color: Colors.white70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: screenHeight * 0.06,
                    width: screenWidth * 0.8,
                    child: (picUrl=="" || title.text.isEmpty || lectureLink.text.isEmpty||lectureMinutes.text.isEmpty)
                        ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xFF9FA8DA),
                      ),
                      child: Center(
                          child: Text(
                            "Yükle",
                            style: TextStyle(color: Colors.white),
                          )),
                    )
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigoAccent,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: ()async{
                        print("date: ${dateTime.toString()}");
                        try {
                          await LectureService().createLecture(
                              picUrl, Timestamp.fromDate(dateTime), title.text,
                              statement.text, requirements.text,lectureLink.text,int.parse(lectureMinutes.text));
                          showSnackBarText("Yükleme başarılı...");

                        }catch(e){
                          showSnackBarText("Ders yüklenemedi...");
                        }Navigator.of(context).pop();
                      },
                      child: Text("Yükle"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: MediaQuery.of(context).size.width * 0.4,
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.rectangle,
                    image: !(picUrl=="")
                        ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(picUrl),
                    )
                        : null,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: ElevatedButton(
                    onPressed: () async{
                      String newPicUrl= await LectureService().takeNewImage(ImageSource.camera);
                      if (newPicUrl!=""){
                        setState(() {
                          picUrl=newPicUrl;
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt),
                        Text("Kameradan Yükle"),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: ElevatedButton(
                    onPressed: () async{
                      String newPicUrl = await LectureService().takeNewImage(ImageSource.gallery);
                      if (newPicUrl!=""){
                        setState(() {
                          picUrl=newPicUrl;
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image),
                        Text("Galeriden Yükle"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Date:"),
                  ElevatedButton(
                    child: Text(
                        "${dateTime.year}/${dateTime.month}/${dateTime.day}"),
                    onPressed: () async {
                      final date = await pickDate();
                      if (date == null) return;
                      final newDateTime=DateTime(
                        date.year,
                        date.month,
                        date.day,
                        dateTime.hour,
                        dateTime.minute,
                      );
                      setState(() => dateTime = newDateTime);
                    },
                  ),
                  Text("Time:"),
                  ElevatedButton(
                    child: Text("$hours:$minutes"),
                    onPressed: () async {
                      final time = await pickTime();
                      if(time==null) return;
                      final newDateTime=DateTime(
                        dateTime.year,
                        dateTime.month,
                        dateTime.day,
                        time.hour,
                        time.minute,
                      );
                      setState(()=>dateTime=newDateTime);
                    },
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*0.15,child: const Text("Ders Süresi:",maxLines: 2,)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.14,
                    child: TextField(
                      controller: lectureMinutes,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        filled: true,
                      ),
                    ),
                  ),
                  Text("dk"),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ders Başlığı",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: ColorPalette().blue),
                ),
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Text(
                    "Ders Linki",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: ColorPalette().blue),
                  ),
                ),
                TextField(
                  controller: lectureLink,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 8),
                  child: Text(
                    "Gereksinimler",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorPalette().blue),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: TextField(
                    controller: requirements,
                    maxLines: 5,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 8),
                  child: Text(
                    "Ders İçeriği",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorPalette().blue),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
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
  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }



  Future<DateTime?> pickDate() => showDatePicker(
    context: context,
    initialDate: dateTime,
    firstDate: DateTime(2021),
    lastDate: DateTime(2050),
  );

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
}
