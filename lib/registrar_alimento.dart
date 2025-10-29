import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'database_helper.dart';

class AlimentoItem {
  final String nome;
  final double proteina;
  final double carboidrato;
  final double gordura;
  final double kcal;

  AlimentoItem({
    required this.nome,
    required this.proteina,
    required this.carboidrato,
    required this.gordura,
    required this.kcal,
  });

  factory AlimentoItem.fromJson(Map<String, dynamic> json) {
    return AlimentoItem(
      nome: json['nome'],
      proteina: (json['proteina'] as num).toDouble(),
      carboidrato: (json['carboidrato'] as num).toDouble(),
      gordura: (json['gordura'] as num).toDouble(),
      kcal: (json['kcal'] as num).toDouble(),
    );
  }
}

class RegistrarAlimentoPage extends StatefulWidget {
  const RegistrarAlimentoPage({super.key});

  @override
  State<RegistrarAlimentoPage> createState() => _RegistrarAlimentoPageState();
}

class _RegistrarAlimentoPageState extends State<RegistrarAlimentoPage> {
  List<AlimentoItem> alimentos = [];
  AlimentoItem? alimentoSelecionado;
  final TextEditingController quantidadeController = TextEditingController();
  final dbHelper = DatabaseHelper.instance;

  List<Map<String, dynamic>> refeicao = [];

  @override
  void initState() {
    super.initState();
    carregarAlimentos();
  }

  Future<void> carregarAlimentos() async {
    final String response = await rootBundle.loadString('assets/data/alimentos.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      alimentos = data.map((item) => AlimentoItem.fromJson(item)).toList();
    });
  }

  void adicionarAlimento() {
    if (alimentoSelecionado == null || quantidadeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um alimento e informe a quantidade')),
      );
      return;
    }

    final double quantidade = double.tryParse(quantidadeController.text) ?? 0;
    if (quantidade <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe uma quantidade válida')),
      );
      return;
    }

    final proteinaTotal = alimentoSelecionado!.proteina * quantidade / 100;
    final carboidratoTotal = alimentoSelecionado!.carboidrato * quantidade / 100;
    final gorduraTotal = alimentoSelecionado!.gordura * quantidade / 100;
    final kcalTotal = alimentoSelecionado!.kcal * quantidade / 100;

    setState(() {
      refeicao.add({
        'nome': alimentoSelecionado!.nome,
        'quantidade': quantidade,
        'proteina': proteinaTotal,
        'carboidrato': carboidratoTotal,
        'gordura': gorduraTotal,
        'kcal': kcalTotal,
      });
      alimentoSelecionado = null;
      quantidadeController.clear();
    });
  }

  Future<void> salvarRefeicao() async {
    if (refeicao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Adicione pelo menos um alimento antes de salvar')),
      );
      return;
    }

    try {
      // Dispara todos os inserts em paralelo
      List<Future> insercoes = refeicao.map((item) {
        final dados = {
          'nome': item['nome'],
          'quantidade': item['quantidade'],
          'total_kcal': item['kcal'],
          'total_proteina': item['proteina'],
          'total_carboidrato': item['carboidrato'],
          'total_gordura': item['gordura'],
        };
        return dbHelper.insertRefeicao(dados);
      }).toList();

      await Future.wait(insercoes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Refeição salva com sucesso!')),
      );

      setState(() {
        refeicao.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar refeição: $e')),
      );
    }
  }

  void removerAlimento(int index) {
    setState(() {
      refeicao.removeAt(index);
    });
  }

  void calcularTotais() {
    double proteinaTotal = 0;
    double carboidratoTotal = 0;
    double gorduraTotal = 0;
    double kcalTotal = 0;

    for (var item in refeicao) {
      proteinaTotal += item['proteina'];
      carboidratoTotal += item['carboidrato'];
      gorduraTotal += item['gordura'];
      kcalTotal += item['kcal'];
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Totais da Refeição 🍽️'),
        content: Text(
          'Proteína: ${proteinaTotal.toStringAsFixed(2)}g\n'
          'Carboidrato: ${carboidratoTotal.toStringAsFixed(2)}g\n'
          'Gordura: ${gorduraTotal.toStringAsFixed(2)}g\n'
          'Calorias: ${kcalTotal.toStringAsFixed(2)} kcal',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Alimentos'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: alimentos.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  DropdownButton<AlimentoItem>(
                    isExpanded: true,
                    hint: const Text('Selecione um alimento'),
                    value: alimentoSelecionado,
                    onChanged: (AlimentoItem? novoAlimento) {
                      setState(() {
                        alimentoSelecionado = novoAlimento;
                      });
                    },
                    items: alimentos.map((alimento) {
                      return DropdownMenuItem(
                        value: alimento,
                        child: Text(alimento.nome),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: quantidadeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Quantidade (gramas)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.scale),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: adicionarAlimento,
                    icon: const Icon(Icons.add, color: Colors.black),
                    label: const Text(
                      'Adicionar Alimento',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: refeicao.isEmpty
                        ? const Center(child: Text('Nenhum alimento adicionado ainda'))
                        : ListView.builder(
                            itemCount: refeicao.length,
                            itemBuilder: (context, index) {
                              final item = refeicao[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(item['nome']),
                                  subtitle: Text(
                                    '${item['quantidade']}g • ${item['kcal'].toStringAsFixed(1)} kcal',
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => removerAlimento(index),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: salvarRefeicao,
                    child: const Text(
                      'Salvar Refeição',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
