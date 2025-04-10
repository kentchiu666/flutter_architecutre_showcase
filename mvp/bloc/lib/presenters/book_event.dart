import 'package:equatable/equatable.dart';
import '../models/book.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => <Object?>[];
}

// Event to load all books
class LoadBooks extends BookEvent {}

// Event to add a new book
class AddBook extends BookEvent {

  const AddBook(this.title, this.author);
  final String title;
  final String author;

  @override
  List<Object?> get props => <Object?>[title, author];
}

// Event to update an existing book
class UpdateBook extends BookEvent {

  const UpdateBook(this.book);
  final Book book;

  @override
  List<Object?> get props => <Object?>[book];
}

// Event to delete a book
class DeleteBook extends BookEvent {

  const DeleteBook(this.id);
  final String id;

  @override
  List<Object?> get props => <Object?>[id];
}

// Event to select a book (for detail view, etc.)
class SelectBook extends BookEvent { // Nullable if we want to deselect

  const SelectBook(this.book);
  final Book? book;

   @override
  List<Object?> get props => <Object?>[book];
}
