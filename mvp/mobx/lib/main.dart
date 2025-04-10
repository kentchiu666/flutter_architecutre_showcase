import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/book_service.dart';
import 'views/book_app.dart'; // Import the BookApp widget
// Note: We don't directly provide BookStore here, BookApp does that.

void main() {
  // Create an instance of the BookService
  final bookService = BookService();

  runApp(
    // Provide the BookService instance at the top level
    Provider<BookService>(
      create: (_) => bookService,
      child: const BookApp(), // Run the main application widget
                               // BookApp will then provide BookStore using this service
    ),
  );
}
