import 'package:mobx/mobx.dart';
import '../models/book.dart';
import '../services/book_service.dart';

// Include generated file
part 'book_store.g.dart';

// Create Store class
class BookStore = _BookStore with _$BookStore;

// Abstract class for the store
abstract class _BookStore with Store {

  _BookStore(this._bookService) {
    // Load books when the store is created
    loadBooks();
  }
  final BookService _bookService;

  // --- Observables (State) ---

  @observable
  ObservableList<Book> books = ObservableList<Book>();

  @observable
  Book? selectedBook;

  // Using an enum for loading status
  @observable
  LoadingStatus loadingStatus = LoadingStatus.idle;

  @observable
  String? errorMessage;

  // --- Actions (Methods that modify state) ---

  @action
  Future<void> loadBooks() async {
    loadingStatus = LoadingStatus.loading;
    errorMessage = null;
    try {
      final List<Book> fetchedBooks = await _bookService.getBooks();
      // Replace the contents of the observable list
      books.clear();
      books.addAll(fetchedBooks);
      loadingStatus = LoadingStatus.success;
    } catch (e) {
      errorMessage = 'Failed to load books: ${e.toString()}';
      loadingStatus = LoadingStatus.error;
    }
  }

  @action
  Future<void> addBook(String title, String author) async {
    loadingStatus = LoadingStatus.loading; // Indicate loading for the operation
    errorMessage = null;
    try {
      final Book newBook = await _bookService.addBook(title, author);
      // Add to the observable list directly
      books.add(newBook);
      loadingStatus = LoadingStatus.success; // Or reload list if preferred
      // await loadBooks(); // Alternative: reload the whole list
    } catch (e) {
      errorMessage = 'Failed to add book: ${e.toString()}';
      loadingStatus = LoadingStatus.error;
    }
  }

  @action
  Future<void> updateBook(Book book) async {
    loadingStatus = LoadingStatus.loading;
    errorMessage = null;
    try {
      final Book? updatedBook = await _bookService.updateBook(book);
      if (updatedBook != null) {
        // Find and replace in the observable list
        final int index = books.indexWhere((Book b) => b.id == updatedBook.id);
        if (index != -1) {
          books[index] = updatedBook;
        }
        // Update selected book if it was the one being edited
        if (selectedBook?.id == updatedBook.id) {
          selectedBook = updatedBook;
        }
        loadingStatus = LoadingStatus.success;
      } else {
        errorMessage = 'Failed to update book: Not found';
        loadingStatus = LoadingStatus.error;
      }
    } catch (e) {
      errorMessage = 'Failed to update book: ${e.toString()}';
      loadingStatus = LoadingStatus.error;
    }
  }

  @action
  Future<void> deleteBook(String id) async {
    loadingStatus = LoadingStatus.loading;
    errorMessage = null;
    try {
      await _bookService.deleteBook(id);
      // Remove from the observable list
      books.removeWhere((Book book) => book.id == id);
      // Clear selection if the deleted book was selected
      if (selectedBook?.id == id) {
        selectedBook = null;
      }
      loadingStatus = LoadingStatus.success;
    } catch (e) {
      errorMessage = 'Failed to delete book: ${e.toString()}';
      loadingStatus = LoadingStatus.error;
    }
  }

  @action
  void selectBookAction(Book? book) {
    // Simple state change, no async needed
    selectedBook = book;
  }
}

// Enum for loading status (can be defined here or in a separate file)
enum LoadingStatus { idle, loading, success, error }
