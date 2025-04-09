import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart'; // Import providers
import '../viewmodel/news_state.dart'; // Explicitly import NewsState
import 'add_news_page.dart';
import 'news_detail_page.dart';

// 新聞列表頁面 | News List Page (using Riverpod)
class NewsListPage extends ConsumerStatefulWidget { // Changed to ConsumerStatefulWidget
  const NewsListPage({super.key});

  @override
  ConsumerState<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends ConsumerState<NewsListPage> { // Changed to ConsumerState
  @override
  void initState() {
    super.initState();
    // Trigger loading news when the page initializes using ref
    // Use addPostFrameCallback to ensure ref is available after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
       ref.read(newsNotifierProvider.notifier).loadNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the newsNotifierProvider to get the current state and rebuild on change
    final NewsState newsState = ref.watch(newsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('新聞列表 (Riverpod)'), // Added identifier
      ),
      body: _buildBody(newsState), // Use helper method for body
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddNewsPage. Riverpod handles provider access internally.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AddNewsPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Helper method to build the body based on the state
  Widget _buildBody(NewsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state.errorMessage != null) {
      return Center(child: Text('錯誤: ${state.errorMessage}'));
    } else if (state.newsList.isEmpty) {
      return const Center(child: Text('沒有新聞'));
    } else {
      return ListView.builder(
        itemCount: state.newsList.length,
        itemBuilder: (BuildContext context, int index) {
          final news = state.newsList[index];
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
  }
}
