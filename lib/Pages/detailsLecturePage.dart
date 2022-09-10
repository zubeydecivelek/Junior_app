import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Models/LectureModel.dart';
class DetailsLecturePage extends StatefulWidget {
DetailsLecturePage({required this.lectureObj});
   LectureModel lectureObj;

  @override
  State<DetailsLecturePage> createState() => _DetailsLecturePageState();
}

class _DetailsLecturePageState extends State<DetailsLecturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: InkWell(
          child: Icon(Icons.arrow_back_ios,color: ColorPalette().blue,),
          onTap: (){},
        ),
        title: Text("Ders Detayı",style: TextStyle(color: ColorPalette().blue),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.lectureObj.imageLink),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("${widget.lectureObj.time.toDate().hour}:${widget.lectureObj.time.toDate().minute}"),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("${widget.lectureObj.title}"),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 40,width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage(widget.lectureObj.publishedBy.ppLink),
                      ),
                    ),
                  ),
                ),
                Text("${widget.lectureObj.publishedBy.name} ${widget.lectureObj.publishedBy.surname}"),
              ],
            ),
            Divider(
              height: 1,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child:  Text(widget.lectureObj.statement),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
