// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BookState {
  List<Book> get books => throw _privateConstructorUsedError;
  BookListStatus get status => throw _privateConstructorUsedError;
  Book? get selectedBook => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of BookState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookStateCopyWith<BookState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookStateCopyWith<$Res> {
  factory $BookStateCopyWith(BookState value, $Res Function(BookState) then) =
      _$BookStateCopyWithImpl<$Res, BookState>;
  @useResult
  $Res call(
      {List<Book> books,
      BookListStatus status,
      Book? selectedBook,
      String? errorMessage});
}

/// @nodoc
class _$BookStateCopyWithImpl<$Res, $Val extends BookState>
    implements $BookStateCopyWith<$Res> {
  _$BookStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? books = null,
    Object? status = null,
    Object? selectedBook = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      books: null == books
          ? _value.books
          : books // ignore: cast_nullable_to_non_nullable
              as List<Book>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookListStatus,
      selectedBook: freezed == selectedBook
          ? _value.selectedBook
          : selectedBook // ignore: cast_nullable_to_non_nullable
              as Book?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookStateImplCopyWith<$Res>
    implements $BookStateCopyWith<$Res> {
  factory _$$BookStateImplCopyWith(
          _$BookStateImpl value, $Res Function(_$BookStateImpl) then) =
      __$$BookStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Book> books,
      BookListStatus status,
      Book? selectedBook,
      String? errorMessage});
}

/// @nodoc
class __$$BookStateImplCopyWithImpl<$Res>
    extends _$BookStateCopyWithImpl<$Res, _$BookStateImpl>
    implements _$$BookStateImplCopyWith<$Res> {
  __$$BookStateImplCopyWithImpl(
      _$BookStateImpl _value, $Res Function(_$BookStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? books = null,
    Object? status = null,
    Object? selectedBook = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$BookStateImpl(
      books: null == books
          ? _value._books
          : books // ignore: cast_nullable_to_non_nullable
              as List<Book>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookListStatus,
      selectedBook: freezed == selectedBook
          ? _value.selectedBook
          : selectedBook // ignore: cast_nullable_to_non_nullable
              as Book?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$BookStateImpl implements _BookState {
  const _$BookStateImpl(
      {final List<Book> books = const [],
      this.status = BookListStatus.initial,
      this.selectedBook,
      this.errorMessage})
      : _books = books;

  final List<Book> _books;
  @override
  @JsonKey()
  List<Book> get books {
    if (_books is EqualUnmodifiableListView) return _books;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_books);
  }

  @override
  @JsonKey()
  final BookListStatus status;
  @override
  final Book? selectedBook;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'BookState(books: $books, status: $status, selectedBook: $selectedBook, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookStateImpl &&
            const DeepCollectionEquality().equals(other._books, _books) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.selectedBook, selectedBook) ||
                other.selectedBook == selectedBook) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_books),
      status,
      selectedBook,
      errorMessage);

  /// Create a copy of BookState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookStateImplCopyWith<_$BookStateImpl> get copyWith =>
      __$$BookStateImplCopyWithImpl<_$BookStateImpl>(this, _$identity);
}

abstract class _BookState implements BookState {
  const factory _BookState(
      {final List<Book> books,
      final BookListStatus status,
      final Book? selectedBook,
      final String? errorMessage}) = _$BookStateImpl;

  @override
  List<Book> get books;
  @override
  BookListStatus get status;
  @override
  Book? get selectedBook;
  @override
  String? get errorMessage;

  /// Create a copy of BookState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookStateImplCopyWith<_$BookStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
