import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'view/news_reader_app.dart'; // Import the root app widget

void main() {
  runApp(
    // Wrap the entire app in a ProviderScope to make providers available
    const ProviderScope(
      child: NewsReaderApp(),
    ),
  );
}
