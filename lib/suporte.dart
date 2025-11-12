import 'package:flutter/material.dart';

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
      body: const Text(
        "1. Como cadastrar meus alimentos?\n"
            "→ Vá até a aba 'Registrar Refeições' e clique em 'Adicionar Alimento', ao final, clique em 'Salvar Refeição'.\n\n"
            "2. Posso alterar minha meta calórica?\n"
            "→ Sim, no menu de Peso e Metas, Atualize as informações desejadas nos campos e logo após Clique em 'Salvar'.",
        style: TextStyle(fontSize: 14),
      ),
    ),
    Item(
      header: "Tutorial de Uso",
      icon: Icons.menu_book_outlined,
      body: const Text(
        "1. Acesse o menu principal.\n"
            "2. O DashBoard na tela inicial mostra o resumo dos macronutrientes já consumidos, e o valor a ser atingido.\n"
            "3. Acesse as principais funções em: '+ Adicionar Refeições', 'Peso e Metas' e 'Calcular IMC', presentes na tela inicial\n"
            "4. Clique no botão 'Resetar Progresso Nutricional', para apagar os dados registrados até o final do dia, ou no momento o qual desejar",
        style: TextStyle(fontSize: 14),
      ),
    ),
    Item(
      header: "Contato com Suporte",
      icon: Icons.headset_mic_outlined,
      body: const Text(
        "Email para suporte: eliasrozal3030@gmail.com\n"
            "Horário de atendimento: 8h às 18h.",
        style: TextStyle(fontSize: 14),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ajuda e Suporte",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _itens.map((item) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ExpansionTile(
                      leading: Icon(item.icon, color: Colors.red),
                      title: Text(
                        item.header,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: item.body,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Logo fixa no final
          Padding(
            padding: const EdgeInsets.symmetric(vertical:16),
            child: Image.asset(
              'assets/images/logo_sem_fundo.png',
              height: 100,
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
