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
        useMaterial3: false,
        primaryColor: Colors.red,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const AjudaSuporteScreen(),
    );
  }
}

class AjudaSuporteScreen extends StatefulWidget {
  const AjudaSuporteScreen({super.key});

  @override
  State<AjudaSuporteScreen> createState() => _AjudaSuporteScreenState();
}

class _AjudaSuporteScreenState extends State<AjudaSuporteScreen> {
  final List<Item> _itens = <Item>[
    Item(
      header: "FAQ",
      icon: Icons.help_outline,
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: const Text(
          "1. Como cadastrar meus alimentos?\n"
          "→ Vá até a aba 'Refeições' e clique em 'Adicionar Alimento'.\n\n"
          "2. Posso alterar minha meta calórica?\n"
          "→ Sim, no menu de Peso e Medidas, clique no botão 'Atualizar Informações', e coloque as novas informações, e ao final clique em 'Salvar'.",
          style: TextStyle(fontSize: 14),
        ),
      ),
    ),
    Item(
      header: "Tutorial de Uso",
      icon: Icons.menu_book_outlined,
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: const Text(
          "1. Acesse o menu principal.\n"
          "2. Clique em 'Dashboard' para ver o resumo diário.\n"
          "3. Utilize o gráfico para acompanhar o progresso semanal.",
          style: TextStyle(fontSize: 14),
        ),
      ),
    ),
    Item(
      header: "Contato com Suporte",
      icon: Icons.headset_mic_outlined,
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: const Text(
          "Email 1: eliasrozal3030@gmail.com\n"
          "Email 2: rodrigokamiguchi@gmail.com\n"
          "Horário de atendimento: 8h às 18h.",
          style: TextStyle(fontSize: 14),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Ajuda e Suporte",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold,),
        ),
      ),
      body: Column(
        children: [
          // Conteúdo rolável
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black87),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Menu lateral (em construção)"),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Bem-vindo, Pedro",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.grey[300]),
                    child: ExpansionPanelList.radio(
                      animationDuration: const Duration(milliseconds: 300),
                      expandedHeaderPadding:
                          const EdgeInsets.symmetric(vertical: 6),
                      elevation: 0,
                      children: _itens.map<ExpansionPanelRadio>((Item item) {
                        return ExpansionPanelRadio(
                          canTapOnHeader: true,
                          value: item.header,
                          headerBuilder: (context, isExpanded) {
                            return ListTile(
                              leading: Icon(item.icon, color: Colors.red),
                              title: Text(
                                item.header,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                          body: item.body,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Logo fixa no final
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Image.asset(
              'assets/images/logo_sem_fundo.png',
              height: 120,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class Item {
  Item({
    required this.header,
    required this.icon,
    required this.body,
  });

  String header;
  IconData icon;
  Widget body;
}