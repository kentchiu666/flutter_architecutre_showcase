import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'services/news_service.dart';
import 'view/news_reader_app.dart';

// Initialize GetIt service locator
final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Register NewsService as a singleton
  getIt.registerSingleton<NewsService>(NewsService());
}

void main() {
  // Setup service locator before running the app
  setupLocator();
  runApp(const NewsReaderApp());
}
