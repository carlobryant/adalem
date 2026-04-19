import 'package:adalem/features/share/presentation/view_share.dart';
import 'package:flutter/material.dart';

class Share extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const Share({
    super.key,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context){
            return ShareView();
          },
        );
      } 
    );
  }
}