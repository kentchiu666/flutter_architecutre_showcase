import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'views/book_app.dart'; // Import the BookApp widget

void main() {
  runApp(
    // Wrap the entire application with ProviderScope
    // This allows widgets to read providers.
    const ProviderScope(
      child: BookApp(),
    ),
  );
}
