import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../presenters/book_state.dart'; // Import state definition
import '../providers.dart'; // Import providers
import 'add_edit_book_page.dart'; // Will create next
import 'book_detail_page.dart'; // Will create next

// Extend ConsumerWidget to access the ref object
class BookListPage extends ConsumerWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the presenter provider to get the current state and rebuild on changes
    final bookState = ref.watch(bookPresenterProvider);

    // Listen for errors or specific conditions to show SnackBars (optional)
    ref.listen<BookState>(bookPresenterProvider, (previous, next) {
      if (next.status == BookListStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text('Error: ${next.errorMessage}')));
      }
      // Can add listeners for success messages if needed
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books (MVP - Riverpod)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Clear selection before navigating
              ref.read(bookPresenterProvider.notifier).selectBook(null);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AddEditBookPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(context, ref, bookState),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, BookState state) {
    // Handle loading state
    if (state.status == BookListStatus.loading && state.books.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Handle error state (already handled by listener for Snackbar, but can show inline too)
    if (state.status == BookListStatus.error && state.books.isEmpty) {
       return Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text('Failed to load books: ${state.errorMessage ?? "Unknown error"}'),
             ElevatedButton(
               // Call presenter method via notifier
               onPressed: () => ref.read(bookPresenterProvider.notifier).loadBooks(),
               child: const Text('Retry'),
             )
           ],
         ),
       );
    }

    // Handle empty list state
    if (state.books.isEmpty && state.status != BookListStatus.loading) {
       return const Center(child: Text('No books available. Add one!'));
    }

    // Display the list of books
    return ListView.builder(
      itemCount: state.books.length,
      itemBuilder: (context, index) {
        final book = state.books[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          onTap: () {
            // Call presenter method via notifier to select book
            ref.read(bookPresenterProvider.notifier).selectBook(book);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const BookDetailPage(),
              ),
            );
          },
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: Text('Are you sure you want to delete "${book.title}"?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          // Call presenter method via notifier to delete
                          ref.read(bookPresenterProvider.notifier).deleteBook(book.id);
                          Navigator.of(ctx).pop();
                          // Optional: Show snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: Text('"${book.title}" deleted.'))
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
