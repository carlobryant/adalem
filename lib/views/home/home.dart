import 'package:adalem/features/notebooks/presentation/view_hnotebookcard.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = false;

  final List<Map<String, String>> notebooks = const [
    {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'image': "yellow",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'image': "red",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'image': "grey",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'image': "blue",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'image': "orange",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'image': "green",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'image': "pink",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'image': "yellow",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'image': "purple",
    },
  ];

  @override
   Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
            "Home",
            style: TextStyle(color: Colors.white),
        )
     ),

     body: SafeArea(
      child: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 226, 
          ),

          itemCount: notebooks.length,
          itemBuilder: (context, index) {
            final notebook = notebooks[index];
            return HorizontalNotebookCard(
              title: notebook['title']!,
              course: notebook['course']!,
              image: notebook['image']!,
              assessment: notebook['course']!,
              isLoading: isLoading);
          },
        ),
      ),
    );
  }
}