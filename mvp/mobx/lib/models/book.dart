import 'package:uuid/uuid.dart';

// Basic Book model. No MobX annotations needed here as it's just data.

class Book {

  Book({String? id, required this.title, required this.author})
      : id = id ?? const Uuid().v4();
  final String id;
  final String title;
  final String author;

  Book copyWith({
    String? id,
    String? title,
    String? author,
  }) => Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
    );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          author == other.author;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ author.hashCode;
}
