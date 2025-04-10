import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../providers.dart'; // Import providers
import 'add_edit_book_page.dart'; // Needed for editing

class BookDetailPage extends ConsumerWidget {
  const BookDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the provider to get the selected book from the state
    final Book? selectedBook = ref.watch(bookPresenterProvider.select((state) => state.selectedBook));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        actions: [
          // Show edit button only if a book is selected
          if (selectedBook != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navigate to AddEditBookPage with the selected book
                Navigator.of(context).pushReplacement(
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
              child: Text('No book selected.'),
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
