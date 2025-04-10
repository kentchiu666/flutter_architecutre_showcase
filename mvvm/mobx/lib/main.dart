import 'package:flutter/material.dart';
import 'service/news_service.dart';
import 'store/news_store.dart';
import 'view/news_reader_app.dart';

void main() {
  final NewsService newsService = NewsService();
  final NewsStore newsStore = NewsStore(newsService);

  runApp(
    NewsReaderApp(newsStore: newsStore),
  );
}
