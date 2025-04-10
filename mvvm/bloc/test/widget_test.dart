import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:mvvm_bloc_news_reader/services/news_service.dart';
import 'package:mvvm_bloc_news_reader/viewmodel/news_bloc.dart';
import 'package:mvvm_bloc_news_reader/viewmodel/news_event.dart'; // Import events
import 'package:mvvm_bloc_news_reader/view/news_reader_app.dart';

void main() {
  testWidgets('News Reader App Test', (WidgetTester tester) async {
    // 初始化依賴注入 | Initialize dependency injection
    final GetIt getIt = GetIt.instance;
    getIt.registerSingleton<NewsService>(NewsService());

    // 構建應用並觸發渲染 | Build app and trigger rendering
    await tester.pumpWidget(
      BlocProvider(
        create: (BuildContext context) => NewsBloc(getIt<NewsService>())..add(LoadNewsEvent()),
        child: const NewsReaderApp(),
      ),
    );

    // 等待渲染完成 | Wait for rendering
    await tester.pumpAndSettle();

    // 驗證是否顯示新聞列表 | Verify news list is displayed
    expect(find.text('新聞列表'), findsOneWidget);
    expect(find.text('首個Flutter架構展示項目發布'), findsOneWidget);
    expect(find.text('BLoC狀態管理詳解'), findsOneWidget);

    // 驗證添加按鈕存在 | Verify add button exists
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
