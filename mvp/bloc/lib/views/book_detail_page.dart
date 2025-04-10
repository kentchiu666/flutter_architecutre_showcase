import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/book.dart';
import '../presenters/book_bloc.dart';
import '../presenters/book_state.dart';
import 'add_edit_book_page.dart'; // Needed for editing

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        actions: [
          // Edit button - only shown when a book is selected
          BlocBuilder<BookBloc, BookState>(
            builder: (context, state) {
              if (state is BookSelected) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to AddEditBookPage with the selected book for editing
                    Navigator.of(context).pushReplacement( // Use pushReplacement to avoid stacking detail pages
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                              value: BlocProvider.of<BookBloc>(context),
                              child: AddEditBookPage(book: state.selectedBook),
                            ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink(); // Hide if no book selected
            },
          ),
        ],
      ),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state is BookSelected) {
            final book = state.selectedBook;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    book.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By ${book.author}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Text('ID: ${book.id}'), // Displaying ID for reference
                  // Add more details if needed
                ],
              ),
            );
          } else if (state is BookLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            // Handle cases where no book is selected or state is unexpected
            return const Center(
              child: Text('No book selected or error occurred.'),
            );
          }
        },
      ),
    );
}
