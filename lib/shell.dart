import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';
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
  final AuthUser? welcomeUser;
  const Shell({super.key, this.initIndex = 0, this.welcomeUser});

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
    //GlobalKey<NavigatorState>(), // 3 : SHARE
    GlobalKey<NavigatorState>(), // 4 : PROFILE
  ];

  @override
  void initState() {
    super.initState();
    if (widget.welcomeUser != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final user = widget.welcomeUser!;
        ToastCard.success(
          context,
          "Hello ${user.name.isNotEmpty ? user.name : 'User'}!",
          description: user.email,
          icon: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.photoURL),
            backgroundColor: Colors.grey.shade600,
          ),
        );
      });
    }
  }

  void _handleSystemRet() {
    _selectedIndex != 0 ? setState(() {
      _selectedIndex = 0;
    }) : SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).colorScheme.surface;
    final onBgColor = Theme.of(context).colorScheme.inverseSurface;
    final indColor = Theme.of(context).colorScheme.primary;

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
            (states) => TextStyle(color: onBgColor),)),
          child: Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(width: 1.0, color: onBgColor.withValues(alpha: 0.08)))
            ),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              destinations: <NavigationDestination>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home, color: bgColor),
                  icon: Icon(Icons.home_outlined, color: onBgColor),
                  label: "Home"),
                NavigationDestination(
                  selectedIcon: Icon(Icons.chrome_reader_mode, color: bgColor),
                  icon: Icon(Icons.chrome_reader_mode_outlined, color: onBgColor),
                  label: "Explore"),
                NavigationDestination(
                  selectedIcon: Icon(Icons.add, color: bgColor),
                  icon: Icon(Icons.add, size: 38, color: onBgColor),
                  label: "Create"),
                // NavigationDestination(
                //   selectedIcon: Icon(Icons.share_rounded, color: bgColor),
                //   icon: Icon(Icons.share_outlined, color: onBgColor),
                //   label: "Share"),
                NavigationDestination(
                  selectedIcon: Icon(Icons.account_circle, color: bgColor),
                  icon: Icon(Icons.account_circle_outlined, color: onBgColor),
                  label: "Me"),       
              ],
              backgroundColor: bgColor,
              indicatorColor: indColor,
              height: 65,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            ),
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
                  onNavigateToCreate: () => setState(() => _selectedIndex = 2),
                ),
                Explore(
                  navigatorKey: _navigatorKeys[1],
                  exploreKey: _exploreKey,
                  ),
                Create(navigatorKey: _navigatorKeys[2],),
                //Share(),
                Profile(navigatorKey: _navigatorKeys[3]),
              ],
            )
          ),
        ),
      ),
    );
  }
}