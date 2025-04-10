import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_mobx_news_reader/model/news.dart';
import 'package:mvvm_mobx_news_reader/service/news_service.dart';
import 'package:mvvm_mobx_news_reader/store/news_store.dart';
import 'package:mvvm_mobx_news_reader/view/news_reader_app.dart';

void main() {
  testWidgets('News Reader App Test', (WidgetTester tester) async {
    // 初始化依賴 | Initialize dependencies
    final NewsService newsService = NewsService();
    final NewsStore newsStore = NewsStore(newsService);

    // 構建應用並觸發渲染 | Build app and trigger rendering
    await tester.pumpWidget(
      NewsReaderApp(newsStore: newsStore),
    );

    // 等待渲染完成 | Wait for rendering
    await tester.pumpAndSettle();

    // 驗證是否顯示新聞列表 | Verify news list is displayed
    expect(find.text('新聞列表'), findsOneWidget);
    expect(find.text('首個Flutter架構展示項目發布'), findsOneWidget);
    expect(find.text('MobX狀態管理詳解'), findsOneWidget);

    // 驗證添加按鈕存在 | Verify add button exists
    expect(find.byIcon(Icons.add), findsOneWidget);

    // 測試添加新聞功能 | Test adding a news item
    final News newNews = News(
      id: '3',
      title: '測試新增新聞',
      content: '這是一個測試新增的新聞項目',
      author: '測試作者'
    );

    newsStore.addNews(newNews);
    await tester.pumpAndSettle();

    expect(find.text('測試新增新聞'), findsOneWidget);
  });
}
