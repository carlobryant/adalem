import 'package:adalem/features/home/presentation/view_home.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final VoidCallback onNavigateToExplore;
  final VoidCallback onNavigateToCreate;

  const Home({
    super.key,
    required this.navigatorKey,
    required this.onNavigateToExplore,
    required this.onNavigateToCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context){
            return HomeView(
                onNavigateToExplore: onNavigateToExplore,
                onNavigateToCreate: onNavigateToCreate,
            );
          },
        );
      } 
    );
  }
}