import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Pages/HomePage.dart';
import 'package:juniorapp/Pages/paymentPage.dart';
import 'package:juniorapp/Services/authService.dart';

class PricingPage extends StatefulWidget {
  bool isRegistered;

  PricingPage(this.isRegistered, {Key? key}) : super(key: key);

  @override
  State<PricingPage> createState() => _PricingPageState();
}

class _PricingPageState extends State<PricingPage> {
  bool freeSelected = false;
  bool dailySelected = false;
  bool weeklySelected = false;
  bool monthlySelected = false;

  double screenHeight = 0;
  double screenWidth = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
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
                    child: !(freeSelected ||
                            dailySelected ||
                            weeklySelected ||
                            monthlySelected)
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Color(0xFF9FA8DA),
                            ),
                            child: Center(
                                child: Text(
                              "Devam Et",
                              style: TextStyle(color: Colors.white),
                            )),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.indigoAccent,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () {
                              int send = -1;
                              if (dailySelected) {
                                send=1;
                                //AuthService().updateSubscription(1);
                              } else if (weeklySelected) {
                                send=2;
                                //AuthService().updateSubscription(2);
                              } else if (monthlySelected) {
                                send=3;
                                //AuthService().updateSubscription(3);
                              }
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PaymentPage(send),
                                ),
                              );
                            },
                            child: Text("Devam Et"),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorPalette().blue,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Paket Seçimi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: ColorPalette().blue,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!widget.isRegistered)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Ücretsiz",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: ColorPalette().blue,
                            ),
                          ),
                          Text("3 kez ücretsiz canlı derse katılım"),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.circle,
                              size: 10,
                              color: ColorPalette().blue,
                            ),
                          ),
                          Text("Junior Blog yazılarına erişim"),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              freeSelected = true;
                              dailySelected = false;
                              weeklySelected = false;
                              monthlySelected = false;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: freeSelected
                                  ? Border.all(
                                      color: ColorPalette().blue, width: 2)
                                  : null,
                              color: Colors.grey[300],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Ücretsiz \nPaket",
                                  style: TextStyle(color: ColorPalette().blue),
                                ),
                                Text(
                                  "Ücretsiz",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: ColorPalette().grey),
                                ),
                                SizedBox(
                                  height: 20,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          freeSelected = true;
                                          dailySelected = false;
                                          weeklySelected = false;
                                          monthlySelected = false;
                                        });
                                      },
                                      child: Text("SEÇ"),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  ColorPalette().grey),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                          )))),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            /// ÜCRETSİZ
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //width: MediaQuery.of(context).size.width*0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Abonelikler",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: ColorPalette().blue,
                          ),
                        ),
                        Text("Tüm canlı derslere katılım"),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: ColorPalette().blue,
                          ),
                        ),
                        Text("Junior BLog yazılarına erişim"),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: ColorPalette().blue,
                          ),
                        ),
                        Text(
                            "Junior Avantaj kapsamında yer alan \navantajlardan yararlanma "),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: ColorPalette().blue,
                          ),
                        ),
                        Text("İLK AY ÜCRETSİZ!"),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            dailySelected = true;
                            freeSelected = false;
                            weeklySelected = false;
                            monthlySelected = false;
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: dailySelected
                                ? Border.all(
                                    color: ColorPalette().blue, width: 2)
                                : null,
                            color: Colors.grey[300],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "1 Günlük \nPaket",
                                style: TextStyle(color: ColorPalette().blue),
                              ),
                              Text(
                                "9.99₺",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette().blue),
                              ),
                              SizedBox(
                                height: 20,
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        dailySelected = true;
                                        freeSelected = false;
                                        weeklySelected = false;
                                        monthlySelected = false;
                                      });
                                    },
                                    child: Text("SEÇ"),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ColorPalette().grey),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            weeklySelected = true;
                            dailySelected = false;
                            freeSelected = false;
                            monthlySelected = false;
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: weeklySelected
                                ? Border.all(
                                    color: ColorPalette().blue, width: 2)
                                : null,
                            color: Colors.grey[300],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Haftalık\nPaket",
                                style: TextStyle(color: ColorPalette().blue),
                              ),
                              Text(
                                "49.99₺",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette().blue),
                              ),
                              SizedBox(
                                height: 20,
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        weeklySelected = true;
                                        dailySelected = false;
                                        freeSelected = false;
                                        monthlySelected = false;
                                      });
                                    },
                                    child: Text("SEÇ"),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ColorPalette().grey),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            weeklySelected = false;
                            dailySelected = false;
                            freeSelected = false;
                            monthlySelected = true;
                          });
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: monthlySelected
                                ? Border.all(
                                    color: ColorPalette().blue, width: 2)
                                : null,
                            color: Colors.grey[300],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Aylık \nPaket",
                                style: TextStyle(color: ColorPalette().blue),
                              ),
                              Text(
                                "99.99₺",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette().blue),
                              ),
                              SizedBox(
                                height: 20,
                                child: ElevatedButton(
                                    onPressed: () {
                                      weeklySelected = false;
                                      dailySelected = false;
                                      freeSelected = false;
                                      monthlySelected = true;
                                    },
                                    child: Text("SEÇ"),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ColorPalette().grey),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        )))),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
