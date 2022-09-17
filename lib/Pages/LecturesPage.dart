import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Models/LectureModel.dart';
import 'package:juniorapp/Pages/detailsLecturePage.dart';

//TODO FİLTRELEMEYİ SADECE GÜNE GÖRE DEGİL AYNI ZAMANDA AY VE YILA GÖRE DE DÜZENLE.
//TODO objelerin timestampleri yanlış gösteriyor??? (14.35 i  11.35 gostermesi gibi.)

class LecturesPage extends StatefulWidget {
  LecturesPage({required this.lectureList});
  List<LectureModel> lectureList;

  @override
  State<LecturesPage> createState() => _LecturesPageState();
}
class _LecturesPageState extends State<LecturesPage> {
 List<LectureModel> monday= [];
 List<LectureModel> tuesday = [];
 List<LectureModel> wednesday = [];
 List<LectureModel> thursday = [];
 List<LectureModel> friday = [];
 List<LectureModel> saturday = [];
 List<LectureModel> sunday = [];
 List<LectureModel> selectedDay = [];
 String dayTitle="";
 int today=0;
 int tomorrow=0;
  @override
  void initState() {
    dayClassification(widget.lectureList);
    today=DateTime.now().weekday;
    tomorrow=DateTime.now().add(Duration(days: 1)).weekday;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios,color: ColorPalette().blue,),
          onTap: (){},
        ),
        title: Text("Tüm Dersler",style: TextStyle(color: ColorPalette().blue,),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
       physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 7,
                itemBuilder: ((context, index) {
                 daySelection(index);
                 dayTitleSelection(index);
                 print("buraya geld..selected day:$selectedDay,$index");
                  return Padding(
                    padding: (dayTitle=="") ? EdgeInsets.all(0) : EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (dayTitle=="") ? SizedBox(height: 0,width: 0,): Text(dayTitle,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.black87),),
                        Container(
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: selectedDay.length,
                              itemBuilder: ((context,index){
                                print("print title:${selectedDay[index].title}");
                                return (selectedDay[index].time.toDate().weekday<today)  ? Container() : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: MediaQuery.of(context).size.height*0.12,
                                        width: MediaQuery.of(context).size.width*0.4,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10), 
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(selectedDay[index].imageLink),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.watch_later_outlined),
                                                Text(" ${selectedDay[index].time.toDate().hour}:${selectedDay[index].time.toDate().minute}",style: TextStyle(fontWeight: FontWeight.bold),),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Text(selectedDay[index].title,style: TextStyle(fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  height: 25, width: 25,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          selectedDay[index].imageLink),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 4.0),
                                                  child: Text("publishedbyName",style: TextStyle(fontSize: 12),),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                          })),
                        ),
                      ],
                    ),
                  );
                }),


            ),
          ],
        ),
      ),
    );
  }
  void dayClassification(List<LectureModel> lectureList){
    for(LectureModel lectureObj in lectureList){
      print("lectureobjenin weekday degeri:${lectureObj.time.toDate().weekday}");
      print("today..$today and tomorrow..$tomorrow");
      if(
      (lectureObj.time.toDate().year==DateTime.now().year) &&
          ((lectureObj.time.toDate().month==DateTime.now().month) || ((lectureObj.time.toDate().month>=DateTime.now().month) && (lectureObj.time.toDate().day<=3))) &&
          ((lectureObj.time.toDate().day==DateTime.now().day) || ((lectureObj.time.toDate().day>=DateTime.now().day) &&
              (lectureObj.time.toDate().day<=DateTime.now().add(Duration(days: 2)).day))))
      {
        switch (lectureObj.time.toDate().weekday) {
          case 1:
            monday.add(lectureObj);
            break;
          case 2:
            tuesday.add(lectureObj);
            break;
          case 3:
            wednesday.add(lectureObj);
            break;
          case 4:
            thursday.add(lectureObj);
            break;
          case 5:
            friday.add(lectureObj);
            break;
          case 6:
            saturday.add(lectureObj);
            break;
          case 7:
            sunday.add(lectureObj);
            break;
        }
      }
    }

  }
  void daySelection(int index){
    switch(index){
      case 0: selectedDay=monday; break;
      case 1: selectedDay=tuesday; break;
      case 2: selectedDay=wednesday; break;
      case 3: selectedDay=thursday; break;
      case 4: selectedDay=friday; break;
      case 5: selectedDay=saturday; break;
      case 6: selectedDay=sunday; break;
    }
  }
  void dayTitleSelection(int index){
    if(index>today){
      switch(index){
        case 0: dayTitle="Pazartesi"; break;
        case 1:dayTitle="Salı"; break;
        case 2: dayTitle="Çarşamba"; break;
        case 3: dayTitle="Perşembe"; break;
        case 4: dayTitle="Cuma"; break;
        case 5: dayTitle="Cumartesi"; break;
        case 6: dayTitle="Pazar"; break;
      }
    }
    else if((index+1)<today){
        dayTitle="";
    }
   else if((index+1)>today && (index+1)==tomorrow){
     dayTitle="Yarın";
    }

   else if((index+1)==today){
     dayTitle="Bugün";
     print("BURAYA BAKtoday..$today and tomorrow..$tomorrow");

    }
  }

}
