import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:flutter/material.dart';

class NotebookChapter {
  final int id;
  final String header;
  final String? body;
  final List<String>? bullet;
  final GlobalKey key;

  NotebookChapter({
  required this.id,
  required this.header,
  this.body,
  this.bullet,
  }) : key = GlobalKey();
}


class ChapterModel {
  final Chapter chapter; 
  final GlobalKey scrollKey;
  final bool isExpanded; 

  ChapterModel({
    required this.chapter,
    GlobalKey? scrollKey,
    this.isExpanded = false,
  }) : scrollKey = scrollKey ?? GlobalKey();

  ChapterModel copyWith({bool? isExpanded}) {
    return ChapterModel(
      chapter: chapter,
      scrollKey: scrollKey,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}