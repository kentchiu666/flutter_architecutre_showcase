import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/book_service.dart';
import 'presenters/book_presenter.dart';
import 'presenters/book_state.dart';

// Provider for the BookService instance
// Using a simple Provider as the service itself doesn't change state.
final bookServiceProvider = Provider<BookService>((ref) {
  return BookService();
});

// StateNotifierProvider for the BookPresenter
// It depends on the bookServiceProvider to get the BookService instance.
final bookPresenterProvider = StateNotifierProvider<BookPresenter, BookState>((ref) {
  // Read the BookService instance from its provider
  final bookService = ref.watch(bookServiceProvider);
  // Create and return the BookPresenter, injecting the service
  return BookPresenter(bookService);
});
