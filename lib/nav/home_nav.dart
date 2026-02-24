import 'package:adalem/features/home/presentation/view_home.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final VoidCallback onNavigateToExplore;

  const Home({super.key, required this.onNavigateToExplore});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey<NavigatorState>();
  
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: homeNavigatorKey,
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context){
            if(settings.name == '/'){
              return HomeView(onNavigateToExplore: widget.onNavigateToExplore);
            } 
            return HomeView(onNavigateToExplore: widget.onNavigateToExplore);
          },
        );
      } 
    );
  }
}