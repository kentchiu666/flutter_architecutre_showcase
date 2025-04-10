import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presenters/book_presenter.dart';
import 'add_edit_book_page.dart'; // Will create next
import 'book_detail_page.dart'; // Will create next

class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Books (MVP - Provider)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Clear selection before navigating to add page
              context.read<BookPresenter>().selectBook(null);
              Navigator.of(context).push(
                MaterialPageRoute(
                  // No need for Provider.value here as AddEditBookPage will use context.read
                  builder: (_) => const AddEditBookPage(),
                ),
              );
            },
          ),
        ],
      ),
      // Use Consumer to listen to BookPresenter changes
      body: Consumer<BookPresenter>(
        builder: (context, presenter, child) {
          // Handle loading state
          if (presenter.loadingStatus == LoadingStatus.loading && presenter.books.isEmpty) {
             // Show loading indicator only if loading initial data
            return const Center(child: CircularProgressIndicator());
          }

          // Handle error state
          if (presenter.loadingStatus == LoadingStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load books: ${presenter.errorMessage ?? "Unknown error"}'),
                  ElevatedButton(
                    onPressed: () => context.read<BookPresenter>().loadBooks(),
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          }

          // Handle empty list state (after successful load)
          if (presenter.books.isEmpty && presenter.loadingStatus == LoadingStatus.success) {
            return const Center(child: Text('No books available. Add one!'));
          }

          // Display the list of books
          return ListView.builder(
            itemCount: presenter.books.length,
            itemBuilder: (context, index) {
              final book = presenter.books[index];
              return ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                onTap: () {
                  // Select the book using the presenter method
                  context.read<BookPresenter>().selectBook(book);
                  // Navigate to detail page
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
                                // Call presenter method to delete
                                context.read<BookPresenter>().deleteBook(book.id);
                                Navigator.of(ctx).pop();
                                // Optional: Show a snackbar (could be handled by presenter state if needed)
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
        },
      ),
    );
}
