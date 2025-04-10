import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart'; // Assuming GetIt is used for service
import '../model/news.dart';
import '../services/news_service.dart'; // Needed for GetIt
import '../viewmodel/news_view_model.dart';
import 'add_news_page.dart';
import 'news_detail_page.dart';

// 新聞列表頁面 | News List Page (using Provider)
class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use ChangeNotifierProvider to create and provide the ViewModel
    // It will automatically dispose the ViewModel when the widget is removed
    return ChangeNotifierProvider(
      // Create the ViewModel, injecting the service from GetIt
      create: (_) => NewsViewModel(GetIt.instance<NewsService>())..loadNews(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('新聞列表 (Provider)'),
        ),
        // Use a Consumer widget to listen to changes in NewsViewModel
        body: Consumer<NewsViewModel>(
          builder: (BuildContext context, NewsViewModel viewModel, Widget? child) {
            // Build UI based on ViewModel state
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (viewModel.errorMessage != null) {
              return Center(child: Text('錯誤: ${viewModel.errorMessage}'));
            } else if (viewModel.newsList.isEmpty) {
              return const Center(child: Text('沒有新聞'));
            } else {
              return ListView.builder(
                itemCount: viewModel.newsList.length,
                itemBuilder: (BuildContext context, int index) {
                  final News news = viewModel.newsList[index];
                  return ListTile(
                    title: Text(news.title),
                    subtitle: Text(news.author),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => NewsDetailPage(news: news),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Get the ViewModel instance without listening (using context.read)
            // Although AddNewsPage will likely need its own way to access the ViewModel
            // or be wrapped in a Provider itself if it needs to call methods.
            // For simplicity here, just navigate. AddNewsPage will use context.read.
             Navigator.push(
              context,
              MaterialPageRoute(
                // Important: If AddNewsPage needs to *modify* the state via the *same*
                // ViewModel instance, it needs access to it. One way is to pass it,
                // but better is to ensure the Provider is above both routes or use
                // a shared instance (e.g., provided higher up or via GetIt if needed).
                // For this example, we assume AddNewsPage can access the same provider
                // scope or gets its own if needed.
                // A common pattern is providing the ViewModel higher up (e.g., in main.dart
                // using MultiProvider if shared across many screens).
                builder: (BuildContext context) => const AddNewsPage(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
