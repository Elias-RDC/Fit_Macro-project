import 'package:flutter/material.dart';

class CalculadoraIMCPage extends StatefulWidget {
  const CalculadoraIMCPage({super.key});

  @override
  State<CalculadoraIMCPage> createState() => _CalculadoraIMCPageState();
}

class _CalculadoraIMCPageState extends State<CalculadoraIMCPage> {
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  String _resultado = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _mostrarAlertaInicial);
  }

  void _mostrarAlertaInicial() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Aviso Importante ⚠️'),
        content: const Text(
          'O cálculo de IMC é uma estimativa genérica e não leva em conta fatores como massa magra, gordura corporal, idade ou nível de atividade física. '
              'Use-o apenas como referência e procure um profissional de saúde para uma avaliação mais precisa.',
          style: TextStyle(fontSize: 15, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _calcularIMC() {
    final double? peso = double.tryParse(_pesoController.text);
    final double? altura = double.tryParse(_alturaController.text);

    if (peso == null || altura == null || altura <= 0) {
      setState(() {
        _resultado = "Por favor, insira valores válidos.";
      });
      return;
    }

    final double imc = peso / (altura * altura);

    String classificacao;
    if (imc < 18.5) {
      classificacao = "Abaixo do peso";
    } else if (imc < 24.9) {
      classificacao = "Peso normal";
    } else if (imc < 29.9) {
      classificacao = "Sobrepeso";
    } else if (imc < 34.9) {
      classificacao = "Obesidade Grau I";
    } else if (imc < 39.9) {
      classificacao = "Obesidade Grau II";
    } else {
      classificacao = "Obesidade Grau III (grave)";
    }

    setState(() {
      _resultado = "IMC: ${imc.toStringAsFixed(2)}\nClassificação: $classificacao";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculo de IMC"),
        centerTitle: true,
        backgroundColor: Colors.red,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  "Informe seus dados para calcular o IMC",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _pesoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Peso (kg)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.fitness_center),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _alturaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Altura (m)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.height),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _calcularIMC,
                  child: const Text(
                    "Calcular IMC",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 30),
                if (_resultado.isNotEmpty)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _resultado,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
