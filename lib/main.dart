import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'login.dart';

void main() async {
  // Garante que tudo está inicializado antes de abrir o banco
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o suporte ao SQLite para desktop (Linux/Windows/macOS)
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const FitMacroApp());
}

class FitMacroApp extends StatelessWidget {
  const FitMacroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitMacro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoginPage(), // Tela inicial do app
    );
  }
}
