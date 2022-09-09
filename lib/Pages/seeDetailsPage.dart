import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Models/AdvantageItemModel.dart';

class SeeDetailsPage extends StatelessWidget {
  AdvantageItemModel obj;
    SeeDetailsPage({required this.obj});

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
       centerTitle: true,
       title: Text("Avantaj Detayları",style: TextStyle(fontWeight: FontWeight.bold,color: ColorPalette().blue),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
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
                child: Text(obj.title,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(obj.statement,style: TextStyle(fontSize: 16),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
