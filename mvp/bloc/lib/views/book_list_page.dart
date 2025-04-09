import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/book.dart';
import '../presenters/book_bloc.dart';
import '../presenters/book_event.dart';
import '../presenters/book_state.dart';
import 'add_edit_book_page.dart'; // Will create next
import 'book_detail_page.dart'; // Will create next

class BookListPage extends StatelessWidget {
  const BookListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books (MVP - BLoC)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to Add/Edit page without a book for adding
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value( // Provide existing BLoC
                        value: BlocProvider.of<BookBloc>(context),
                        child: const AddEditBookPage(),
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<BookBloc, BookState>(
        listener: (context, state) {
          // Show snackbar on successful operations or errors
          if (state is BookOperationSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.message)));
            // Optionally trigger reload if not handled by BLoC state transition
            // BlocProvider.of<BookBloc>(context).add(LoadBooks());
          } else if (state is BookError) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
        builder: (context, state) {
          if (state is BookLoading || state is BookInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookLoaded || state is BookOperationSuccess || state is BookSelected) {
            // Extract books based on the current state type
             List<Book> books = [];
             if (state is BookLoaded) books = state.books;
             if (state is BookOperationSuccess) books = state.books;
             if (state is BookSelected) books = state.allBooks; // Use allBooks from BookSelected

            if (books.isEmpty) {
              return const Center(child: Text('No books available. Add one!'));
            }

            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  onTap: () {
                     // Select the book and navigate to detail page
                     BlocProvider.of<BookBloc>(context).add(SelectBook(book));
                     Navigator.of(context).push(
                       MaterialPageRoute(
                         builder: (_) => BlocProvider.value(
                               value: BlocProvider.of<BookBloc>(context),
                               child: const BookDetailPage(),
                             ),
                       ),
                     );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Show confirmation dialog before deleting
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
                                  // Dispatch delete event
                                  BlocProvider.of<BookBloc>(context).add(DeleteBook(book.id));
                                  Navigator.of(ctx).pop();
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
          } else if (state is BookError) {
            // Show error message and a retry button
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load books: ${state.message}'),
                  ElevatedButton(
                    onPressed: () => BlocProvider.of<BookBloc>(context).add(LoadBooks()),
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          }
          // Default case (shouldn't be reached if states are handled)
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}
