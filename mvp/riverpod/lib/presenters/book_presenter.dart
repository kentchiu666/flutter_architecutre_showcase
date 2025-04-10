import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import 'book_state.dart'; // Import the Freezed state class

// The Presenter class, extending StateNotifier with our BookState
class BookPresenter extends StateNotifier<BookState> {
  final BookService _bookService;

  // Constructor: initialize with an initial state and the service dependency
  BookPresenter(this._bookService) : super(const BookState()) {
    // Load books immediately when the presenter is created
    loadBooks();
  }

  // Method to load books from the service
  Future<void> loadBooks() async {
    // Update state to loading
    state = state.copyWith(status: BookListStatus.loading, errorMessage: null);
    try {
      final books = await _bookService.getBooks();
      // Update state with loaded books and success status
      state = state.copyWith(books: books, status: BookListStatus.success);
    } catch (e) {
      // Update state with error message and error status
      state = state.copyWith(
          status: BookListStatus.error,
          errorMessage: "Failed to load books: ${e.toString()}");
    }
  }

  // Method to add a book
  Future<void> addBook(String title, String author) async {
    state = state.copyWith(status: BookListStatus.loading, errorMessage: null);
    try {
      await _bookService.addBook(title, author);
      // Reload the list to reflect the addition
      await loadBooks(); // This will update the state again
    } catch (e) {
      state = state.copyWith(
          status: BookListStatus.error,
          errorMessage: "Failed to add book: ${e.toString()}");
      // Optionally reload books even on error
      // await loadBooks();
    }
  }

  // Method to update a book
  Future<void> updateBook(Book book) async {
    state = state.copyWith(status: BookListStatus.loading, errorMessage: null);
    try {
      final updated = await _bookService.updateBook(book);
      if (updated != null) {
        await loadBooks(); // Reload list, which updates state
         // If the updated book was the selected one, update the selection in the state
         if (state.selectedBook?.id == updated.id) {
           state = state.copyWith(selectedBook: updated);
         }
      } else {
        state = state.copyWith(
            status: BookListStatus.error,
            errorMessage: "Failed to update book: Not found");
      }
    } catch (e) {
      state = state.copyWith(
          status: BookListStatus.error,
          errorMessage: "Failed to update book: ${e.toString()}");
    }
  }

  // Method to delete a book
  Future<void> deleteBook(String id) async {
    state = state.copyWith(status: BookListStatus.loading, errorMessage: null);
    try {
      await _bookService.deleteBook(id);
       // Clear selection if the deleted book was selected
       Book? newSelectedBook = state.selectedBook;
       if (state.selectedBook?.id == id) {
         newSelectedBook = null;
       }
      await loadBooks(); // Reload list
      // Restore selection state if it wasn't the deleted book
      state = state.copyWith(selectedBook: newSelectedBook);

    } catch (e) {
      state = state.copyWith(
          status: BookListStatus.error,
          errorMessage: "Failed to delete book: ${e.toString()}");
    }
  }

  // Method to select a book
  void selectBook(Book? book) {
    // Simply update the selectedBook part of the state
    state = state.copyWith(selectedBook: book);
  }
}
