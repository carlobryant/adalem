import 'package:adalem/components/notebook_card.dart';
import 'package:flutter/material.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  bool isLoading = true;

  final List<Map<String, String>> notebooks = const [
    {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': "yellow",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': "red",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': "grey",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': "blue",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': "orange",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': "green",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': "pink",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': "yellow",
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': "purple",
    },
  ];

  @override
  void initState() {
    super.initState();
    // Show loading animation for 2 seconds
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
              "Explore",
              style: TextStyle(color: Colors.white),
          ),
      ),


      body: SafeArea(
        child: GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 226, 
          ),
          
          itemCount: notebooks.length,
          itemBuilder: (context, index) {
            final notebook = notebooks[index];
            return NotebookCard(
               title: notebook['title']!, 
               course: notebook['course']!, 
               imageUrl: notebook['imageUrl']!,
               isLoading: isLoading,
            );
          }
        ),
      ),
    );
  }
}
