import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../presenters/book_store.dart';

class AddEditBookPage extends StatefulWidget { // If null, adding a new book

  const AddEditBookPage({super.key, this.book});
  final Book? book;

  @override
  State<AddEditBookPage> createState() => _AddEditBookPageState();
}

class _AddEditBookPageState extends State<AddEditBookPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.book != null;
    _titleController = TextEditingController(text: widget.book?.title ?? '');
    _authorController = TextEditingController(text: widget.book?.author ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text;
      final String author = _authorController.text;
      final BookStore store = context.read<BookStore>(); // Get the store

      // Define a callback for after the action completes
      void handleCompletion() {
         // Check status after async operation completes
         if (store.loadingStatus == LoadingStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_isEditing ? 'Book updated!' : 'Book added!'))
            );
            Navigator.of(context).pop(); // Navigate back on success
         } else if (store.loadingStatus == LoadingStatus.error) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('Error: ${store.errorMessage}'))
             );
             // Don't pop on error, let user retry or fix
         }
      }


      if (_isEditing) {
        final Book updatedBook = widget.book!.copyWith(title: title, author: author);
        // Call the update action and handle completion
        store.updateBook(updatedBook).then((_) => handleCompletion());
      } else {
        // Call the add action and handle completion
        store.addBook(title, author).then((_) => handleCompletion());
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Book' : 'Add Book'),
      ),
      // Use Observer to react to loading state for disabling button/fields
      body: Observer(
        builder: (_) {
          final store = context.watch<BookStore>(); // Watch for status changes
          final isLoading = store.loadingStatus == LoadingStatus.loading;

          return Stack( // Use Stack for loading indicator overlay
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _authorController,
                        decoration: const InputDecoration(labelText: 'Author'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an author';
                          }
                          return null;
                        },
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: isLoading ? null : _submitForm,
                        child: Text(_isEditing ? 'Update Book' : 'Add Book'),
                      ),
                    ],
                  ),
                ),
              ),
              // Loading indicator overlay
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
}
