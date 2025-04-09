import 'package:flutter/material.dart';
import '../model/news.dart';

// 新聞詳細頁面 | News Detail Page
class NewsDetailPage extends StatelessWidget {

  const NewsDetailPage({super.key, required this.news});
  final News news;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              news.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              '作者: ${news.author}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(news.content),
          ],
        ),
      ),
    );
}
