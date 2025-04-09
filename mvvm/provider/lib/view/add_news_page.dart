import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/news.dart';
import '../viewmodel/news_view_model.dart';

// 新增新聞頁面 | Add News Page (using Provider)
class AddNewsPage extends StatefulWidget { // Use StatefulWidget for Controllers
  const AddNewsPage({super.key});

  @override
  State<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('新增新聞 (Provider)'),
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
                final newNews = News(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text,
                  content: _contentController.text,
                  author: _authorController.text,
                );
                // Use context.read to call the method on the ViewModel
                // This assumes the ChangeNotifierProvider for NewsViewModel is accessible
                // from this route's context (e.g., provided higher up or on the previous screen).
                // If NewsListPage provided it, it might not be directly accessible here
                // without passing the context or using a global provider/locator.
                // For simplicity, we assume it's accessible.
                try {
                   context.read<NewsViewModel>().addNews(newNews);
                   Navigator.pop(context);
                } catch (e) {
                   // Handle error if provider not found (e.g., show a snackbar)
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('無法找到 ViewModel: $e')),
                   );
                }
              },
              child: const Text('儲存'),
            ),
          ],
        ),
      ),
    );
}
