import 'package:adalem/features/create/presentation/view_create.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:flutter/material.dart';

class Create extends StatefulWidget {
  final NotebookViewModel notebookViewModel;
  const Create({super.key, required this.notebookViewModel});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {

  GlobalKey<NavigatorState> createNavigatorKey = GlobalKey<NavigatorState>();
  
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: createNavigatorKey,
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context){
            if(settings.name == '/'){
              return CreateView(notebookViewModel: widget.notebookViewModel);
            } 
            return CreateView(notebookViewModel: widget.notebookViewModel);
          },
        );
      } 
    );
  }
}