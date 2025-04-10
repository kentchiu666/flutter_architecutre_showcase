import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'services/news_service.dart';
import 'view/news_reader_app.dart';
import 'viewmodel/news_bloc.dart';
import 'viewmodel/news_event.dart'; // Import events

void main() {
  final GetIt getIt = GetIt.instance;
  getIt.registerSingleton<NewsService>(NewsService());

  runApp(
    BlocProvider(
      create: (BuildContext context) => NewsBloc(getIt<NewsService>())..add(LoadNewsEvent()),
      child: const NewsReaderApp(),
    ),
  );
}
