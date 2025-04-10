import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import 'book_event.dart';
import 'book_state.dart';

class BookBloc extends Bloc<BookEvent, BookState> {

  BookBloc(this._bookService) : super(BookInitial()) {
    on<LoadBooks>(_onLoadBooks);
    on<AddBook>(_onAddBook);
    on<UpdateBook>(_onUpdateBook);
    on<DeleteBook>(_onDeleteBook);
    on<SelectBook>(_onSelectBook);
  }
  final BookService _bookService;

  Future<void> _onLoadBooks(LoadBooks event, Emitter<BookState> emit) async {
    emit(BookLoading());
    try {
      final List<Book> books = await _bookService.getBooks();
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError('Failed to load books: ${e.toString()}'));
    }
  }

  Future<void> _onAddBook(AddBook event, Emitter<BookState> emit) async {
    // Optionally emit loading state if the operation is long
    // emit(BookLoading());
    try {
      await _bookService.addBook(event.title, event.author);
      // Reload books after adding
      final List<Book> books = await _bookService.getBooks();
      emit(BookOperationSuccess(books, message: 'Book added successfully'));
      // emit(BookLoaded(books)); // Or just emit loaded state
    } catch (e) {
      emit(BookError('Failed to add book: ${e.toString()}'));
      // Optionally reload books even on error to show the current state
      // add(LoadBooks());
    }
  }

  Future<void> _onUpdateBook(UpdateBook event, Emitter<BookState> emit) async {
    // emit(BookLoading());
    try {
      final Book? updatedBook = await _bookService.updateBook(event.book);
      if (updatedBook != null) {
        final List<Book> books = await _bookService.getBooks();
         emit(BookOperationSuccess(books, message: 'Book updated successfully'));
        // emit(BookLoaded(books));
      } else {
         emit(const BookError('Failed to update book: Not found'));
         // add(LoadBooks()); // Reload to show current state
      }
    } catch (e) {
      emit(BookError('Failed to update book: ${e.toString()}'));
      // add(LoadBooks());
    }
  }

  Future<void> _onDeleteBook(DeleteBook event, Emitter<BookState> emit) async {
    // emit(BookLoading());
    try {
      await _bookService.deleteBook(event.id);
      final List<Book> books = await _bookService.getBooks();
      emit(BookOperationSuccess(books, message: 'Book deleted successfully'));
      // emit(BookLoaded(books));
    } catch (e) {
      emit(BookError('Failed to delete book: ${e.toString()}'));
      // add(LoadBooks());
    }
  }

   Future<void> _onSelectBook(SelectBook event, Emitter<BookState> emit) async {
     // Get the current list of books from the state if possible
     List<Book> currentBooks = [];
     if (state is BookLoaded) {
       currentBooks = (state as BookLoaded).books;
     } else if (state is BookOperationSuccess) {
        currentBooks = (state as BookOperationSuccess).books;
     } else if (state is BookSelected) {
        currentBooks = (state as BookSelected).allBooks;
     } else {
       // If the list isn't readily available, load books from the service
       try {
         currentBooks = await _bookService.getBooks();
       } catch (e) {
         emit(BookError("Failed to load books: ${e.toString()}"));
         return; // Exit if loading fails
       }
     }

     if (event.book != null) {
       // Inside this block, event.book is guaranteed non-null
       emit(BookSelected(event.book!, currentBooks));
     } else {
       // If deselecting (event.book is null), go back to the loaded state
       emit(BookLoaded(currentBooks));
     }
   }
}
