import 'package:adalem/features/explore/presentation/view_explore.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  final GlobalKey<ExploreViewState>? exploreKey;

  const Explore({super.key, this.exploreKey});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {

  GlobalKey<NavigatorState> exploreNavigatorKey = GlobalKey<NavigatorState>();
  
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: exploreNavigatorKey,
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context){
            if(settings.name == '/'){
              return ExploreView(key: widget.exploreKey);
            } 
            return ExploreView(key: widget.exploreKey);
          },
        );
      } 
    );
  }
}