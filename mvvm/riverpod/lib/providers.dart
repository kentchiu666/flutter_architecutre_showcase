import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/news_service.dart'; // Assuming service exists
import 'viewmodel/news_notifier.dart'; // Assuming notifier will exist
import 'viewmodel/news_state.dart'; // Assuming state will exist

// Provider for the NewsService instance
final Provider<NewsService> newsServiceProvider = Provider<NewsService>((ProviderRef<NewsService> ref) => NewsService());

// StateNotifierProvider for the NewsNotifier and its state
// We use StateNotifierProvider because NewsNotifier will manage mutable state
final StateNotifierProvider<NewsNotifier, NewsState> newsNotifierProvider = StateNotifierProvider<NewsNotifier, NewsState>((StateNotifierProviderRef<NewsNotifier, NewsState> ref) {
  // The notifier depends on the NewsService, which we get from newsServiceProvider
  final newsService = ref.watch(newsServiceProvider);
  return NewsNotifier(newsService);
});
