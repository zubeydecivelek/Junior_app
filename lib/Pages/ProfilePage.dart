import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Pages/ShareOpions.dart';
import 'package:juniorapp/Pages/UserModelInfo.dart';
import 'package:juniorapp/Services/authService.dart';
import 'package:juniorapp/Services/blogService.dart';
import 'package:juniorapp/Models/UserModel.dart';
import 'package:juniorapp/Pages/pricingPage.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();

// final UserModel user;
// ProfilePage({required this.user});
// @override
// State<ProfilePage> createState() => _ProfilePageState(user);

}

class _ProfilePageState extends State<ProfilePage> {

  // UserModel user;
  // _ProfilePageState(this.user);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<IconText> rows = [];

    rows.add(IconText(Icon(Icons.person_outline_rounded,color: ColorPalette().blue,), "Üyelik Bilgilerim"));
    rows.add(IconText(Icon(Icons.diamond_outlined,color: ColorPalette().blue), "Abone Ol"));
    rows.add(IconText(Icon(Icons.flag_outlined,color: ColorPalette().blue),"Sıkça Sorulan Sorular"));
    rows.add(IconText(Icon(Icons.mail_outline,color: ColorPalette().blue),"Görüşlerini Bizimle Paylaş"));
    rows.add(IconText(Icon(Icons.star_border_outlined,color: ColorPalette().blue),"Bizi Değerlendir"));
    rows.add(IconText(Icon(Icons.ios_share,color: ColorPalette().blue),"Juniorapp'i Paylaş!"));
    rows.add(IconText(Icon(Icons.exit_to_app_outlined,color: ColorPalette().blue),"Çıkış Yap"));


    return Scaffold(
      backgroundColor: ColorPalette().white,

      //TODO navigation bar

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(width/6),
        child: AppBar(
          elevation: 0,
          backgroundColor: ColorPalette().white,
          leadingWidth: width,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(padding: EdgeInsets.only(left: 15,), child: Text("Profilim", style: TextStyle(color: ColorPalette().blue,fontWeight: FontWeight.bold, fontSize: 30),),),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView( ///TODO not scrolling fix this
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: FutureBuilder(
          future: AuthService().getMe(),
          builder: ((context,AsyncSnapshot snap) {
            if (!snap.hasData) {
              return Center(child: Text("Loading...",
                style: TextStyle(color: Colors.black26, fontSize: 25),));
            }
            else {
              UserModel user = snap.data;
              return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 45.0),
                      child: Row(
                        children: [
                          CircleAvatar(backgroundColor: ColorPalette().blue,radius: width/10,),
                          Padding(
                            padding:EdgeInsets.only(left: 15.0),
                            child: Column(
                              children: [
                                Container(width: width/2,child:Text(user.name + " " + user.surname, style: TextStyle(color: ColorPalette().blue, fontWeight: FontWeight.bold, fontSize: 20),),),
                                Container(width: width/2,child: Text(user.phoneNumber,textAlign: TextAlign.start,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: ColorPalette().grey),)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(thickness: 1,),
                    ListView.separated( //or wrap with container instead of using 2 dividers around this
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index){

                          return Container(

                            child: InkWell(
                              onTap: (){InkwellFunctions(index,user);},
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 5, 13, 5),
                                    child: rows[index].icon,
                                  ),
                                  Text(rows[index].text,style: TextStyle(color: ColorPalette().blue),)
                                ],
                              ),
                            ),
                          );
                        }, separatorBuilder: (BuildContext context, int index) => Divider(thickness: 1,),
                        itemCount: 7),
                    Divider(thickness: 1,),

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(icon: Icon(Icons.add_box_outlined,), onPressed: () {
                            //TODO avantaj ekle
                          },),
                          IconButton(icon: Icon(Icons.video_call_outlined), onPressed: () {
                            //TODO ders videosu ekle
                          },),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          })
        ),
      ),
    );
  }

  void InkwellFunctions(int index,UserModel user) {

    switch (index) {
      case 0: {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserModelInfo(user)));
      }break;
      case 1: {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PricingPage(true)));

      }break;
      case 2: {
        BlogService().launchURL("senyor.app", "sss/");
      }break;
      case 3: {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ShareOpions()));
      }break;
      case 4: {
        print("bizi değerlendir");
      }break;
      case 5:{
        print("paylaş");
      }break;
      case 6:{
        print("çıkış");
        ExitPopUp();

      }
    }


  }

  ExitPopUp(){
    return showDialog(context: context, builder: (context)=>AlertDialog(
      title: Text(
        "Juniorapp",
        style: TextStyle(fontSize: 20, color: ColorPalette().blue),
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width * 0.6,
        child: const Text("Hesabından çıkış yapmak istediğine emin misin?",maxLines: 5,),
      ),
      actionsPadding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.3,right: MediaQuery.of(context).size.width * 0.05,bottom:MediaQuery.of(context).size.height * 0.01, ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              "İptal",
              style: TextStyle(
                fontSize: 18,
                color: ColorPalette().grey,
                fontWeight: FontWeight.bold,
              ),
            )),
        InkWell(
          onTap: (){
            AuthService().signOut(context);
          },
            child: Text(
              "Evet",
              style: TextStyle(
                fontSize: 18,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            )
        )
      ],
    ));
  }
  


}


class IconText{
  Icon icon;
  String text;

  IconText(this.icon, this.text);
}