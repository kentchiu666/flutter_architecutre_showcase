import 'dart:async';
import '../models/book.dart';
import 'package:uuid/uuid.dart';

// Standard BookService, no Riverpod specifics needed here.

class BookService {
  final List<Book> _books = [
    Book(id: const Uuid().v4(), title: 'The Lord of the Rings', author: 'J.R.R. Tolkien'),
    Book(id: const Uuid().v4(), title: 'Harry Potter and the Sorcerer\'s Stone', author: 'J.K. Rowling'),
    Book(id: const Uuid().v4(), title: 'A Game of Thrones', author: 'George R.R. Martin'),
  ];

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 300));

  Future<List<Book>> getBooks() async {
    await _delay();
    return List<Book>.from(_books);
  }

  Future<Book> addBook(String title, String author) async {
    await _delay();
    final newBook = Book(title: title, author: author);
    _books.add(newBook);
    return newBook;
  }

  Future<Book?> updateBook(Book updatedBook) async {
    await _delay();
    final index = _books.indexWhere((book) => book.id == updatedBook.id);
    if (index != -1) {
      _books[index] = updatedBook;
      return updatedBook;
    }
    return null; // Book not found
  }

  Future<void> deleteBook(String id) async {
    await _delay();
    _books.removeWhere((book) => book.id == id);
  }

  Future<Book?> getBookById(String id) async {
     await _delay();
     try {
       return _books.firstWhere((book) => book.id == id);
     } catch (e) {
       return null; // Not found
     }
  }
}
