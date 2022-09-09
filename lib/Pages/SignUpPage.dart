import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Pages/pricingPage.dart';
import 'package:juniorapp/Services/authService.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  double screenHeight = 0;
  double screenWidth = 0;
  bool ischecked = false;
  Color buttonColor = Colors.grey;

  var nameKey = TextEditingController();
  var surnameKey = TextEditingController();
  var mailKey = TextEditingController();
  var dateKey = TextEditingController();
  ///TODO scroll yap çünkü muhtemelen scrollable
  @override
  Widget build(BuildContext context) {

    GlobalKey<FormState> _myKey = GlobalKey<FormState>();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;



    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;


    return Scaffold(


      backgroundColor: ColorPalette().white,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BottomAppBar(
          color: Colors.white,
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Container(
              height: screenHeight * 0.1,
              color: Colors.white70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.8,
                      child: (!nameKey.text.isEmpty && !surnameKey.text.isEmpty && !mailKey.text.isEmpty && !dateKey.text.isEmpty && ischecked)
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigoAccent,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          AuthService().updateUserInfos(nameKey.text, surnameKey.text, mailKey.text);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PricingPage(false),
                            ),
                          );
                        },
                        child: Text("Devam Et"),
                      ):Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xFF9FA8DA),
                        ),
                        child: Center(
                            child: Text(
                              "Devam Et",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),

                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(width/6),
        child: AppBar(
          elevation: 0,
          backgroundColor: ColorPalette().white,
          leadingWidth: width,
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(padding: EdgeInsets.only(left: 15,), child: Text("Juniorapp", style: TextStyle(color: ColorPalette().blue,fontWeight: FontWeight.bold, fontSize: 22),),),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(

        physics:BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),

        scrollDirection: Axis.vertical,
        child: Flex(
            direction: Axis.horizontal,
            children:[ Expanded(
              child: Column(
                children: [
                  Container(width: width, child: Padding(padding : EdgeInsets.all(20),child: Text("Üye Ol", style: TextStyle(color: ColorPalette().grey, fontWeight: FontWeight.bold, fontSize: 20),),),),
                  Container(width: width, child: Padding(
                    padding: EdgeInsets.only(left: 20.0,bottom: 20),
                    child: Text("İsim, soyisim, e-mail adresi  ve doğum tarihi bilgilerini girerek üye ol.", style: TextStyle(color: ColorPalette().grey, fontSize: 16),),
                  ),),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 15),
                    child: TextField(
                      style: TextStyle(color: ColorPalette().grey),
                      controller: nameKey,
                      obscureText: false,
                      cursorColor: ColorPalette().blue,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorPalette().grey)
                        ),
                        border: OutlineInputBorder(
                          //borderSide: BorderSide(color: ColorPalette().grey)
                        ),
                        hintText: 'İsim',
                      ),),
                  ),Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 15),
                    child: TextField(
                      style: TextStyle(color: ColorPalette().grey),
                      controller: surnameKey,
                      obscureText: false,
                      cursorColor: ColorPalette().blue,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorPalette().grey)
                        ),
                        border: OutlineInputBorder(
                          //borderSide: BorderSide(color: ColorPalette().grey)
                        ),
                        hintText: 'Soyisim',
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 15),
                    child: TextField(
                      style: TextStyle(color: ColorPalette().grey),
                      controller: mailKey,
                      obscureText: false,
                      cursorColor: ColorPalette().blue,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorPalette().grey)
                        ),
                        border: OutlineInputBorder(
                          //borderSide: BorderSide(color: ColorPalette().grey)
                        ),
                        hintText: 'E-mail Adresi',
                      ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 15),
                    child: TextField(
                      style: TextStyle(color: ColorPalette().grey),
                      controller: dateKey,
                      obscureText: false,
                      cursorColor: ColorPalette().blue,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorPalette().grey)
                        ),
                        border: OutlineInputBorder(
                          //borderSide: BorderSide(color: ColorPalette().grey)
                        ),
                        hintText: 'Doğum Tarihi (gün/ay/yıl)',
                      ),),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: IconButton(onPressed: (){
                          setState((){
                            ischecked = ! ischecked;
                          });

                          setState((){
                            if(ischecked) {
                              buttonColor =Colors.green;}else {
                              buttonColor =Colors.grey;
                            }
                          });

                          print(ischecked);
                        }, icon: Icon(Icons.check_circle_outline_outlined, color: buttonColor,)),
                      ),
                      Container(
                        width: width-58,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Üyelik Sözleşmesi'ni ve Gizlilik Politikasını okudum, kabul ediyorum."),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text("Üyelik Sözleşmesi",style: TextStyle(
                            decoration: TextDecoration.underline, color: ColorPalette().grey
                        ),),
                      ),
                    ),
                  )
                ],
              ),
            ),]
        ),
      ),
    );
  }
}