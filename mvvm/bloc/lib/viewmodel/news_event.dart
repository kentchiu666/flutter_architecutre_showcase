import 'package:equatable/equatable.dart';
import '../model/news.dart'; // Assuming news model exists here

// Base class for all news-related events
abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => <Object>[];
}

/// Event triggered to load the list of news articles.
class LoadNewsEvent extends NewsEvent {}

/// Event triggered to add a new news article.
class AddNewsEvent extends NewsEvent {

  const AddNewsEvent(this.news);
  final News news;

  @override
  List<Object> get props => <Object>[news];

  @override
  String toString() => 'AddNewsEvent { news: $news }';
}
