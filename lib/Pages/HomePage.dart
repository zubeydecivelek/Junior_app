import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Models/VideoItemModel.dart';
import 'package:juniorapp/Pages/VideoPlayerPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 1;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> photos = [];
    photos.add("https://firebasestorage.googleapis.com/v0/b/juniorapp-99648.appspot.com/o/videoPP%2Fbilgi.jpeg?alt=media&token=73c36225-d836-46e8-ba1d-8a47841eb28c");
    photos.add("https://firebasestorage.googleapis.com/v0/b/juniorapp-99648.appspot.com/o/videoPP%2Fmandala.jpeg?alt=media&token=583b345e-b985-46e7-86e4-47ac41e30dc3");
    photos.add("https://firebasestorage.googleapis.com/v0/b/juniorapp-99648.appspot.com/o/videoPP%2Fe-nab%C4%B1z.jpeg?alt=media&token=ba9a3d7a-cbfb-4828-8124-f7690ae9ec5b");

    VideoItemModel video = VideoItemModel(headline: "BİLGİ YARIŞMASI", owner: "JUNIORAPP", photoLink: "https://firebasestorage.googleapis.com/v0/b/juniorapp-99648.appspot.com/o/videoPP%2Fbilgi.jpeg?alt=media&token=73c36225-d836-46e8-ba1d-8a47841eb28c", videoLink: "https://www.youtube.com/watch?v=4_XmfYsCAmA");

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
                child: IconButton(onPressed: (){

                }, icon: Icon(Icons.calendar_today_outlined,color: ColorPalette().blue,)),
              ),
            ],
          )
        ],
        backgroundColor: ColorPalette().white,
        leadingWidth: width,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(width: width, height: width/10,child: Padding(padding: EdgeInsets.only(left: 15,), child: Text("Juniorapp", style: TextStyle(color: ColorPalette().blue,fontWeight: FontWeight.bold, fontSize: width/18),),)),
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
              width: width/1.1,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.7),
                onPageChanged: (int index) => setState(() => _index = index),
                itemCount: 3,
                scrollDirection: Axis.horizontal,
                physics: const PageScrollPhysics(),
                itemBuilder: (context, index) {
                  return
                    Transform.scale(
                      scale: index == _index ? 1 : 0.9,
                      child: Card(
                        child: Stack(
                          children: [
                            Image.network(photos[index]),
                            Positioned(left:(width-30)/3.3,top:60,child: Icon(Icons.play_circle_rounded, color: Colors.white,size: 30,))
                          ],
                        ),),
                    )
                  ;

                },
              ),
            ),


            ///TODO canlı diye bir row daha olmalı
            ///ama o firebaseden çekerken yapılır

            Padding(padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text("Bugün", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: ColorPalette().grey),),
                  Text("Tümünü Gör", style: TextStyle(decoration: TextDecoration.underline,fontSize: 15,fontWeight: FontWeight.bold,color: ColorPalette().blue),)
                ],
              ),
            ),



            Center(child: Container(width: width-50,height: 150,color: Colors.blue,)),



            Padding(padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text("Yarın", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: ColorPalette().grey),),
                  Text("Tümünü Gör", style: TextStyle(decoration: TextDecoration.underline,fontSize: 15,fontWeight: FontWeight.bold,color: ColorPalette().blue),)
                ],
              ),
            ),



            Center(child: Container(width: width-50,height: 150,color: Colors.blue,)),



            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Center(child: Text("Tüm Dersleri Gör", style: TextStyle(decoration: TextDecoration.underline,fontSize: 15,fontWeight: FontWeight.bold,color: ColorPalette().blue),),),
            )
          ],
        ),
      ),
    );
  }
}