import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Models/LectureModel.dart';
import 'package:juniorapp/Services/authService.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';


class DetailsLecturePage extends StatefulWidget {
  DetailsLecturePage({required this.lectureObj});
  LectureModel lectureObj;

  @override
  State<DetailsLecturePage> createState() => _DetailsLecturePageState();
}

class _DetailsLecturePageState extends State<DetailsLecturePage> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  String lectureday="day";
  int result=0;
  @override
  void initState() {
    result= controlDate(widget.lectureObj.time.toDate());
    switch(result){
      case 0:
        lectureday="Bugün";
        break;
      case 1:
        lectureday="Yarın";
        break;
      default:
        lectureday="Hata";
        break;
    }
    super.initState();

    _ticker = createTicker((elapsed) {
      // 4. update state
      isLive();
      setState(() {
      });
    });
    // 5. start ticker
    _ticker.start();
  }



  @override
  void dispose() {
    // 6. don't forget to dispose it
    _ticker.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios,color: ColorPalette().blue,),
          onTap: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text("Ders Detayı",style: TextStyle(color: ColorPalette().blue),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width*0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.lectureObj.imageLink),
                  ),
                ),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width*0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0,top: 10),
                    child: Text("${widget.lectureObj.title}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0,top: 10),
                        child: Container(
                          height: 35,width: 35,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                            image: DecorationImage(
                              image: NetworkImage(widget.lectureObj
                                  .publishedByNameAndPP[
                              "ppLink"]!),
                            ),
                          ),
                        ),
                      ),
                       Padding(
                         padding: const EdgeInsets.only(left: 8.0),
                         child: Text(widget.lectureObj.publishedByNameAndPP["Name"]!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                       ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0,top: 10),
                    child: Container(
                      child:  Text(widget.lectureObj.statement),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0,top: 10),
                    child: Text("Gereklilikler",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0,top: 10),
                    child: Container(
                      child:  Text(widget.lectureObj.requirements),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white54,
        child: SizedBox(
          height:70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$lectureday",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                  Text("${widget.lectureObj.time.toDate().hour}:${widget.lectureObj.time.toDate().minute}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                ],
              ),
              SizedBox(
                width: 180,
                child: widget.lectureObj.isStreaming ?  ElevatedButton(
                  child: Text("DERSE KATIL",style: TextStyle(fontSize: 12),),
                  onPressed: ()async{
                    bool result  = await AuthService().joinClass(context);
                    if(result){
                      await _launchInBrowser(widget.lectureObj.liveVideoLink);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: ColorPalette().blue,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                  ),
                ): Container(
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color(0xFF9FA8DA),
                  ),
                  child: Center(
                      child: Text(
                        "DERSE KATIL",
                        style: TextStyle(color: Colors.white,fontSize: 12),
                      )),
                ) ,
              ),
            ],
          ),
        ),
      ),
    );
  }
  /// today = 0, tomorrow = 1
  int controlDate(DateTime date) {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(Duration(days: 1));
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 0;
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 1;
    }
    return -1;
  }

  bool isLive(){
    DateTime now = DateTime.now();
    DateTime startLecture = widget.lectureObj.time.toDate();
    DateTime endLecture = startLecture.add(Duration(minutes: widget.lectureObj.lectureMinute));
    if((startLecture.compareTo(now)==-1||startLecture.compareTo(now)==0)&& (now.compareTo(endLecture)==-1||now.compareTo(endLecture)==0)){
      widget.lectureObj.isStreaming=true;
      return true;
    }
    return false;
  }

  Future<void> _launchInBrowser(String url) async {
    Uri uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

}
