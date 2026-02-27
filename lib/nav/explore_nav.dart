import 'package:adalem/features/explore/presentation/view_explore.dart';
import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ExploreViewState>? exploreKey;

  const Explore({
    super.key,
    required this.navigatorKey,
    this.exploreKey,
    });
  
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [ HeroController() ],
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context){
            if(settings.name == '/'){
              return ExploreView(key: exploreKey);
            } 
            return ExploreView(key: exploreKey);
          },
        );
      } 
    );
  }
}