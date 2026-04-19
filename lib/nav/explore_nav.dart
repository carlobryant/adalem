import 'package:adalem/features/explore/presentation/view_explore.dart';
import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ExploreViewState>? exploreKey;
  final VoidCallback onNavigateToShare;

  const Explore({
    super.key,
    this.exploreKey,
    required this.navigatorKey,
    required this.onNavigateToShare,
    });
  
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: [HeroController()],
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context){
            return ExploreView(
              key: exploreKey,
              onNavigateToShare: onNavigateToShare,
            );
          },
        );
      } 
    );
  }
}