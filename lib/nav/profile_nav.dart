
import 'package:adalem/features/profile/presentation/view_profile.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const Profile({
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
              return ProfileView();
            } 
            return ProfileView();
          },
        );
      } 
    );
  }
}