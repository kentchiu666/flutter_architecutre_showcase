import 'package:bloc/bloc.dart';
import '../model/news.dart';
import '../services/news_service.dart'; // Assuming service exists here
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> { // Internal cache for adding news

  NewsBloc(this._newsService) : super(NewsInitial()) {
    on<LoadNewsEvent>(_onLoadNews);
    on<AddNewsEvent>(_onAddNews);
  }
  final NewsService _newsService;
  List<News> _currentNewsList = <News>[];

  Future<void> _onLoadNews(
      LoadNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final List<News> news = await _newsService.fetchNews();
      _currentNewsList = List.from(news); // Update internal cache
      emit(NewsLoaded(_currentNewsList));
    } catch (e) {
      emit(NewsError('Failed to load news: ${e.toString()}'));
    }
  }

  void _onAddNews(AddNewsEvent event, Emitter<NewsState> emit) {
    // In a real app, you might want to persist this change via the service
    // For this example, we just update the local list and emit the new state.

    // Ensure we are operating on the current list if already loaded
    if (state is NewsLoaded || _currentNewsList.isNotEmpty) {
       _currentNewsList = List.from(_currentNewsList)..add(event.news);
       emit(NewsLoaded(_currentNewsList));
    } else {
       // Handle case where news hasn't been loaded yet?
       // Option 1: Ignore add if not loaded
       // Option 2: Add to an empty list (might be unexpected)
       // Option 3: Emit an error or specific state
       // For simplicity, let's just add it to the potentially empty list
       _currentNewsList = List.from(_currentNewsList)..add(event.news);
       // We might want to emit NewsLoaded even if the initial load hasn't happened,
       // or perhaps a different state indicating "added but not fully loaded".
       // Let's emit NewsLoaded for consistency with the MobX version's behavior.
       emit(NewsLoaded(_currentNewsList));
    }
     // Note: A more robust implementation might handle the 'state' more carefully,
     // especially if adding news should trigger a reload or interact differently
     // depending on whether the initial list was loaded successfully.
  }
}
