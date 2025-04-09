import 'package:equatable/equatable.dart';
import '../models/book.dart';

abstract class BookEvent extends Equatable {
  const BookEvent();

  @override
  List<Object?> get props => [];
}

// Event to load all books
class LoadBooks extends BookEvent {}

// Event to add a new book
class AddBook extends BookEvent {
  final String title;
  final String author;

  const AddBook(this.title, this.author);

  @override
  List<Object?> get props => [title, author];
}

// Event to update an existing book
class UpdateBook extends BookEvent {
  final Book book;

  const UpdateBook(this.book);

  @override
  List<Object?> get props => [book];
}

// Event to delete a book
class DeleteBook extends BookEvent {
  final String id;

  const DeleteBook(this.id);

  @override
  List<Object?> get props => [id];
}

// Event to select a book (for detail view, etc.)
class SelectBook extends BookEvent {
  final Book? book; // Nullable if we want to deselect

  const SelectBook(this.book);

   @override
  List<Object?> get props => [book];
}
