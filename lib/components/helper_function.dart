import 'package:flutter/material.dart';

/*class DisplayToast extends StatelessWidget {
  const DisplayToast({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}*/

void displayToast(String message, BuildContext context){
  showDialog(
    context: context, 
    builder: (context) => AlertDialog(
      title: Text(message),
    )
  );
}