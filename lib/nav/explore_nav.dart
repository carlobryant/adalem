import 'package:adalem/features/explore/presentation/view_explore.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  final NotebookViewModel notebookViewModel;
  const Explore({super.key, required this.notebookViewModel});

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
              return ExploreView(notebookViewModel: widget.notebookViewModel);
            } 
            return ExploreView(notebookViewModel: widget.notebookViewModel);
          },
        );
      } 
    );
  }
}