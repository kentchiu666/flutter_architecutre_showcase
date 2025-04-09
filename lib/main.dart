import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Flutter Architecture Showcase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Architecture Showcase'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to MVVM section
              },
              child: const Text('MVVM Architectures'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to MVC section
              },
              child: const Text('MVC Architectures'),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to MVP section
              },
              child: const Text('MVP Architectures'),
            ),
          ],
        ),
      ),
    );
}
