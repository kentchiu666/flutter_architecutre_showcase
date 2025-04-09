import 'package:flutter/foundation.dart'; // For ChangeNotifier
import '../model/news.dart';
import '../services/news_service.dart';

class NewsViewModel with ChangeNotifier {

  NewsViewModel(this._newsService);
  final NewsService _newsService;

  bool _isLoading = false;
  List<News> _newsList = <News>[];
  String? _errorMessage;

  // Getters for UI to access state
  bool get isLoading => _isLoading;
  List<News> get newsList => _newsList;
  String? get errorMessage => _errorMessage;

  // Method to load news articles
  Future<void> loadNews() async {
    _isLoading = true;
    _errorMessage = null; // Clear previous error
    notifyListeners(); // Notify UI about loading start

    try {
      _newsList = await _newsService.fetchNews();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI about loading end (success or failure)
    }
  }

  // Method to add a new news article
  void addNews(News news) {
    // In a real app, you might want to call a service method to persist the change.
    // Here, we just update the local state.
    _newsList = List<News>.from(_newsList)..add(news);
    // Optionally clear error if adding is considered a success action
    _errorMessage = null;
    notifyListeners(); // Notify UI about the change
  }
}
