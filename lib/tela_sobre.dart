import 'package:flutter/material.dart';

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
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TelaSobre(),
    );
  }
}

class TelaSobre extends StatelessWidget {
  const TelaSobre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bem-vindo, Pedro',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // LOGO
                Image.asset(
                  'assets/images/logo_sem_fundo.png',
                  height: 120,
                ),
                const SizedBox(height: 20),
                // TÍTULO
                const Text(
                  'Sobre o FitMacro',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // SUBTÍTULO
                const Text(
                  'Informações do app',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                // DESCRIÇÃO
                const Text(
                  'O FitMacro é um aplicativo projetado para auxiliar no acompanhamento nutricional e na contagem de macronutrientes.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                // VERSÃO
                const Text(
                  'Versão',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  '1.0.0',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 30),
                // CRÉDITOS
                const Text(
                  'Créditos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Elias Rozal de Carvalho\nRodrigo Guilherme Braga Kamiguchi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
