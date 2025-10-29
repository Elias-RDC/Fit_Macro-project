import 'package:flutter/material.dart';
import 'database_helper.dart';

class PesoMedidasPage extends StatefulWidget {
  const PesoMedidasPage({super.key});

  @override
  State<PesoMedidasPage> createState() => _PesoMedidasPageState();
}

class _PesoMedidasPageState extends State<PesoMedidasPage> {
  final dbHelper = DatabaseHelper.instance;

  String metaSelecionada = "Bulking";

  final TextEditingController pesoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController caloriasController = TextEditingController();
  final TextEditingController proteinasController = TextEditingController();
  final TextEditingController carboidratosController = TextEditingController();
  final TextEditingController gordurasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      Map<String, dynamic>? dados = await dbHelper.getPeso(metaSelecionada);
      if (dados != null && dados.isNotEmpty) {
        setState(() {
          pesoController.text = (dados['peso'] ?? 0).toString();
          alturaController.text = (dados['altura'] ?? 0).toString();
          caloriasController.text = (dados['meta_calorias'] ?? 0).toString();
          proteinasController.text = (dados['meta_proteinas'] ?? 0).toString();
          carboidratosController.text = (dados['meta_carboidratos'] ?? 0).toString();
          gordurasController.text = (dados['meta_gorduras'] ?? 0).toString();
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados de peso e medidas: $e');
    }
  }

  Future<void> _salvarDados() async {
    double peso = double.tryParse(pesoController.text) ?? 0;
    double altura = double.tryParse(alturaController.text) ?? 0;
    double metaCalorias = double.tryParse(caloriasController.text) ?? 0;
    double metaProteinas = double.tryParse(proteinasController.text) ?? 0;
    double metaCarboidratos = double.tryParse(carboidratosController.text) ?? 0;
    double metaGorduras = double.tryParse(gordurasController.text) ?? 0;

    Map<String, dynamic> dados = {
      'meta': metaSelecionada,
      'peso': peso,
      'altura': altura,
      'meta_calorias': metaCalorias,
      'meta_proteinas': metaProteinas,
      'meta_carboidratos': metaCarboidratos,
      'meta_gorduras': metaGorduras,
    };

    try {
      await dbHelper.insertOrUpdatePesoMedidas(dados);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dados salvos com sucesso!')),
        );
      }
    } catch (e) {
      debugPrint('Erro ao salvar dados: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar os dados.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesos e Metas'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: metaSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Meta',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Bulking', child: Text('Bulking')),
                  DropdownMenuItem(value: 'Cutting', child: Text('Cutting')),
                  DropdownMenuItem(value: 'Manutenção', child: Text('Manutenção')),
                ],
                onChanged: (valor) {
                  setState(() {
                    metaSelecionada = valor!;
                  });
                  _carregarDados();
                },
              ),
              const SizedBox(height: 20),
              TextField(
                controller: pesoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: alturaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Altura (cm)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: caloriasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Meta de calorias (kcal)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: proteinasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Meta de proteínas (g)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: carboidratosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Meta de carboidratos (g)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: gordurasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Meta de gorduras (g)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
             SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                onPressed: _salvarDados,
                icon: const Icon(Icons.save, color: Colors.black), // ícone branco
                label: const Text('Salvar',
                style: TextStyle(color: Colors.black), // texto branco
              ),
                style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
                backgroundColor: Colors.red,
                foregroundColor: Colors.black,
    ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}
