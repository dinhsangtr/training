import 'package:flutter/material.dart';
import 'package:start/screen_a.dart';
import 'package:start/screen_b.dart';
import 'package:start/screen_c.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _page = <Widget>[
     ScreenA(),
     ScreenB(),
     ScreenC(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:IndexedStack(
          index: _selectedIndex,
          children: _page,
        )
        /*Center(
          child: _page.elementAt(_selectedIndex),
        )*/,
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.redAccent.withOpacity(0.7),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

//https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html
