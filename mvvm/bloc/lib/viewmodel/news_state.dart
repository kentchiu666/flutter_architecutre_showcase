import 'package:equatable/equatable.dart';
import '../model/news.dart'; // Assuming news model exists here

// Base class for all news-related states
abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => <Object>[];
}

/// Initial state before any action has been taken.
class NewsInitial extends NewsState {}

/// State indicating that news data is currently being loaded.
class NewsLoading extends NewsState {}

/// State indicating that news data has been successfully loaded.
class NewsLoaded extends NewsState {

  const NewsLoaded(this.newsList);
  final List<News> newsList;

  @override
  List<Object> get props => <Object>[newsList];

  @override
  String toString() => 'NewsLoaded { newsList: ${newsList.length} items }';
}

/// State indicating that an error occurred while loading news data.
class NewsError extends NewsState {

  const NewsError(this.message);
  final String message;

  @override
  List<Object> get props => <Object>[message];

  @override
  String toString() => 'NewsError { message: $message }';
}
