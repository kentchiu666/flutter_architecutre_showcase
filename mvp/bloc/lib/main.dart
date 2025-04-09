import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/book_service.dart';
import 'views/book_app.dart';

void main() {
  // Create an instance of the BookService
  final BookService bookService = BookService();

  runApp(
    // Provide the BookService instance to the entire widget tree
    RepositoryProvider<BookService>(
      create: (context) => bookService,
      child: const BookApp(), // Run the main application widget
    ),
  );
}
