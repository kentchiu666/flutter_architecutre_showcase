import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presenters/book_bloc.dart';
import '../presenters/book_event.dart';
import '../services/book_service.dart';
import 'book_list_page.dart'; // We'll create this next

class BookApp extends StatelessWidget {
  const BookApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the BookBloc to the widget tree
    return BlocProvider(
      // Create the BLoC instance and provide the service
      // Also, add the initial event to load books
      create: (context) => BookBloc(RepositoryProvider.of<BookService>(context))
        ..add(LoadBooks()),
      child: MaterialApp(
        title: 'MVP BLoC Books',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const BookListPage(), // Start with the list page
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
