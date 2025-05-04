import 'package:flutter/material.dart';
import 'package:word_memory/app/di/dependencies.dart';
import 'package:word_memory/presentation/screens/word_memory_screen.dart';
import 'package:word_memory/presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();
  runApp(const WordMemoryApp());
}

Future<void> _initializeApp() async {
  Dependencies.init();
}

class WordMemoryApp extends StatelessWidget {
  const WordMemoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Word Memory',
      theme: AppTheme.light,
      home: WordMemoryScreen.newInstance(),
    );
  }
}
