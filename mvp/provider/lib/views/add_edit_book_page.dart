import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../presenters/book_presenter.dart';

class AddEditBookPage extends StatefulWidget {

  const AddEditBookPage({super.key, this.book});
  // Optional book parameter for editing
  // If null, it's in 'add' mode.
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
      final BookPresenter presenter = context.read<BookPresenter>(); // Get presenter instance

      if (_isEditing) {
        // Create updated book object, keeping the original ID
        final Book updatedBook = widget.book!.copyWith(title: title, author: author);
        // Call presenter method to update
        presenter.updateBook(updatedBook).then((_) {
           // Optional: Show success message or handle errors if presenter doesn't reload list page automatically
           if (presenter.loadingStatus == LoadingStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Book updated successfully!'))
              );
           } else if (presenter.loadingStatus == LoadingStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error updating book: ${presenter.errorMessage}'))
              );
           }
           Navigator.of(context).pop(); // Navigate back after operation attempt
        });
      } else {
        // Call presenter method to add
        presenter.addBook(title, author).then((_) {
           // Optional: Show success message or handle errors
           if (presenter.loadingStatus == LoadingStatus.success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Book added successfully!'))
              );
           } else if (presenter.loadingStatus == LoadingStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error adding book: ${presenter.errorMessage}'))
              );
           }
           Navigator.of(context).pop(); // Navigate back after operation attempt
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for loading state to show indicator during async operations
    final bool isLoading = context.watch<BookPresenter>().loadingStatus == LoadingStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Book' : 'Add Book'),
      ),
      body: Stack( // Use Stack to overlay loading indicator
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                    enabled: !isLoading, // Disable form fields when loading
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(labelText: 'Author'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an author';
                      }
                      return null;
                    },
                    enabled: !isLoading, // Disable form fields when loading
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    // Disable button when loading
                    onPressed: isLoading ? null : _submitForm,
                    child: Text(_isEditing ? 'Update Book' : 'Add Book'),
                  ),
                ],
              ),
            ),
          ),
          // Show loading indicator overlay
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
