import '../model/news.dart';

// 新聞服務 | News Service
class NewsService {
  Future<List<News>> fetchNews() async {
    // 模擬網路調用 | Simulated network call
    await Future.delayed(const Duration(seconds: 1));
    // 使用與其他版本一致的數據，但標題稍作修改以區分
    return <News>[
      News(
        id: '1',
        title: '首個Flutter架構展示項目發布',
        content: '這是一個展示不同架構和狀態管理技術的Flutter項目。',
        author: 'Flutter開發者'
      ),
      News(
        id: '2',
        title: 'Riverpod狀態管理詳解', // Changed title for Riverpod version
        content: 'Riverpod 是一種靈活且強大的 Flutter 狀態管理和依賴注入解決方案。', // Changed content
        author: '技術專家'
      ),
    ];
  }

  // In a real app, you might have methods like:
  // Future<void> addNewsArticle(News news) async { ... }
  // Future<void> updateNewsArticle(News news) async { ... }
  // Future<void> deleteNewsArticle(String id) async { ... }
}
