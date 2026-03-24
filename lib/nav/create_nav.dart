import 'package:adalem/features/create/presentation/view_create.dart';
import 'package:flutter/material.dart';

class Create extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  
  const Create({
    super.key,
    required this.navigatorKey,
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
            if(settings.name == '/'){
              return CreateView();
            } 
            return CreateView();
          },
        );
      } 
    );
  }
}