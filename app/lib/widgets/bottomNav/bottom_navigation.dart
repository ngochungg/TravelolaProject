import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'my_account_bottom.dart';
import 'my_booking_bottom.dart';
import 'my_home_bottom.dart';
import 'my_noti_bottom.dart';
import 'my_save_bottom.dart';

class BottomNav extends StatefulWidget {
  static final routeName = '/bottomNav';
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;
  Widget _myHome = MyHome();
  Widget _mySaved = MySaved();
  Widget _myBooking = MyBooking();
  Widget _myNoti = MyNoti();
  Widget _myAccount = MyAccount();
  @override
  Widget build(BuildContext context) {
    void onTapHandler(int index) {
      this.setState(() {
        selectedIndex = index;
      });
    }

    Widget getBody() {
      if (selectedIndex == 0) {
        return _myHome;
      } else if (selectedIndex == 1) {
        return _mySaved;
      } else if (selectedIndex == 2) {
        return _myBooking;
      } else if (selectedIndex == 3) {
        return _myNoti;
      } else {
        return _myAccount;
      }
    }

    return Scaffold(
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.black,
        selectedFontSize: 13,
        unselectedFontSize: 10,
        iconSize: 30,
        onTap: (int index) {
          onTapHandler(index);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Saved',
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: 'My Booking',
            icon: Icon(Icons.library_books_outlined),
            activeIcon: Icon(Icons.library_books),
          ),
          BottomNavigationBarItem(
            label: 'Notifications',
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
          ),
          BottomNavigationBarItem(
            label: 'My Account',
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }
}
