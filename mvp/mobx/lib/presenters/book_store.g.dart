// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$BookStore on _BookStore, Store {
  late final _$booksAtom = Atom(name: '_BookStore.books', context: context);

  @override
  ObservableList<Book> get books {
    _$booksAtom.reportRead();
    return super.books;
  }

  @override
  set books(ObservableList<Book> value) {
    _$booksAtom.reportWrite(value, super.books, () {
      super.books = value;
    });
  }

  late final _$selectedBookAtom =
      Atom(name: '_BookStore.selectedBook', context: context);

  @override
  Book? get selectedBook {
    _$selectedBookAtom.reportRead();
    return super.selectedBook;
  }

  @override
  set selectedBook(Book? value) {
    _$selectedBookAtom.reportWrite(value, super.selectedBook, () {
      super.selectedBook = value;
    });
  }

  late final _$loadingStatusAtom =
      Atom(name: '_BookStore.loadingStatus', context: context);

  @override
  LoadingStatus get loadingStatus {
    _$loadingStatusAtom.reportRead();
    return super.loadingStatus;
  }

  @override
  set loadingStatus(LoadingStatus value) {
    _$loadingStatusAtom.reportWrite(value, super.loadingStatus, () {
      super.loadingStatus = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_BookStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$loadBooksAsyncAction =
      AsyncAction('_BookStore.loadBooks', context: context);

  @override
  Future<void> loadBooks() {
    return _$loadBooksAsyncAction.run(() => super.loadBooks());
  }

  late final _$addBookAsyncAction =
      AsyncAction('_BookStore.addBook', context: context);

  @override
  Future<void> addBook(String title, String author) {
    return _$addBookAsyncAction.run(() => super.addBook(title, author));
  }

  late final _$updateBookAsyncAction =
      AsyncAction('_BookStore.updateBook', context: context);

  @override
  Future<void> updateBook(Book book) {
    return _$updateBookAsyncAction.run(() => super.updateBook(book));
  }

  late final _$deleteBookAsyncAction =
      AsyncAction('_BookStore.deleteBook', context: context);

  @override
  Future<void> deleteBook(String id) {
    return _$deleteBookAsyncAction.run(() => super.deleteBook(id));
  }

  late final _$_BookStoreActionController =
      ActionController(name: '_BookStore', context: context);

  @override
  void selectBookAction(Book? book) {
    final _$actionInfo = _$_BookStoreActionController.startAction(
        name: '_BookStore.selectBookAction');
    try {
      return super.selectBookAction(book);
    } finally {
      _$_BookStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
books: ${books},
selectedBook: ${selectedBook},
loadingStatus: ${loadingStatus},
errorMessage: ${errorMessage}
    ''';
  }
}
