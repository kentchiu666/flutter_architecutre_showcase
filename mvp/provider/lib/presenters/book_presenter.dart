import 'package:flutter/foundation.dart'; // For ChangeNotifier
import '../models/book.dart';
import '../services/book_service.dart';

// Enum to represent the loading status
enum LoadingStatus { idle, loading, success, error }

class BookPresenter extends ChangeNotifier {

  // Constructor - requires BookService
  BookPresenter(this._bookService) {
    // Optionally load books immediately upon creation
    // loadBooks();
  }
  final BookService _bookService;

  // Internal state variables
  List<Book> _books = <Book>[];
  Book? _selectedBook;
  LoadingStatus _loadingStatus = LoadingStatus.idle;
  String? _errorMessage;

  // Public getters for the state (immutable view)
  List<Book> get books => List.unmodifiable(_books);
  Book? get selectedBook => _selectedBook;
  LoadingStatus get loadingStatus => _loadingStatus;
  String? get errorMessage => _errorMessage;

  // --- Business Logic Methods ---

  Future<void> loadBooks() async {
    _setLoadingStatus(LoadingStatus.loading);
    try {
      _books = await _bookService.getBooks();
      _setLoadingStatus(LoadingStatus.success);
    } catch (e) {
      _setError('Failed to load books: ${e.toString()}');
    }
  }

  Future<void> addBook(String title, String author) async {
    _setLoadingStatus(LoadingStatus.loading); // Indicate loading for the operation
    try {
      await _bookService.addBook(title, author);
      // Reload the list to reflect the addition
      await loadBooks(); // This will set status back to success or error
    } catch (e) {
      _setError('Failed to add book: ${e.toString()}');
      // Optionally reload books even on error to show the current state
      // await loadBooks();
    }
  }

   Future<void> updateBook(Book book) async {
    _setLoadingStatus(LoadingStatus.loading);
    try {
      final Book? updated = await _bookService.updateBook(book);
      if (updated != null) {
         // If the updated book was the selected one, update the selection
         if (_selectedBook?.id == updated.id) {
           _selectedBook = updated;
         }
        await loadBooks(); // Reload list
      } else {
         _setError('Failed to update book: Not found');
         // Optionally reload to ensure consistency if needed
         // await loadBooks();
      }
    } catch (e) {
      _setError('Failed to update book: ${e.toString()}');
      // await loadBooks();
    }
  }

  Future<void> deleteBook(String id) async {
    _setLoadingStatus(LoadingStatus.loading);
    try {
      await _bookService.deleteBook(id);
       // If the deleted book was the selected one, clear selection
       if (_selectedBook?.id == id) {
         _selectedBook = null;
       }
      await loadBooks(); // Reload list
    } catch (e) {
      _setError('Failed to delete book: ${e.toString()}');
      // await loadBooks();
    }
  }

  // Method to select a book (e.g., for detail view)
  void selectBook(Book? book) {
    // No async operation, just update state and notify
    _selectedBook = book;
    notifyListeners();
  }

  // --- Helper methods for state management ---

  void _setLoadingStatus(LoadingStatus status) {
    _loadingStatus = status;
    _errorMessage = null; // Clear error on new status change
    notifyListeners();
  }

  void _setError(String message) {
    _loadingStatus = LoadingStatus.error;
    _errorMessage = message;
    notifyListeners();
  }
}
