import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Models/LectureModel.dart';
import 'package:juniorapp/Pages/detailsLecturePage.dart';
class LecturesPage extends StatefulWidget {
  LecturesPage({required this.lectureList});
  List<LectureModel> lectureList;

  @override
  State<LecturesPage> createState() => _LecturesPageState();
}
class _LecturesPageState extends State<LecturesPage> {
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
              itemCount: widget.lectureList.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),                      elevation: 6,
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.5,
                      decoration: BoxDecoration(

                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height*0.2,
                            child: Center(child: Text("GORSEL")),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight:Radius.circular(20),
                                  topLeft:Radius.circular(20) ),
                           image: DecorationImage(
                             fit: BoxFit.cover,
                             image: NetworkImage(widget.lectureList[index].imageLink),
                           ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("${widget.lectureList[index].time.toDate().hour}:${widget.lectureList[index].time.toDate().minute}",style: TextStyle(fontSize: 17),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("${widget.lectureList[index].title}",style: TextStyle(fontSize: 25),),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 35,width: 35,
                                  child: Center(child: Text("PP")),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                      image:NetworkImage(widget.lectureList[index].publishedByNameAndPP[
                                      "ppLink"]!),
                                    ),
                                  ),
                                ),
                              ),
                              Text(widget.lectureList[index].publishedByNameAndPP["Name"]!,style: TextStyle(fontSize: 15),),
                            ],
                          ),
                          Center(
                            child: ElevatedButton(
                                onPressed: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>DetailsLecturePage(lectureObj: widget.lectureList[index],)));
                                },
                                child: Text("Detayları Gör",style: TextStyle(fontWeight: FontWeight.bold),),
                              style: ElevatedButton.styleFrom(
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ),
                    ),
                  );
                }),


            ),
          ],
        ),
      ),
    );
  }
}
