import 'package:uuid/uuid.dart';
import 'package:equatable/equatable.dart'; // Using Equatable for simplicity here

class Book extends Equatable {
  final String id;
  final String title;
  final String author;

  Book({String? id, required this.title, required this.author})
      : id = id ?? const Uuid().v4();

  Book copyWith({
    String? id,
    String? title,
    String? author,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
    );
  }

  @override
  List<Object?> get props => [id, title, author];
}
