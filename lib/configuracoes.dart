import 'package:flutter/material.dart';


class FitMacroApp extends StatefulWidget {
  const FitMacroApp({super.key});

  @override
  State<FitMacroApp> createState() => _FitMacroAppState();
}

class _FitMacroAppState extends State<FitMacroApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitMacro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      themeMode: _themeMode,
      home: ConfiguracoesPage(onThemeChanged: toggleTheme),
    );
  }
}


// Configurações Da página

class ConfiguracoesPage extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const ConfiguracoesPage({super.key, required this.onThemeChanged});

  @override
  State<ConfiguracoesPage> createState() => _ConfiguracoesPageState();
}

class _ConfiguracoesPageState extends State<ConfiguracoesPage> {
  bool modoEscuro = false;
  String unidade = 'Métrico';
  String idioma = 'Português';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.redAccent),
              child: Center(
                child: Text(
                  'FITMACRO',
                  style: TextStyle(
                    color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Início'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre o FitMacro'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 24),

            // Unidade
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                title: const Text('Unidades'),
                subtitle: Text(unidade),
                trailing: DropdownButton<String>(
                  value: unidade,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'Métrico', child: Text('Métrico')),
                    DropdownMenuItem(value: 'Imperial', child: Text('Imperial')),
                  ],
                  onChanged: (valor) {
                    setState(() => unidade = valor!);
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Aparência
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: SwitchListTile(
                title: const Text('Aparência'),
                subtitle: const Text('Modo escuro'),
                value: modoEscuro,
                activeColor: Colors.red,
                onChanged: (valor) {
                  setState(() => modoEscuro = valor);
                  widget.onThemeChanged(valor);
                },
              ),
            ),

            const SizedBox(height: 12),

            // Idioma
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                title: const Text('Idioma'),
                subtitle: Text(idioma),
                trailing: DropdownButton<String>(
                  value: idioma,
                  underline: const SizedBox(),
                  items: const [
                    DropdownMenuItem(value: 'Português', child: Text('Português')),
                    DropdownMenuItem(value: 'Inglês', child: Text('Inglês')),
                    DropdownMenuItem(value: 'Espanhol', child: Text('Espanhol')),
                  ],
                  onChanged: (valor) {
                    setState(() => idioma = valor!);
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Dados pessoais
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: const ListTile(
                title: Text('Dados pessoais'),
                trailing: Icon(Icons.arrow_forward_ios, size: 18),
              ),
            ),

            const SizedBox(height: 40),

            // Logo FitMacro
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo_sem_fundo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
