import 'package:flutter/material.dart';
import 'package:juniorapp/Models/UserModel.dart';

import '../ColorPalette.dart';

class UserModelInfo extends StatefulWidget {
  UserModel user;

  UserModelInfo(this.user, {Key? key}) : super(key: key);


  @override
  State<UserModelInfo> createState() => _UserModelInfoState();
}

class _UserModelInfoState extends State<UserModelInfo> {
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      //TODO navigaton bar
      backgroundColor: ColorPalette().white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(width/6),
        child: AppBar(
          elevation: 0,
          backgroundColor: ColorPalette().white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined, color: ColorPalette().blue),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text("Üyelik Bilgilerim", style: TextStyle(color: ColorPalette().blue,fontWeight: FontWeight.bold, fontSize: 25),),
        ),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(25),child:
            Column(
              children: [
                Container(width: width,child: Text("İsim Soyisim", style: TextStyle(color: ColorPalette().blue,fontSize: 17),)),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(width: width,child: Text(widget.user.name+" "+widget.user.surname, style: TextStyle(color: ColorPalette().grey,fontWeight: FontWeight.bold,fontSize: 17),),),
                ),
                Divider(thickness: 0.8,),

                Container(width:width,child: Text("E-posta Adresi", style: TextStyle(color: ColorPalette().blue,fontSize: 17),)),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(width: width,child: Text(widget.user.email, style: TextStyle(color: ColorPalette().grey,fontWeight: FontWeight.bold,fontSize: 17),),),
                ),
                Divider(thickness: 0.8,),

                Container(width: width,child: Text("Telefon Numarası", style: TextStyle(color: ColorPalette().blue,fontSize: 17),),),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(width:width,child: Text(widget.user.phoneNumber, style: TextStyle(color: ColorPalette().grey,fontWeight: FontWeight.bold,fontSize: 17),)),
                ),
                Divider(thickness: 0.8,),

                Container(width:width,child: Text("Üyelik Tipi", style: TextStyle(color: ColorPalette().blue,fontSize: 17),)),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(width:width, child: Text(widget.user.subscriptionType, style: TextStyle(color: ColorPalette().grey,fontWeight: FontWeight.bold,fontSize: 17),)),
                ),
                Divider(thickness: 0.8,),
              ],
            )
            ,)
        ],
      ),
    );
  }
}
