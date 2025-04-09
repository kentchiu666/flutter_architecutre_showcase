import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;

  Book({String? id, required this.title, required this.author})
      : id = id ?? const Uuid().v4();

  @override
  List<Object?> get props => [id, title, author];

  // Optional: Add copyWith method for easier updates
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
}
