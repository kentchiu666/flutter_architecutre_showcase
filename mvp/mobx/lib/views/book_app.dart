import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presenters/book_store.dart';
import '../services/book_service.dart';
import 'book_list_page.dart'; // We'll create this next

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the BookStore to the widget tree.
    // It depends on BookService, which should be provided higher up (in main.dart).
    return Provider<BookStore>(
      // Create the store, injecting the service from the context
      create: (context) => BookStore(context.read<BookService>()),
      // Removed dispose as it's often not needed for simple MobX stores
      child: MaterialApp(
        title: 'MVP MobX Books',
        theme: ThemeData(
          primarySwatch: Colors.orange, // Different theme color
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const BookListPage(), // Start with the list page
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
