import 'package:flutter/material.dart';
import 'package:timezones/time_zones/time_zones.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _pageSelected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageSelected,
        children: [
          const TimeZonesPage(),
          Container(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.watch), label: 'TimeZones'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'People'),
        ],
        onTap: (value) {
          setState(() {
            _pageSelected = value;
          });
        },
      ),
    );
  }
}
