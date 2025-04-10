import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../presenters/book_store.dart';
import 'add_edit_book_page.dart'; // Will create next
import 'book_detail_page.dart'; // Will create next

class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the store instance from the provider
    final BookStore store = context.read<BookStore>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books (MVP - MobX)'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Clear selection before navigating
              store.selectBookAction(null);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AddEditBookPage(),
                ),
              );
            },
          ),
        ],
      ),
      // Use Observer to automatically rebuild when observables change
      body: Observer(
        builder: (_) {
          // Handle loading state
          if (store.loadingStatus == LoadingStatus.loading && store.books.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (store.loadingStatus == LoadingStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Failed to load books: ${store.errorMessage ?? "Unknown error"}'),
                  ElevatedButton(
                    onPressed: store.loadBooks, // Call action directly
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          }

          // Handle empty list state
          if (store.books.isEmpty && store.loadingStatus != LoadingStatus.loading) {
             return const Center(child: Text('No books available. Add one!'));
          }

          // Display the list
          return ListView.builder(
            itemCount: store.books.length,
            itemBuilder: (BuildContext context, int index) {
              final Book book = store.books[index];
              return ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () {
                  // Call action to select book
                  store.selectBookAction(book);
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
                      builder: (BuildContext ctx) => AlertDialog(
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
                                // Call action to delete book
                                store.deleteBook(book.id);
                                Navigator.of(ctx).pop();
                                // Optional: Show snackbar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('"${book.title}" deleted.'))
                                );
                              },
                            ),
                          ],
                        ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
