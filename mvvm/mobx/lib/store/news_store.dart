import 'package:mobx/mobx.dart';
import '../model/news.dart';
import '../service/news_service.dart';

part 'news_store.g.dart';

// 新聞 Store | News Store
class NewsStore = _NewsStore with _$NewsStore;

abstract class _NewsStore with Store {

  _NewsStore(this._newsService);
  final NewsService _newsService;

  @observable
  ObservableList<News> newsList = ObservableList<News>();

  @observable
  bool isLoading = false;

  @action
  Future<void> loadNews() async {
    isLoading = true;
    try {
      final news = await _newsService.fetchNews();
      newsList.clear();
      newsList.addAll(news);
    } catch (e) {
      // 錯誤處理 | Error handling
    } finally {
      isLoading = false;
    }
  }

  @action
  void addNews(News news) {
    newsList.add(news);
  }
}
