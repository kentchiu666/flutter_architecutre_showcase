import 'package:flutter/material.dart';
import 'news_list_page.dart';

// 主應用程式 Widget | Main Application Widget
class NewsReaderApp extends StatelessWidget {
  const NewsReaderApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: '新聞閱讀器 (Riverpod)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const NewsListPage(), // Set NewsListPage as the home screen
    );
}
