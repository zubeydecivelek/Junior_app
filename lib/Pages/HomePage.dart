import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Models/LectureModel.dart';
import 'package:juniorapp/Models/VideoItemModel.dart';
import 'package:juniorapp/Pages/VideoPlayerPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:juniorapp/Services/lectureService.dart';
import 'package:intl/intl.dart';

import '../Services/videoService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 1;
  List<LectureModel> lectureModels = [];
  List<LectureModel> todayLecture = [];
  List<LectureModel> tomorrowLecture = [];

  NumberFormat formatter = NumberFormat("00");

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
                    onPressed: () {},
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
                    return PageView.builder(
                      controller: PageController(viewportFraction: 0.7),
                      onPageChanged: (int index) =>
                          setState(() => _index = index),
                      itemCount: videoList.length,
                      scrollDirection: Axis.horizontal,
                      physics: const PageScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Transform.scale(
                          scale: index == _index ? 1 : 0.9,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => VideoPlayerPage(
                                      video: videoList[index])));
                            },
                            child: Card(
                              child: Stack(
                                children: [
                                  Image.network(videoList[index].photoLink,
                                      fit: BoxFit.cover),
                                  Positioned(
                                      left: (width - 30) / 3.3,
                                      top: 60,
                                      child: Icon(
                                        Icons.play_circle_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
              ),
            ),

            ///TODO canlı diye bir row daha olmalı
            ///ama o firebaseden çekerken yapılır

            Padding(
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
                  Text(
                    "Tümünü Gör",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette().blue),
                  )
                ],
              ),
            ),

            Container(
              height: height*0.45,
              //width: width*0.6,
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("lectures").snapshots(),
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
                    for (int i = 0; i < query.length; i++) {
                      DocumentSnapshot lectureDoc = query[i];
                      LectureModel lectureModel =
                          LectureModel.fromSnapshot(lectureDoc);
                      lectureModels.add(lectureModel);
                      int result = controlDate(lectureModel.time.toDate());
                      if (result == 0) {
                        todayLecture.add(lectureModel);
                      } else if (result == 1) {
                        tomorrowLecture.add(lectureModel);
                      }
                    }

                    lectureModels.sort((a, b) => a.time.compareTo(b.time));
                    todayLecture.sort((a, b) => a.time.compareTo(b.time));
                    tomorrowLecture.sort((a, b) => a.time.compareTo(b.time));
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
                                    height:height*0.2,
                                    //width: width*0.6,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(todayLecture[index].imageLink),
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [Icon(Icons.access_time,size: 25,),
                                        Padding(
                                          padding: const EdgeInsets.only(left:8.0),
                                          child: Text(formatter.format(todayLecture[index].time.toDate().hour)+ ":"+ formatter.format(todayLecture[index].time.toDate().minute)  ,style: TextStyle(color: Colors.black,fontSize: 18),),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:10.0),
                                    child: Text(todayLecture[index].title,
                                      style: TextStyle(
                                          fontSize:18 ,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5,8,0,10),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: width*0.08,
                                          width: width*0.08,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(todayLecture[index].publishedByNameAndPP["ppLink"]!)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(todayLecture[index].publishedByNameAndPP["Name"]!, style: TextStyle(fontSize: 17),),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorPalette().blue,
                                        shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      onPressed: () {


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

            Padding(
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
                  Text(
                    "Tümünü Gör",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorPalette().blue),
                  )
                ],
              ),
            ),

            Container(
              height: height*0.45,
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
                              height:height*0.2,
                              //width: width*0.6,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(tomorrowLecture[index].imageLink),
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [Icon(Icons.access_time,size: 25,),
                                  Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: Text(formatter.format(tomorrowLecture[index].time.toDate().hour)+ ":"+ formatter.format(tomorrowLecture[index].time.toDate().minute)  ,style: TextStyle(color: Colors.black,fontSize: 18),),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:10.0),
                              child: Text(tomorrowLecture[index].title,
                                style: TextStyle(
                                    fontSize:18 ,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5,8,0,10),
                              child: Row(
                                children: [
                                  Container(
                                    height: width*0.08,
                                    width: width*0.08,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(tomorrowLecture[index].publishedByNameAndPP["ppLink"]!)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(tomorrowLecture[index].publishedByNameAndPP["Name"]!, style: TextStyle(fontSize: 17),),
                                  ),
                                ],
                              ),
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorPalette().blue,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(30.0),
                                  ),
                                ),
                                onPressed: () {


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
                child: Text(
                  "Tüm Dersleri Gör",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: ColorPalette().blue),
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
}
