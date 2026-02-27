import 'package:adalem/features/explore/presentation/view_explore.dart';
import 'package:adalem/nav/create_nav.dart';
import 'package:adalem/nav/explore_nav.dart';
import 'package:adalem/nav/home_nav.dart';
import 'package:adalem/nav/profile_nav.dart';
import 'package:adalem/nav/share_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Shell extends StatefulWidget {
  final int initIndex;
  const Shell({super.key, this.initIndex = 0});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  late int _selectedIndex = widget.initIndex;
  final PageStorageBucket _bucket = PageStorageBucket();

  final GlobalKey<ExploreViewState> _exploreKey = GlobalKey<ExploreViewState>();

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(), // 0 : HOME
    GlobalKey<NavigatorState>(), // 1 : EXPLORE
    GlobalKey<NavigatorState>(), // 2 : CREATE
    GlobalKey<NavigatorState>(), // 3 : SHARE
    GlobalKey<NavigatorState>(), // 4 : PROFILE
  ];

  void _handleSystemRet() {
    _selectedIndex != 0 ? setState(() {
      _selectedIndex = 0;
    }) : SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final activeNavigator = _navigatorKeys[_selectedIndex].currentState;
        if (activeNavigator != null && activeNavigator.canPop()) {
          activeNavigator.pop();
        } else {
          _handleSystemRet();
        }
      },
      child: Scaffold( 
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
                label: "Explore"),
              NavigationDestination(
                selectedIcon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                icon: Icon(Icons.add, size: 38, color: Theme.of(context).colorScheme.onPrimary),
                label: "Create"),
              NavigationDestination(
                selectedIcon: Icon(Icons.share_rounded, color: Theme.of(context).colorScheme.primary),
                icon: Icon(Icons.share_outlined, color: Theme.of(context).colorScheme.onPrimary),
                label: "Share"),
              NavigationDestination(
                selectedIcon: Icon(Icons.account_circle, color: Theme.of(context).colorScheme.primary),
                icon: Icon(Icons.account_circle_outlined, color: Theme.of(context).colorScheme.onPrimary),
                label: "Me"),       
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
                Home(
                  navigatorKey: _navigatorKeys[0],
                  onNavigateToExplore: () {
                    setState(() {_selectedIndex = 1;});
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _exploreKey.currentState?.scrollToTop();
                    });
                  },
                ),
                Explore(
                  navigatorKey: _navigatorKeys[1],
                  exploreKey: _exploreKey,
                  ),
                Create(),
                Share(),
                Profile(),
              ],
            )
          ),
        ),
      ),
    );
  }
}