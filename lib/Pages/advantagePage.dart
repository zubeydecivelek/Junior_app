import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Models/AdvantageItemModel.dart';
import 'package:juniorapp/Pages/seeDetailsPage.dart';
import 'package:juniorapp/Services/advantageService.dart';
class AdvantagePage extends StatefulWidget {
  const AdvantagePage({Key? key}) : super(key: key);

  @override
  State<AdvantagePage> createState() => _AdvantagePageState();
}

class _AdvantagePageState extends State<AdvantagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Avantajlar",style: TextStyle(fontWeight: FontWeight.bold,color: ColorPalette().blue),),
      ),
      body:FutureBuilder(
        future: AdvantageService().getAdvantages(),
        builder: ((context, AsyncSnapshot snap) {
          if(!snap.hasData){
            return Center(child: Text("Loading...",style: TextStyle(color: Colors.black26,fontSize: 25),));
          }
          return Container(
            height: MediaQuery.of(context).size.height*0.8,
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: snap.data.length,
                itemBuilder: ((context, index) {
                  return advantageList(snap.data[index]);
                })),
          );
        }),
      ),
    );
  }

  advantageList(AdvantageItemModel obj){
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 218, 218, 218),
                    blurRadius: 10.0, // soften the shadow
                    spreadRadius: 0.0, //extend the shadow
                    offset: Offset(
                      0.0, // Move to right 10  horizontally
                      15.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height*0.4,
                maxHeight: MediaQuery.of(context).size.height*0.55,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                      image: NetworkImage(obj.imageLink),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(obj.subtitle,style: TextStyle(color: Colors.grey),overflow: TextOverflow.ellipsis,maxLines: 2,),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8,0,8,8),
                    child: Text(obj.title,style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Center(
                    child: ElevatedButton(
                      child: Text("Detayları gör",style: TextStyle(fontWeight: FontWeight.bold),),
                      style: ElevatedButton.styleFrom(
                        shape:RoundedRectangleBorder(
                          borderRadius:  BorderRadius.circular(30.0),
                        ),
                        primary: ColorPalette().blue, // background
                        onPrimary: Colors.white70, //
                      ),
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SeeDetailsPage(obj: obj)));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
