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
        title: 'Provider狀態管理詳解', // Changed title for Provider version
        content: 'Provider 是 Flutter 官方推薦的狀態管理解決方案之一，簡單易用。', // Changed content
        author: '技術專家'
      ),
    ];
  }

  // In a real app, you might have methods like:
  // Future<void> addNewsArticle(News news) async { ... }
}
