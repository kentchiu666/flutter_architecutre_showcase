import 'package:uuid/uuid.dart';

// Note: Equatable is not strictly necessary when using Provider/ChangeNotifier
// unless you need deep equality checks for other purposes.
// We'll keep it simple for now.

class Book {

  Book({String? id, required this.title, required this.author})
      : id = id ?? const Uuid().v4();
  final String id;
  final String title;
  final String author;

  // Optional: Add copyWith method for easier updates
  Book copyWith({
    String? id,
    String? title,
    String? author,
  }) => Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
    );

  // If not using Equatable, you might override == and hashCode manually
  // if you need to compare Book instances directly (e.g., in Sets or Maps).
  // For this example, direct comparison isn't the primary focus.
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
