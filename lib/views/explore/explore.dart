import 'package:adalem/components/notebook_card.dart';
import 'package:flutter/material.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final List<Map<String, String>> notebooks = const [
    {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': 'https://static.wixstatic.com/media/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg/v1/fill/w_787,h_471,al_c,lg_1,q_85,enc_avif,quality_auto/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg',
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': 'https://static.wixstatic.com/media/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg/v1/fill/w_787,h_471,al_c,lg_1,q_85,enc_avif,quality_auto/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg',
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': 'https://static.wixstatic.com/media/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg/v1/fill/w_787,h_471,al_c,lg_1,q_85,enc_avif,quality_auto/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg',
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': 'https://static.wixstatic.com/media/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg/v1/fill/w_787,h_471,al_c,lg_1,q_85,enc_avif,quality_auto/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg',
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': 'https://static.wixstatic.com/media/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg/v1/fill/w_787,h_471,al_c,lg_1,q_85,enc_avif,quality_auto/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg',
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': 'https://static.wixstatic.com/media/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg/v1/fill/w_787,h_471,al_c,lg_1,q_85,enc_avif,quality_auto/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg',
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': 'https://static.wixstatic.com/media/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg/v1/fill/w_787,h_471,al_c,lg_1,q_85,enc_avif,quality_auto/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg',
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': 'https://static.wixstatic.com/media/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg/v1/fill/w_787,h_471,al_c,lg_1,q_85,enc_avif,quality_auto/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg',
    },
     {
      'title': 'Introduction to Flutter',
      'course': 'IT 141',
      'imageUrl': 'https://static.wixstatic.com/media/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg/v1/fill/w_787,h_471,al_c,lg_1,q_85,enc_avif,quality_auto/b16d6f_b61a898be8314937a5805b0e9d8861f2~mv2.jpg',
    },
  ];

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
            mainAxisExtent: 220, 
          ),
          
          itemCount: notebooks.length,
          itemBuilder: (context, index) {
            final notebook = notebooks[index];
            return NotebookCard(
               title: notebook['title']!, 
               course: notebook['course']!, 
               imageUrl: notebook['imageUrl']!,
            );
          }
        ),
      ),
    );
  }
}


//https://youtu.be/c7xl9Og8eEM?list=PLwEKe-KnxbnD5z91CdrxCXORakEGqaKx0