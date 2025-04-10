import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/news.dart';
import '../providers.dart'; // Import providers

// 新增新聞頁面 | Add News Page (using Riverpod)
class AddNewsPage extends ConsumerStatefulWidget { // Change to ConsumerStatefulWidget
  const AddNewsPage({super.key});

  @override
  ConsumerState<AddNewsPage> createState() => _AddNewsPageState();
}

class _AddNewsPageState extends ConsumerState<AddNewsPage> { // Add State class
  // Define controllers here
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _authorController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers in initState
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _authorController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers in dispose method
    _titleController.dispose();
    _contentController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { // build method now uses State's context and ref is available via `ref` property
     return Scaffold(
      appBar: AppBar(
        title: const Text('新增新聞 (Riverpod)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController, // Use state's controller
              decoration: const InputDecoration(labelText: '標題'),
            ),
            TextField(
              controller: _contentController, // Use state's controller
              decoration: const InputDecoration(labelText: '內容'),
              maxLines: 3,
            ),
            TextField(
              controller: _authorController, // Use state's controller
              decoration: const InputDecoration(labelText: '作者'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newNews = News(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _titleController.text, // Use state's controller
                  content: _contentController.text, // Use state's controller
                  author: _authorController.text, // Use state's controller
                );
                // Read the notifier and call the addNews method
                ref.read(newsNotifierProvider.notifier).addNews(newNews);
                Navigator.pop(context);
              },
              child: const Text('儲存'),
            ),
          ],
        ),
      ),
    );
  }
}
