import 'package:equatable/equatable.dart';
import '../models/book.dart';

abstract class BookState extends Equatable {
  const BookState();

  @override
  List<Object?> get props => <Object?>[];
}

// Initial state
class BookInitial extends BookState {}

// State while loading data
class BookLoading extends BookState {}

// State when books are loaded successfully
class BookLoaded extends BookState {

  const BookLoaded(this.books);
  final List<Book> books;

  @override
  List<Object?> get props => <Object?>[books];
}

// State when a specific book is selected (e.g., for detail view)
class BookSelected extends BookState { // Keep all books available if needed

  const BookSelected(this.selectedBook, this.allBooks);
  final Book selectedBook;
  final List<Book> allBooks;

  @override
  List<Object?> get props => <Object?>[selectedBook, allBooks];
}

// State indicating a successful operation (add, update, delete)
// Often followed by reloading the list, so might transition back to BookLoaded
class BookOperationSuccess extends BookState {

   const BookOperationSuccess(this.books, {this.message = 'Operation successful'});
   final List<Book> books; // Include updated list
   final String message;

   @override
   List<Object?> get props => <Object?>[books, message];
}


// State when an error occurs
class BookError extends BookState {

  const BookError(this.message);
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
