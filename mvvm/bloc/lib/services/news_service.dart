import '../model/news.dart';

// 新聞服務 | News Service
class NewsService {
  Future<List<News>> fetchNews() async {
    // 模擬網路調用 | Simulated network call
    await Future.delayed(const Duration(seconds: 1));
    return <News>[
      News(
        id: '1',
        title: '首個Flutter架構展示項目發布',
        content: '這是一個展示不同架構和狀態管理技術的Flutter項目。',
        author: 'Flutter開發者'
      ),
      News(
        id: '2',
        title: 'BLoC狀態管理詳解',
        content: 'BLoC是一種強大的狀態管理模式，適用於複雜的應用程式。',
        author: '技術專家'
      ),
    ];
  }
}
