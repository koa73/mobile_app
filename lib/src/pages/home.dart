import 'package:flutter/material.dart';

import 'catalogue.dart';
import 'shopping_cart.dart';
import 'shopping_history.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static double listViewOffset=0.0;
  int _selectedIndex = 0;


  List<Widget> _children = [
    new CatalogueWidget(),
    new ShoppingCartWidget(),
    new ShoppingHistoryWidget(),
    new ProfileWidget()
  ];


  final Color tintColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Shopper'),

      ),
      body:  _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.view_list),
              backgroundColor: tintColor, title: Text('Gatalogue')),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_basket),
              backgroundColor: tintColor, title: Text('Shopping Cart')),
          BottomNavigationBarItem(icon: Icon(Icons.history),
              backgroundColor: tintColor, title: Text('Shopping history')),
          BottomNavigationBarItem(icon: Icon(Icons.person),
              backgroundColor: tintColor, title: Text('Profile'))
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}