import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presenters/book_presenter.dart';
import '../services/book_service.dart';
import 'book_list_page.dart'; // We'll create this next

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the BookPresenter to the widget tree
    // It depends on BookService, which should be provided higher up (in main.dart)
    return ChangeNotifierProvider(
      create: (BuildContext context) => BookPresenter(
        // Read the BookService instance provided earlier
        context.read<BookService>(),
      )..loadBooks(), // Load books initially when the presenter is created
      child: MaterialApp(
        title: 'MVP Provider Books',
        theme: ThemeData(
          primarySwatch: Colors.green, // Different theme color
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const BookListPage(), // Start with the list page
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
