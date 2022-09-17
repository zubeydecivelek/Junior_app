import 'package:country_codes/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:juniorapp/Pages/HomePage.dart';
import 'package:juniorapp/Pages/navigationPage.dart';
import 'package:juniorapp/Services/authService.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'SignUpPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;

  int screenState = 0;
  String otpPin = " ";

  String verID = " ";
  String uid = "";

  Color blue = Colors.indigo;

  Future<void> verifyPhone(String number) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: number,
      timeout: const Duration(seconds: 20),
      verificationCompleted: (PhoneAuthCredential credential) {
        showSnackBarText("Auth Completed!");
      },
      verificationFailed: (FirebaseAuthException e) {
        showSnackBarText("Auth Failed!");
      },
      codeSent: (String verificationId, int? resendToken) {
        showSnackBarText("OTP Sent!");
        verID = verificationId;
        setState(() {
          screenState = 1;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        showSnackBarText("Timeout!");
      },
    );
  }

  Future<void> verifyOTP() async {
    await FirebaseAuth.instance
        .signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verID,
        smsCode: otpPin,
      ),
    )
        .then((value) {
      uid = value.user!.uid;
    }).whenComplete(() async {
      if (await AuthService().checkRegistered(uid)) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const NavigationPage(),
          ),
        );
      } else {
        AuthService().register(defaultCode + phoneController.text, uid);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SignUpPage(),
          ),
        );
      }
    });
  }

  final countryPicker = FlCountryCodePicker();
  CountryCode? countryCode;
  String defaultCode = "+90";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
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
                    child: (screenState == 0 &&
                                phoneController.text.length != 10) ||
                            (screenState == 1 && otpController.text.length != 6)
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
                              if (screenState == 0) {
                                verifyPhone(defaultCode + phoneController.text);
                              } else {
                                otpPin = otpController.text;
                                verifyOTP();

                                ///TODO KİŞİ BİLGİLERİNİ AL
                              }
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
        title: Text(
          "Junior Kayıt",
          style: TextStyle(fontSize: 25, color: blue),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: blue,
          ),
          onPressed: () {
            if (screenState == 0)
              Navigator.of(context).pop();
            else {
              setState(() {
                screenState = 0;
              });
            }
          },
        ),
      ),
      body: screenState == 1 ? OTPWidget() : RegisterWidget(),
    );
  }

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  Widget OTPWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: SizedBox(
            height: screenHeight * 0.1,
            child: Row(
              children: [
                Text(
                  "Numara Doğrulama",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
              child: Text(
                "Telefonuna gelen 6 haneli kodu gir",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: /*PinCodeTextField(
            appContext: context,
            length: 6,
            onChanged: (value) {
              setState(() {
                otpPin = value;
              });
            },
            pinTheme: PinTheme(
              activeColor: blue,
              selectedColor: blue,
              inactiveColor: Colors.black26,
            ),
          ),*/
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: otpController,
                  textInputAction: TextInputAction.done,
                  style: TextStyle(fontSize: 20),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Lütfen kodu gir.';
                    }
                    return null;
                  },
                  maxLines: 1,
                  maxLength: 6,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Color(0xff4C6170))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Color(0xff4C6170))),
                    //border: InputBorder.,
                    hintText: "- - - - - -",
                    //filled: true,
                    //fillColor: Colors.grey,
                    contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  )),
        ),
      ],
    );
  }

  Widget RegisterWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: SizedBox(
            height: screenHeight * 0.1,
            child: Row(
              children: [
                Text(
                  "Üye Ol veya Giriş Yap",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Text(
            "Telefon numaranı girerek üye ol veya giriş yap. Daha önceden oluşturulmuş bir hesabın yoksa telefon doğrulaması sonrası otomatik olarak kayıt sayfasına yönlendirilirsin.",
            maxLines: 6,
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Row(
            children: [
              InkWell(
                onTap: () async {
                  final code = await countryPicker.showPicker(context: context);
                  setState(() {
                    countryCode = code;
                    defaultCode = countryCode!.dialCode;
                  });
                },
                child: Container(
                  height: screenHeight * 0.08,
                  width: screenWidth * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 3.0, color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          ///TODO başlangıçta bayrak koymuyor
                          child: countryCode != null
                              ? countryCode!.flagImage
                              : null,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        countryCode?.dialCode ?? defaultCode,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  height: screenHeight * 0.08,
                  width: screenWidth * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(width: 3.0, color: Colors.grey),
                  ),
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      textInputAction: TextInputAction.done,
                      style: TextStyle(fontSize: 20),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 10) {
                          return 'Lütfen numaranı gir.';
                        }
                        return null;
                      },
                      maxLines: 1,
                      maxLength: 10,

                      //initialValue: "Telefon numaranı yaz",
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Telefon numaranı yaz",
                        //filled: true,
                        //fillColor: Colors.grey,
                        contentPadding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      )),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: Text(
            'Not: Başında "0" (sıfır) olmadan yaz',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ],
    );
  }
}
