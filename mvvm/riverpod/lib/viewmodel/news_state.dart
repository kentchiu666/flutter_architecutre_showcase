import 'package:flutter/foundation.dart'; // For immutable annotation
import '../model/news.dart';

@immutable // Mark the state as immutable
class NewsState { // Optional error message

  const NewsState({
    this.isLoading = false,
    this.newsList = const <News>[],
    this.errorMessage,
  });
  final bool isLoading;
  final List<News> newsList;
  final String? errorMessage;

  // Helper method to create a copy with updated values
  NewsState copyWith({
    bool? isLoading,
    List<News>? newsList,
    String? errorMessage,
    bool clearError = false, // Flag to explicitly clear error
  }) => NewsState(
      isLoading: isLoading ?? this.isLoading,
      newsList: newsList ?? this.newsList,
      // If clearError is true, set errorMessage to null, otherwise use new or existing value
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );

  // Optional: Override equality and hashCode if not using Equatable
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewsState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          listEquals(newsList, other.newsList) && // Use listEquals for lists
          errorMessage == other.errorMessage;

  @override
  int get hashCode => isLoading.hashCode ^ newsList.hashCode ^ errorMessage.hashCode;

   @override
  String toString() => 'NewsState(isLoading: $isLoading, newsList: ${newsList.length} items, errorMessage: $errorMessage)';
}
