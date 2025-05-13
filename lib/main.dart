import 'data/dummy_article.dart';
import 'article_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainApp();
}

class _MainApp extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false, home: ArticleScreen(article: dummyArticle));
  }
}


// NOTE TO SELF: No file should exceed 200 LOC unless extremely required 