import 'package:adalem/views/share/share.dart';
import 'package:flutter/material.dart';

class Share extends StatefulWidget {
  const Share({super.key});

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {

  GlobalKey<NavigatorState> shareNavigatorKey = GlobalKey<NavigatorState>();
  
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: shareNavigatorKey,
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context){
            if(settings.name == '/'){
              return const ShareView();
            } 
            return const ShareView();
          },
        );
      } 
    );
  }
}