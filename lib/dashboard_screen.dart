import 'dart:async';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fit_macro/sobre.dart';
import 'pesos_e_medidas.dart';
import 'imc.dart';
import 'suporte.dart';
import 'database_helper.dart';
import 'registrar_alimento.dart';
import 'dart:math';

class NutrientData {
  final double calorias;
  final double metaCalorias;
  final double proteina;
  final double metaProteina;
  final double carboidrato;
  final double metaCarboidrato;
  final double gordura;
  final double metaGordura;

  const NutrientData({
    required this.calorias,
    required this.metaCalorias,
    required this.proteina,
    required this.metaProteina,
    required this.carboidrato,
    required this.metaCarboidrato,
    required this.gordura,
    required this.metaGordura,
  });

  factory NutrientData.vazia() => const NutrientData(
        calorias: 0,
        metaCalorias: 0,
        proteina: 0,
        metaProteina: 0,
        carboidrato: 0,
        metaCarboidrato: 0,
        gordura: 0,
        metaGordura: 0,
      );
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  NutrientData data = NutrientData.vazia();
  late final DatabaseHelper db;
  StreamSubscription<void>? _dbListener;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    db = DatabaseHelper.instance;
    _carregarDados();

    // Atualiza dashboard sempre que houver alterações no banco
    _dbListener = db.updates.listen((_) => _carregarDados());
  }

  @override
  void dispose() {
    _dbListener?.cancel();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    try {
      final soma = await db.getSomaTotalAlimentos();

      // Obtem a meta atual (prioriza Bulking como padrão)
      final metaDados = await db.getPeso("Bulking");

      final metaCal = (metaDados?['meta_calorias'] ?? 3000.0) as double;
      final metaProt = (metaDados?['meta_proteinas'] ?? 180.0) as double;
      final metaCarb = (metaDados?['meta_carboidratos'] ?? 400.0) as double;
      final metaFat = (metaDados?['meta_gorduras'] ?? 80.0) as double;

      setState(() {
        data = NutrientData(
          calorias: soma['calorias'] ?? 0.0,
          metaCalorias: metaCal,
          proteina: soma['proteinas'] ?? 0.0,
          metaProteina: metaProt,
          carboidrato: soma['carboidratos'] ?? 0.0,
          metaCarboidrato: metaCarb,
          gordura: soma['gorduras'] ?? 0.0,
          metaGordura: metaFat,
        );
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Erro ao carregar dados do Dashboard: $e");
      setState(() {
        data = NutrientData.vazia();
        _isLoading = false;
      });
    }
  }

  Widget _buildLinearCard(String title, double current, double goal,
      Color color, IconData icon, String unit) {
    final progress = goal > 0 ? (current / goal).clamp(0.0, 1.0) : 0.0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Text(
                  "${current.toStringAsFixed(0)} / ${goal.toStringAsFixed(0)} $unit",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                color: color,
                backgroundColor: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color backgroundColor = Colors.red,
    Color textColor = Colors.white,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20, color: textColor),
      label: Text(
        label,
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: textColor),
      ),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size.fromHeight(40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = data;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitMacro'),
        backgroundColor: Colors.red,
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : RefreshIndicator(
              onRefresh: _carregarDados,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Progresso de Calorias',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  CircularPercentIndicator(
                    radius: 70.0,
                    lineWidth: 10.0,
                    percent: d.metaCalorias > 0
                        ? (d.calorias / d.metaCalorias).clamp(0.0, 1.0)
                        : 0.0,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${d.metaCalorias > 0 ? min((d.calorias / d.metaCalorias) * 100, 100).toStringAsFixed(0):0}%",
                        style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                        const SizedBox(height: 4),
                        Text(
                          "${d.calorias.toStringAsFixed(0)} / ${d.metaCalorias.toStringAsFixed(0)} kcal",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    progressColor: Colors.red,
                    backgroundColor: Colors.grey.shade200,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Macronutrientes',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildLinearCard("Proteínas", d.proteina, d.metaProteina,
                      Colors.red, Icons.fitness_center, "g"),
                  _buildLinearCard("Carboidratos", d.carboidrato,
                      d.metaCarboidrato, Colors.red, Icons.local_dining, "g"),
                  _buildLinearCard("Gorduras", d.gordura, d.metaGordura,
                      Colors.red, Icons.water_drop, "g"),
                  const SizedBox(height: 20),
                  _smallButton(
                    icon: Icons.add,
                    label: 'Adicionar Refeição',
                    textColor: Colors.black,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegistrarAlimentoPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _smallButton(
                    icon: Icons.monitor_weight,
                    label: 'Peso e Metas',
                    textColor: Colors.black,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const PesoMedidasPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _smallButton(
                    icon: Icons.fitness_center,
                    label: 'Calcular IMC',
                    textColor: Colors.black,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CalculadoraIMCPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _smallButton(
                    icon: Icons.delete_forever,
                    label: 'Resetar Progresso Nutricional',
                    backgroundColor: Colors.white,
                    textColor: Colors.red,
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirmar Reset'),
                          content: const Text(
                              'Deseja realmente apagar todos os dados do aplicativo? Esta ação não pode ser desfeita.'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              child: const Text('Sim, apagar'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await DatabaseHelper.instance.resetDatabase();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Banco de dados resetado com sucesso!'),
                            ),
                          );
                          _carregarDados();
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.red),
            child: Text(
              'Menu',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.fastfood),
            title: const Text('Registrar Refeição'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const RegistrarAlimentoPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.line_weight),
            title: const Text('Peso e Medidas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PesoMedidasPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Calcular IMC'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalculadoraIMCPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Suporte / Ajuda'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => AjudaSuporteScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre o FitMacro'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SobrePage()));
            },
          ),
        ],
      ),
    );
  }
}
