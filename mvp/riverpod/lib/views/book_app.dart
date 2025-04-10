import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'book_list_page.dart'; // We'll create this next

// Note: BookApp doesn't need to be a ConsumerWidget itself if it doesn't
// directly watch any providers. It just needs to be under the ProviderScope.
class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MVP Riverpod Books',
      theme: ThemeData(
        primarySwatch: Colors.purple, // Different theme color
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const BookListPage(), // Start with the list page
      debugShowCheckedModeBanner: false,
    );
  }
}
