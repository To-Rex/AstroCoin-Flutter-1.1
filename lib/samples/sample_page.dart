import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../draverpages/home_page.dart';
import '../draverpages/search_user.dart';
import '../draverpages/settings_page.dart';

class SamplePage extends StatefulWidget {
  const SamplePage({super.key});

  @override
  _SampesPageState createState() => _SampesPageState();
}

class _SampesPageState extends State<SamplePage> with SingleTickerProviderStateMixin {

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    SearchPage(),
    SettingsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromRGBO(245, 245, 245, 1.0),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: SvgPicture.asset(
                'assets/svgs/home_icon.svg',
                width: MediaQuery.of(context).size.width * 0.06,
                height: MediaQuery.of(context).size.width * 0.06,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svgs/home_icon1.svg',
                width: MediaQuery.of(context).size.width * 0.06,
                height: MediaQuery.of(context).size.width * 0.06,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: SvgPicture.asset(
                'assets/svgs/bottom_user.svg',
                width: MediaQuery.of(context).size.width * 0.06,
                height: MediaQuery.of(context).size.width * 0.06,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svgs/bottom_user1.svg',
                width: MediaQuery.of(context).size.width * 0.06,
                height: MediaQuery.of(context).size.width * 0.06,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: SvgPicture.asset(
                'assets/svgs/settings_icon.svg',
                width: MediaQuery.of(context).size.width * 0.06,
                height: MediaQuery.of(context).size.width * 0.06,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svgs/settings_icon1.svg',
                width: MediaQuery.of(context).size.width * 0.06,
                height: MediaQuery.of(context).size.width * 0.06,
              ),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          elevation: 5,
          selectedItemColor: Colors.white,
          selectedIconTheme: const IconThemeData(color: Colors.indigo),
          onTap: _onItemTapped,
        ),
      );
    }else{
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color.fromRGBO(245, 245, 245, 1.0),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: SvgPicture.asset(
                'assets/svgs/home_icon.svg',
                width: MediaQuery.of(context).size.width * 0.05,
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svgs/home_icon1.svg',
                width: MediaQuery.of(context).size.width * 0.05,
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: SvgPicture.asset(
                'assets/svgs/bottom_user.svg',
                width: MediaQuery.of(context).size.width * 0.04,
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svgs/bottom_user1.svg',
                width: MediaQuery.of(context).size.width * 0.04,
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              label: 'History',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: SvgPicture.asset(
                'assets/svgs/settings_icon.svg',
                width: MediaQuery.of(context).size.width * 0.04,
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              activeIcon: SvgPicture.asset(
                'assets/svgs/settings_icon1.svg',
                width: MediaQuery.of(context).size.width * 0.04,
                height: MediaQuery.of(context).size.width * 0.04,
              ),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          elevation: 5,
          selectedItemColor: Colors.white,
          selectedIconTheme: const IconThemeData(color: Colors.indigo),
          onTap: _onItemTapped,
        ),
      );
    }

  }
}