import 'package:adalem/features/notebook_content/domain/content_entity.dart';
import 'package:flutter/material.dart';

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