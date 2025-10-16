import 'package:flutter/material.dart';
import '../database_helper.dart';

class PesoMedidasPage extends StatefulWidget {
  const PesoMedidasPage({super.key});

  @override
  State<PesoMedidasPage> createState() => _PesoMedidasPageState();
}

class _PesoMedidasPageState extends State<PesoMedidasPage> {
  final alturaController = TextEditingController();
  final pesoController = TextEditingController();
  final caloriasController = TextEditingController();
  final proteinasController = TextEditingController();
  final gordurasController = TextEditingController();
  final carboidratosController = TextEditingController();

  String metaSelecionada = "Bulking";
  final dbHelper = DatabaseHelper.instance;
  Meta? metaAtual;

  @override
  void initState() {
    super.initState();
    _carregarMeta();
  }

  Future<void> _carregarMeta() async {
    final meta = await dbHelper.getLastMeta();
    if (meta != null) {
      setState(() {
        metaAtual = meta;
        alturaController.text = meta.altura.toString();
        pesoController.text = meta.peso.toString();
        caloriasController.text = meta.calorias.toString();
        proteinasController.text = meta.proteinas.toString();
        gordurasController.text = meta.gorduras.toString();
        carboidratosController.text = meta.carboidratos.toString();
        metaSelecionada = meta.tipoMeta;
      });
    } else {
      // valores padrão
      alturaController.text = "1.80";
      pesoController.text = "77.5";
      caloriasController.text = "2000";
      proteinasController.text = "150";
      gordurasController.text = "50";
      carboidratosController.text = "200";
      metaSelecionada = "Bulking";
    }
  }

  Future<void> _salvarMeta() async {
    final novaMeta = Meta(
      id: metaAtual?.id,
      calorias: int.tryParse(caloriasController.text) ?? 0,
      proteinas: int.tryParse(proteinasController.text) ?? 0,
      carboidratos: int.tryParse(carboidratosController.text) ?? 0,
      gorduras: int.tryParse(gordurasController.text) ?? 0,
      altura: double.tryParse(alturaController.text) ?? 0.0,
      peso: double.tryParse(pesoController.text) ?? 0.0,
      tipoMeta: metaSelecionada,
      data: DateTime.now().toIso8601String(),
    );

    await dbHelper.insertMeta(novaMeta);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Informações salvas com sucesso!')),
    );

    _carregarMeta();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peso e Medidas'),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Veja suas Informações',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _campoComUnidade(
                        label: 'Altura', controller: alturaController, unidade: 'm'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _campoComUnidade(
                        label: 'Peso corporal', controller: pesoController, unidade: 'kg'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Meta',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Bulking', 'Cutting', 'Manutenção'].map((meta) {
                  return ChoiceChip(
                    label: Text(meta),
                    selected: metaSelecionada == meta,
                    onSelected: (_) => setState(() => metaSelecionada = meta),
                    selectedColor: Colors.red,
                    labelStyle: TextStyle(
                      color: metaSelecionada == meta ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              _campoComUnidade(
                  label: 'Meta diária de calorias',
                  controller: caloriasController,
                  unidade: 'kcal'),
              const SizedBox(height: 16),
              _campoComUnidade(
                  label: 'Meta diária de proteínas',
                  controller: proteinasController,
                  unidade: 'g'),
              const SizedBox(height: 16),
              _campoComUnidade(
                  label: 'Meta diária de gorduras',
                  controller: gordurasController,
                  unidade: 'g'),
              const SizedBox(height: 16),
              _campoComUnidade(
                  label: 'Meta diária de carboidratos',
                  controller: carboidratosController,
                  unidade: 'g'),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _salvarMeta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Atualizar informações',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoComUnidade({
    required String label,
    required TextEditingController controller,
    required String unidade,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        suffixText: unidade,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
