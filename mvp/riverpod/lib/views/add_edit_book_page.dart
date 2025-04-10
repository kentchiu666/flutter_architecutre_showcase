import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../presenters/book_state.dart'; // Import state for status enum
import '../providers.dart'; // Import providers

// Using ConsumerStatefulWidget because we need initState/dispose for controllers
class AddEditBookPage extends ConsumerStatefulWidget {
  final Book? book; // If null, adding a new book

  const AddEditBookPage({super.key, this.book});

  @override
  ConsumerState<AddEditBookPage> createState() => _AddEditBookPageState();
}

class _AddEditBookPageState extends ConsumerState<AddEditBookPage> {
  final _formKey = GlobalKey<FormState>();
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
      final title = _titleController.text;
      final author = _authorController.text;
      // Access the notifier to call methods
      final presenterNotifier = ref.read(bookPresenterProvider.notifier);

      // Define a callback for after the action completes
      void handleCompletion() {
         // Read the latest state *after* the async operation
         final state = ref.read(bookPresenterProvider);
         if (state.status == BookListStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(_isEditing ? 'Book updated!' : 'Book added!'))
            );
            Navigator.of(context).pop(); // Navigate back on success
         } else if (state.status == BookListStatus.error) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('Error: ${state.errorMessage}'))
             );
         }
      }

      if (_isEditing) {
        final updatedBook = widget.book!.copyWith(title: title, author: author);
        presenterNotifier.updateBook(updatedBook).then((_) => handleCompletion());
      } else {
        presenterNotifier.addBook(title, author).then((_) => handleCompletion());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the state to react to loading status
    final bookState = ref.watch(bookPresenterProvider);
    final isLoading = bookState.status == BookListStatus.loading;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Book' : 'Add Book'),
      ),
      body: Stack( // Use Stack for loading indicator overlay
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
      ),
    );
  }
}
