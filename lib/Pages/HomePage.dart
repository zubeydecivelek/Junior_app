import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Models/LectureModel.dart';
import 'package:juniorapp/Models/VideoItemModel.dart';
import 'package:juniorapp/Pages/VideoPlayerPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juniorapp/Services/lectureService.dart';
import 'package:intl/intl.dart';

import '../Services/videoService.dart';
import 'LecturesPage.dart';
import 'detailsLecturePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with SingleTickerProviderStateMixin {

  late final Ticker _ticker;
  int _index = 1;
  List<LectureModel> lectureModels = [];
  List<LectureModel> todayLecture = [];
  List<LectureModel> tomorrowLecture = [];
  List<LectureModel> nowLecture = [];
  bool isToday=true;

  NumberFormat formatter = NumberFormat("00");

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      // 4. update state
      //print("canlı listee: $nowLecture");
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                    onPressed: () async {
                      await controlLecturesTime();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LecturesPage(
                            lectureList: lectureModels,)));
                    },
                    icon: Icon(
                      Icons.calendar_today_outlined,
                      color: ColorPalette().blue,
                    )),
              ),
            ],
          )
        ],
        backgroundColor: ColorPalette().white,
        leadingWidth: width,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
                width: width,
                height: width / 10,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 15,
                  ),
                  child: Text(
                    "Juniorapp",
                    style: TextStyle(
                        color: ColorPalette().blue,
                        fontWeight: FontWeight.bold,
                        fontSize: width / 18),
                  ),
                )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          children: [
            // InkWell(
            //   child: Container(
            //     height: 150,
            //     width: width/1.6,
            //     child: Card(
            //       elevation: 20,
            //       child: Stack(
            //         children: [
            //           Image.network(video.photoLink,fit: BoxFit.cover,),
            //           Center(child: Icon(Icons.play_circle_rounded,color: Colors.white,size: 40,),)
            //         ],
            //       ),
            //     ),
            //   ),
            //   onTap: (){
            //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPlayerPage(video: video)));
            //   }
            //
            //   ,
            // )
            // ,

            //https://pub.dev/packages/carousel_slider
            //https://stackoverflow.com/questions/51607440/horizontally-scrollable-cards-with-snap-effect-in-flutter

            Container(
              height: 150,
              width: width / 1.1,
              child: FutureBuilder(
                future: VideoService().getVideos(),
                builder: ((context, AsyncSnapshot snap) {
                  if (!snap.hasData) {
                    return Center(
                        child: Text(
                      "Loading...",
                      style: TextStyle(color: Colors.black26, fontSize: 25),
                    ));
                  } else {
                    List<VideoItemModel> videoList = snap.data;
                    return Swiper(
                      itemCount: videoList.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Image.network(videoList[index].photoLink),
                            Positioned(
                                top: 75 - (width / 26),
                                right: width / 3.3,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerPage(
                                                    video: videoList[index])));
                                  },
                                  child: DecoratedIcon(
                                    Icons.play_circle,
                                    color: Colors.white,
                                    size: width / 13,
                                    shadows: [
                                      BoxShadow(
                                          color: ColorPalette().grey,
                                          blurRadius: 20,
                                          spreadRadius: 0,
                                          offset: Offset(0, 0)),
                                    ],
                                  ),
                                ))
                          ],
                        );
                      },
                      viewportFraction: 0.75,
                      scale: 0.9,
                    );
                  }
                }),
              ),
            ),

            ///TODO canlı diye bir row daha olmalı
            ///ama o firebaseden çekerken yapılır
            if(nowLecture.isNotEmpty)Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Canlı",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette().grey),
                  ),
                ],
              ),
            ),

            if(nowLecture.isNotEmpty)Container(
              height: height * 0.5,
              child: PageView.builder(
                  controller: PageController(viewportFraction: 0.7),
                  itemCount: nowLecture.length,
                  scrollDirection: Axis.horizontal,
                  physics: const PageScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Card(
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: height * 0.2,
                              //width: width*0.6,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        nowLecture[index].imageLink),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(Icons.stream,color: Colors.red,),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                nowLecture[index].title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 8, 0, 10),
                              child: Row(
                                children: [
                                  Container(
                                    height: width * 0.08,
                                    width: width * 0.08,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              nowLecture[index]
                                                  .publishedByNameAndPP[
                                              "ppLink"]!)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      nowLecture[index]
                                          .publishedByNameAndPP["Name"]!,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorPalette().blue,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(30.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailsLecturePage(
                                        lectureObj: nowLecture[index],
                                      )));
                                },
                                child: Text("DETAYLARI GÖR"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),

            if(todayLecture.isNotEmpty)Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Bugün",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette().grey),
                  ),
                  InkWell(
                    onTap: () async {
                      await controlLecturesTime();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LecturesPage(
                                lectureList: lectureModels,
                              )));
                    },
                    child: Text(
                      "Tümünü Gör",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette().blue),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(
               height:isToday? height * 0.5:height*0.05,
              //width: width*0.6,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("lectures")
                    .snapshots(),
                builder: ((BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: Text(
                      "Loading...",
                      style: TextStyle(color: Colors.black26, fontSize: 25),
                    ));
                  } else {
                    //QuerySnapshot querySnapshot = snapshot.data.docs;
                    List<QueryDocumentSnapshot> query = snapshot.data!.docs;

                    lectureModels = [];
                    todayLecture = [];
                    tomorrowLecture = [];
                    nowLecture = [];
                    for (int i = 0; i < query.length; i++) {
                      DocumentSnapshot lectureDoc = query[i];
                      LectureModel lectureModel =
                          LectureModel.fromSnapshot(lectureDoc);

                      int result = controlDate(lectureModel.time.toDate());
                      bool isLectureLive = isLive(lectureModel);
                      if (result == 0) {
                        todayLecture.add(lectureModel);
                      } else if (result == 1) {
                        tomorrowLecture.add(lectureModel);
                      }if(isLectureLive){
                        lectureModel.isStreaming=true;
                        nowLecture.add(lectureModel);
                      }
                      lectureModels.add(lectureModel);
                    }
                    controlLecturesTime();
                    lectureModels.sort((a, b) => a.time.compareTo(b.time));
                    todayLecture.sort((a, b) => a.time.compareTo(b.time));
                    tomorrowLecture.sort((a, b) => a.time.compareTo(b.time));

                    if (todayLecture.isEmpty){
                        isToday=false;
                    }
                    return PageView.builder(
                        controller: PageController(viewportFraction: 0.7),
                        itemCount: todayLecture.length,
                        scrollDirection: Axis.horizontal,
                        physics: const PageScrollPhysics(),
                        itemBuilder: (context, index) {

                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Card(
                              elevation: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height * 0.2,
                                    //width: width*0.6,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          todayLecture[index].imageLink),
                                    )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 25,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            formatter.format(todayLecture[index]
                                                    .time
                                                    .toDate()
                                                    .hour) +
                                                ":" +
                                                formatter.format(
                                                    todayLecture[index]
                                                        .time
                                                        .toDate()
                                                        .minute),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      todayLecture[index].title,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 8, 0, 10),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: width * 0.08,
                                          width: width * 0.08,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(todayLecture[
                                                            index]
                                                        .publishedByNameAndPP[
                                                    "ppLink"]!)),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            todayLecture[index]
                                                .publishedByNameAndPP["Name"]!,
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorPalette().blue,
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsLecturePage(
                                                      lectureObj:
                                                          todayLecture[index],
                                                    )));

                                        },
                                      child: Text("DETAYLARI GÖR"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }),
              ),
            ),

            if(tomorrowLecture.isNotEmpty)Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Yarın",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette().grey),
                  ),
                  InkWell(
                    onTap: () async{
                      await controlLecturesTime();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LecturesPage(
                                lectureList: lectureModels,
                              )));
                    },
                    child: Text(
                      "Tümünü Gör",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: ColorPalette().blue),
                    ),
                  )
                ],
              ),
            ),

            if(tomorrowLecture.isNotEmpty)Container(
              height: height * 0.5,
              child: PageView.builder(
                  controller: PageController(viewportFraction: 0.7),
                  itemCount: tomorrowLecture.length,
                  scrollDirection: Axis.horizontal,
                  physics: const PageScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Card(
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: height * 0.2,
                              //width: width*0.6,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    tomorrowLecture[index].imageLink),
                              )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      formatter.format(tomorrowLecture[index]
                                              .time
                                              .toDate()
                                              .hour) +
                                          ":" +
                                          formatter.format(
                                              tomorrowLecture[index]
                                                  .time
                                                  .toDate()
                                                  .minute),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                tomorrowLecture[index].title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 8, 0, 10),
                              child: Row(
                                children: [
                                  Container(
                                    height: width * 0.08,
                                    width: width * 0.08,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              tomorrowLecture[index]
                                                      .publishedByNameAndPP[
                                                  "ppLink"]!)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      tomorrowLecture[index]
                                          .publishedByNameAndPP["Name"]!,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorPalette().blue,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailsLecturePage(
                                            lectureObj: tomorrowLecture[index],
                                          )));
                                },
                                child: Text("DETAYLARI GÖR"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),

            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Center(
                child: InkWell(
                  onTap: ()async {
                    await controlLecturesTime();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LecturesPage(
                              lectureList: lectureModels,
                            )));
                  },
                  child: Text(
                    "Tüm Dersleri Gör",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette().blue),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// today = 0, tomorrow = 1
  int controlDate(DateTime date) {
    DateTime today = DateTime.now();
    DateTime tomorrow = today.add(Duration(days: 1));
    if (date.year == today.year && date.month == today.month && date.day == today.day&& today.compareTo(date)==-1) {
      return 0;
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 1;
    }
    return -1;
  }

  bool isLive(LectureModel lecture){
    DateTime now = DateTime.now();
    DateTime startLecture = lecture.time.toDate();
    DateTime endLecture = startLecture.add(Duration(minutes: lecture.lectureMinute));
    if((startLecture.compareTo(now)==-1||startLecture.compareTo(now)==0)&& (now.compareTo(endLecture)==-1||now.compareTo(endLecture)==0)){
      return true;
    }
    return false;
  }

  Future<void> controlLecturesTime()async{
    DateTime dtNow= DateTime.now();
    for (LectureModel lectureModel in lectureModels){
      DateTime start = lectureModel.time.toDate();
      DateTime end = start.add(Duration(minutes: lectureModel.lectureMinute));
      if(end.compareTo(dtNow)==-1){
        //lectureModels.remove(lectureModel);
        await LectureService().deleteLecture(lectureModel);
      }
    }
  }
}
