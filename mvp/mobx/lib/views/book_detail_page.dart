import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../presenters/book_store.dart';
import 'add_edit_book_page.dart'; // Needed for editing

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final BookStore store = context.read<BookStore>(); // Get the store instance

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        // Use Observer for the actions to react to selectedBook changes
        actions: <Widget>[
          Observer(
            builder: (_) {
              // Show edit button only if a book is selected
              if (store.selectedBook != null) {
                return IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to AddEditBookPage with the selected book
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => AddEditBookPage(book: store.selectedBook),
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox.shrink(); // Return empty if no book selected
              }
            },
          ),
        ],
      ),
      // Use Observer for the body to react to selectedBook changes
      body: Observer(
        builder: (_) {
          final Book? selectedBook = store.selectedBook; // Access observable state

          if (selectedBook == null) {
            return const Center(
              child: Text('No book selected.'),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    selectedBook.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By ${selectedBook.author}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Text('ID: ${selectedBook.id}'),
                  // Add more details if needed
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
