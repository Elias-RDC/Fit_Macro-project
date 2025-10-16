import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fit_macro/sobre.dart';
import 'pesos_e_medidas.dart';
import 'registrar_alimento.dart';
import 'imc.dart';
import 'configuracoes.dart';
import 'suporte.dart';
import 'database_helper.dart';

class NutrientData {
  final double calorias;
  final double metaCalorias;
  final double proteina;
  final double metaProteina;
  final double carboidrato;
  final double metaCarboidrato;
  final double gordura;
  final double metaGordura;

  NutrientData({
    required this.calorias,
    required this.metaCalorias,
    required this.proteina,
    required this.metaProteina,
    required this.carboidrato,
    required this.metaCarboidrato,
    required this.gordura,
    required this.metaGordura,
  });
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  NutrientData? data;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
    // Atualiza automaticamente quando o banco for alterado
    DatabaseHelper.instance.updates.listen((_) => loadDashboardData());
  }

  Future<void> loadDashboardData() async {
    final db = DatabaseHelper.instance;
    final soma = await db.getSomaTotalAlimentos();
    final meta = await db.getLastMeta();

    if (meta == null) {
      setState(() {
        data = NutrientData(
          calorias: soma['calorias'] ?? 0,
          metaCalorias: 2000,
          proteina: soma['proteinas'] ?? 0,
          metaProteina: 150,
          carboidrato: soma['carboidratos'] ?? 0,
          metaCarboidrato: 250,
          gordura: soma['gorduras'] ?? 0,
          metaGordura: 70,
        );
      });
      return;
    }

    setState(() {
      data = NutrientData(
        calorias: soma['calorias'] ?? 0,
        metaCalorias: meta.calorias.toDouble(),
        proteina: soma['proteinas'] ?? 0,
        metaProteina: meta.proteinas.toDouble(),
        carboidrato: soma['carboidratos'] ?? 0,
        metaCarboidrato: meta.carboidratos.toDouble(),
        gordura: soma['gorduras'] ?? 0,
        metaGordura: meta.gorduras.toDouble(),
      );
    });
  }

  Widget _buildLinearCard(String title, double current, double goal,
      Color color, IconData icon, String unit) {
    final progress = (current / goal).clamp(0.0, 1.0);

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
                backgroundColor: Colors.white,
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
      body: d == null
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : RefreshIndicator(
              onRefresh: loadDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Progresso de Calorias',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    CircularPercentIndicator(
                      radius: 70.0,
                      lineWidth: 10.0,
                      percent: (d.calorias / d.metaCalorias).clamp(0.0, 1.0),
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${((d.calorias / d.metaCalorias) * 100).toStringAsFixed(0)}%",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${d.calorias.toStringAsFixed(0)} / ${d.metaCalorias.toStringAsFixed(0)} kcal",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black54),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AdicionarRefeicaoPage()),
                        );
                      },
                      backgroundColor: Colors.red,
                      textColor: Colors.black,
                    ),
                    const SizedBox(height: 8),
                    _smallButton(
                      icon: Icons.monitor_weight,
                      label: 'Calcular IMC',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CalculadoraIMCPage()),
                        );
                      },
                      backgroundColor: Colors.red,
                      textColor: Colors.black,
                    ),
                  ],
                ),
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
            leading: const Icon(Icons.food_bank),
            title: const Text('Registro de Refeições'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AdicionarRefeicaoPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.line_weight),
            title: const Text('Peso e Medidas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => PesoMedidasPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text('Calcular IMC'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CalculadoraIMCPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações do App'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ConfiguracoesPage(onThemeChanged: (bool _) {}),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('Suporte / Ajuda'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AjudaSuporteScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre o FitMacro'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => TelaSobre()));
            },
          ),
        ],
      ),
    );
  }
}
