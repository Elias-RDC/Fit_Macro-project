import 'package:flutter/material.dart';

void main() {
  runApp(FitMacroApp());
}

class FitMacroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitMacro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: SobrePage(),
    );
  }
}

class SobrePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
                  'Sobre',
                ),
        backgroundColor: Colors.red,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                // LOGO
                Image.asset('assets/images/logo_sem_fundo.png', height: 120,),

                SizedBox(height: 20),
                
                // SUBTÍTULO
                Text(
                  'Informações do app',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 15),
                
                // DESCRIÇÃO
                Text(
                  'O FitMacro é um aplicativo projetado para auxiliar no acompanhamento nutricional e na contagem de macronutrientes.',
                  style: TextStyle(fontSize: 16, height: 1.5, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 30),
                
                // VERSÃO
                Text(
                  'Versão',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '1.0.0',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

                SizedBox(height: 30),

                // CRÉDITOS
                Text(
                  'Créditos',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Elias Rozal de Carvalho\nRodrigo Guilherme Braga Kamiguchi',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 110),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
