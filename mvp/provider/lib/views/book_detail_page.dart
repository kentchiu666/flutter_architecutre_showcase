import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presenters/book_presenter.dart';
import 'add_edit_book_page.dart'; // Needed for editing

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the presenter for changes to the selected book
    final selectedBook = context.watch<BookPresenter>().selectedBook;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        actions: <Widget>[
          // Show edit button only if a book is selected
          if (selectedBook != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navigate to AddEditBookPage with the selected book for editing
                Navigator.of(context).pushReplacement( // Use pushReplacement
                  MaterialPageRoute(
                    builder: (_) => AddEditBookPage(book: selectedBook),
                  ),
                );
              },
            ),
        ],
      ),
      body: selectedBook == null
          ? const Center(
              child: Text('No book selected.'), // Handle case where selection might be lost
            )
          : Padding(
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
            ),
    );
  }
}
