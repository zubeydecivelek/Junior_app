import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Services/authService.dart';

class ShareOpions extends StatefulWidget {
  const ShareOpions({Key? key}) : super(key: key);

  @override
  State<ShareOpions> createState() => _ShareOpionsState();
}

class _ShareOpionsState extends State<ShareOpions> {

  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: BottomAppBar(
          color: Colors.white,
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
            child: Container(
              height: height * 0.1,
              color: Colors.white70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: height * 0.06,
                      width: width * 0.8,
                      child: (!_controller.text.isEmpty)
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigoAccent,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: ()  {
                          print("buuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu: ${_controller.text.trim()}");
                          AuthService().sendOpinion(_controller.text.trim());
                        },
                        child: Text("Gönder"),
                      ):Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xFF9FA8DA),
                        ),
                        child: Center(
                            child: Text(
                              "Gönder",
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorPalette().white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: ColorPalette().blue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text("Görüşlerini Paylaş", style: TextStyle(color: ColorPalette().blue,fontWeight: FontWeight.bold, fontSize: 25),),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Container(
                child: Text("Selam Junior, kendimizi geliştirmemiz için bizimle görüşlerini paylaşabilirsin"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: TextField(
                  obscureText: false,
                  controller: _controller,
                  autocorrect: false,
                  keyboardType: TextInputType.multiline,
                  minLines: 7,
                  maxLines: 7,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorPalette().grey)
                    ),
                    hintText: "Buraya yazabilirsin",
                    hintStyle: TextStyle(fontSize: 14),
                    filled: false,
                    fillColor: Color(0xFFF2F2F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
