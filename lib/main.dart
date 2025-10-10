import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const FitMacroApp());
}

class FitMacroApp extends StatelessWidget {
  const FitMacroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitMacro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: const LoginPage(), // Tela de login sendo chamaada aqui...
    );
  }
}
