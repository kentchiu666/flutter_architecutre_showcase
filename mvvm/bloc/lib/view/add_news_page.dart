import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/news.dart';
import '../viewmodel/news_bloc.dart';
import '../viewmodel/news_event.dart'; // Import events

// 新增新聞頁面 | Add News Page
class AddNewsPage extends StatefulWidget {
  const AddNewsPage({super.key});

  @override
  _AddNewsPageState createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('新增新聞'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: '標題'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: '內容'),
              maxLines: 3,
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: '作者'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final News newNews = News(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text,
                  content: _contentController.text,
                  author: _authorController.text,
                );
                context.read<NewsBloc>().add(AddNewsEvent(newNews));
                Navigator.pop(context);
              },
              child: const Text('儲存'),
            ),
          ],
        ),
      ),
    );

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    super.dispose();
  }
}
