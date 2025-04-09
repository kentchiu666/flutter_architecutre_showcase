// 新聞模型 | News Model
class News {

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? '',
    );
  final String id;
  final String title;
  final String content;
  final String author;
}
