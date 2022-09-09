import 'package:flutter/material.dart';
import 'package:juniorapp/ColorPalette.dart';
import 'package:juniorapp/Pages/ProfilePage.dart';

import 'HomePage.dart';
import 'advantagePage.dart';
import 'blogPage.dart';
class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);


  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int selectedIndex = 0;
  PageController pageController = PageController();

  final screens = [HomePage(),BlogPage(),AdvantagePage(),ProfilePage()];

  void onTapped(int index){
    setState((){
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon:Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon:Icon(Icons.menu_book_outlined), label: 'Blog'),
          BottomNavigationBarItem(icon:Icon(Icons.card_giftcard_outlined), label: 'Avanatajlar'),
          BottomNavigationBarItem(icon:Icon(Icons.person_outline_outlined), label: 'Profil'),
        ],showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        selectedItemColor: ColorPalette().blue,
        unselectedItemColor: ColorPalette().grey,
        onTap: onTapped,
      ),
      backgroundColor: Colors.white,
      body: PageView(
        controller: pageController,
        children: screens,
      ),

    );
  }

}
