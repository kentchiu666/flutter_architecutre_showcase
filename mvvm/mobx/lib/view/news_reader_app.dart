import 'package:flutter/material.dart';
import '../store/news_store.dart';
import 'news_list_page.dart';

// 新聞閱讀器應用程式 | News Reader App
class NewsReaderApp extends StatelessWidget {

  const NewsReaderApp({super.key, required this.newsStore});
  final NewsStore newsStore;

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'MVVM新聞閱讀器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NewsListPage(newsStore: newsStore),
    );
}
