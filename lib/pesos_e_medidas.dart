import 'package:flutter/material.dart';

class PesoMedidasPage extends StatefulWidget {
  const PesoMedidasPage({super.key});

  @override
  State<PesoMedidasPage> createState() => _PesoMedidasPageState();
}

class _PesoMedidasPageState extends State<PesoMedidasPage> {
  final alturaController = TextEditingController(text: "1.80");
  final pesoController = TextEditingController(text: "77.5");
  final caloriasController = TextEditingController(text: "2000");
  final proteinasController = TextEditingController(text: "150");
  final gordurasController = TextEditingController(text: "50");
  final carboidratosController = TextEditingController(text: "200");

  String metaSelecionada = "Bulking";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peso e Medidas'), backgroundColor: Colors.red, centerTitle: true,),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const Text('Veja suas Informações', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _campoComUnidade(label: 'Altura', controller: alturaController, unidade: 'cm'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _campoComUnidade(label: 'Peso corporal', controller: pesoController, unidade: 'kg'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Meta', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
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
              _campoComUnidade(label: 'Meta diária de calorias', controller: caloriasController, unidade: 'kcal'),
              const SizedBox(height: 16),
              _campoComUnidade(label: 'Meta diária de proteínas', controller: proteinasController, unidade: 'g'),
              const SizedBox(height: 16),
              _campoComUnidade(label: 'Meta diária de gorduras', controller: gordurasController, unidade: 'g'),
              const SizedBox(height: 16),
              _campoComUnidade(label: 'Meta diária de carboidratos', controller: carboidratosController, unidade: 'g'),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Informações atualizadas!'))),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Atualizar informações',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
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
