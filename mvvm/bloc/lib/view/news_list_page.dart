import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/news.dart';
import '../viewmodel/news_bloc.dart';
import '../viewmodel/news_event.dart'; // Import events
import '../viewmodel/news_state.dart'; // Import states
import 'add_news_page.dart';
import 'news_detail_page.dart';

// 新聞列表頁面 | News List Page
class NewsListPage extends StatefulWidget { // Change to StatefulWidget
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> { // Add State class
  @override
  void initState() {
    super.initState();
    // Trigger loading news when the page initializes
    context.read<NewsBloc>().add(LoadNewsEvent());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('新聞列表'),
      ),
      body: BlocBuilder<NewsBloc, NewsState>( // Use correct state types
        builder: (BuildContext context, NewsState state) {
          if (state is NewsLoading) { // Use correct state type
            return const Center(child: CircularProgressIndicator());
          } else if (state is NewsLoaded) { // Use correct state type
            return ListView.builder(
              itemCount: state.newsList.length, // Use correct property name
              itemBuilder: (BuildContext context, int index) {
                final News news = state.newsList[index]; // Use correct property name
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
          } else if (state is NewsError) { // Use correct state type
            return Center(child: Text(state.message)); // Use correct property name
          } else if (state is NewsInitial) {
             // Optionally handle initial state, e.g., show a message
             return const Center(child: Text('點擊按鈕加載新聞'));
          }
          // Fallback for any other unhandled state
          return const Center(child: Text('未知狀態'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Pass the Bloc instance to AddNewsPage
          // Note: This assumes AddNewsPage expects a NewsBloc.
          // We get the bloc instance from the context where BlocProvider is located.
          Navigator.push(
            context,
            MaterialPageRoute(
              // Pass the bloc from the current context to the new page
              builder: (_) => BlocProvider.value(
                 value: BlocProvider.of<NewsBloc>(context),
                 child: const AddNewsPage(),
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
}
