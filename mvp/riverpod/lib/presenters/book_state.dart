import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/book.dart';

part 'book_state.freezed.dart'; // Freezed will generate this file

// Enum to represent the loading status
enum BookListStatus { initial, loading, success, error }

@freezed
class BookState with _$BookState {
  const factory BookState({
    @Default([]) List<Book> books,
    @Default(BookListStatus.initial) BookListStatus status,
    Book? selectedBook,
    String? errorMessage,
  }) = _BookState;
}
