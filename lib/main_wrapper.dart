import 'package:adalem/nav/create_nav.dart';
import 'package:adalem/nav/explore_nav.dart';
import 'package:adalem/nav/home_nav.dart';
import 'package:adalem/nav/profile_nav.dart';
import 'package:adalem/nav/share_nav.dart';
import 'package:flutter/material.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home'),
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search),
            label: 'Search'),
          NavigationDestination(
            selectedIcon: Icon(Icons.add),
            icon: Icon(Icons.add),
            label: ''),
          NavigationDestination(
            selectedIcon: Icon(Icons.ios_share),
            icon: Icon(Icons.ios_share),
            label: 'Share'),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Me'),       
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: SafeArea(
        top: false,
        child: PageStorage(
          bucket: _bucket,
          child: IndexedStack(
            index: _selectedIndex,
            children: const <Widget>[
              Home(),
              Explore(),
              Create(),
              Share(),
              Profile(),
            ],
          )
        ),
      ),
    );
  }
}