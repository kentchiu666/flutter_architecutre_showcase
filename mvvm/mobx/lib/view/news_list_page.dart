import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../model/news.dart';
import '../store/news_store.dart';
import 'news_detail_page.dart';
import 'add_news_page.dart';

// 新聞列表頁面 | News List Page
class NewsListPage extends StatefulObserverWidget {

  const NewsListPage({super.key, required this.newsStore});
  final NewsStore newsStore;

  @override
  _NewsListPageState createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  @override
  void initState() {
    super.initState();
    widget.newsStore.loadNews();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('新聞列表'),
      ),
      body: widget.newsStore.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: widget.newsStore.newsList.length,
              itemBuilder: (BuildContext context, int index) {
                final news = widget.newsStore.newsList[index];
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AddNewsPage(newsStore: widget.newsStore),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
}
