import 'package:flutter/material.dart';

import 'my_account_bottom.dart';
import 'my_booking_bottom.dart';
import 'my_home_bottom.dart';
import 'my_noti_bottom.dart';
import 'my_save_bottom.dart';

class BottomNav extends StatefulWidget {
  static const routeName = '/bottomNav';
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  void initState() {
    super.initState();
  }

  int selectedIndex = 0;
  final Widget _myHome = MyHome();
  final Widget _myBooking = MyBooking();
  final Widget _myPost = MyPost();
  final Widget _myAccount = MyAccount();
  @override
  Widget build(BuildContext context) {
    void onTapHandler(int index) {
      setState(() {
        selectedIndex = index;
        _myAccount;
      });
    }

    Widget getBody() {
      if (selectedIndex == 0) {
        return _myHome;
      } else if (selectedIndex == 1) {
        return _myBooking;
      } else if (selectedIndex == 2) {
        return _myPost;
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
        items: const [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'My Booking',
            icon: Icon(Icons.library_books_outlined),
            activeIcon: Icon(Icons.library_books),
          ),
          BottomNavigationBarItem(
            label: 'My Post',
            icon: Icon(Icons.podcasts_outlined),
            activeIcon: Icon(Icons.podcasts),
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
