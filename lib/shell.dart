import 'package:adalem/nav/create_nav.dart';
import 'package:adalem/nav/explore_nav.dart';
import 'package:adalem/nav/home_nav.dart';
import 'package:adalem/nav/profile_nav.dart';
import 'package:adalem/nav/share_nav.dart';
import 'package:flutter/material.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _selectedIndex = 0;

  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (states) => TextStyle(color: Theme.of(context).colorScheme.onPrimary),)),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
              icon: Icon(Icons.home_outlined, color: Theme.of(context).colorScheme.onPrimary),
              label: "Home"),
            NavigationDestination(
              selectedIcon: Icon(Icons.chrome_reader_mode, color: Theme.of(context).colorScheme.primary),
              icon: Icon(Icons.chrome_reader_mode_outlined, color: Theme.of(context).colorScheme.onPrimary),
              label: 'Explore'),
            NavigationDestination(
              selectedIcon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              icon: Icon(Icons.add, size: 38, color: Theme.of(context).colorScheme.onPrimary),
              label: 'Create'),
            NavigationDestination(
              selectedIcon: Icon(Icons.share_rounded, color: Theme.of(context).colorScheme.primary),
              icon: Icon(Icons.share_outlined, color: Theme.of(context).colorScheme.onPrimary),
              label: 'Share'),
            NavigationDestination(
              selectedIcon: Icon(Icons.account_circle, color: Theme.of(context).colorScheme.primary),
              icon: Icon(Icons.account_circle_outlined, color: Theme.of(context).colorScheme.onPrimary),
              label: 'Me'),       
          ],
          backgroundColor: Theme.of(context).colorScheme.primary,
          indicatorColor: Theme.of(context).colorScheme.inversePrimary,
          height: 65,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        ),
      ),

      body: SafeArea(
        top: false,
        child: PageStorage(
          bucket: _bucket,
          child: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
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