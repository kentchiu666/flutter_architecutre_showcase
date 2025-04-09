import 'package:equatable/equatable.dart';
import '../models/book.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => [];
}

// Initial state
class BookInitial extends BookState {}

// State while loading data
class BookLoading extends BookState {}

// State when books are loaded successfully
class BookLoaded extends BookState {
  final List<Book> books;

  const BookLoaded(this.books);

  @override
  List<Object?> get props => [books];
}

// State when a specific book is selected (e.g., for detail view)
class BookSelected extends BookState {
  final Book selectedBook;
  final List<Book> allBooks; // Keep all books available if needed

  const BookSelected(this.selectedBook, this.allBooks);

  @override
  List<Object?> get props => [selectedBook, allBooks];
}

// State indicating a successful operation (add, update, delete)
// Often followed by reloading the list, so might transition back to BookLoaded
class BookOperationSuccess extends BookState {
   final List<Book> books; // Include updated list
   final String message;

   const BookOperationSuccess(this.books, {this.message = 'Operation successful'});

   @override
   List<Object?> get props => [books, message];
}


// State when an error occurs
class BookError extends BookState {
  final String message;

  const BookError(this.message);

  @override
  List<Object?> get props => [message];
}
