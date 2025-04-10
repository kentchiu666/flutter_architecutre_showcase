import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/news.dart';
import '../services/news_service.dart';
import 'news_state.dart';

class NewsNotifier extends StateNotifier<NewsState> {

  // Initialize the state with default values
  NewsNotifier(this._newsService) : super(const NewsState());
  final NewsService _newsService;

  // Method to load news articles
  Future<void> loadNews() async {
    // Set loading state and clear previous error
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final news = await _newsService.fetchNews();
      // Update state with loaded news and set loading to false
      state = state.copyWith(isLoading: false, newsList: news);
    } catch (e) {
      // Update state with error message and set loading to false
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // Method to add a new news article
  void addNews(News news) {
    // In a real app, you might want to call a service method to persist the change.
    // Here, we just update the local state.

    // Create a new list with the added news
    final updatedList = List<News>.from(state.newsList)..add(news);
    // Update the state with the new list
    // Keep isLoading and errorMessage as they were (or clear error if desired)
    state = state.copyWith(newsList: updatedList);
  }
}
