import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // 🔒 Singleton
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // 🔁 Controlador de atualizações (para o Dashboard escutar)
  final StreamController<void> _updatesController = StreamController<void>.broadcast();
  Stream<void> get updates => _updatesController.stream;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fit_macro.db');
    return _database!;
  }

  // 📂 Inicialização e criação do banco
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // 🧩 Criação das tabelas
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE refeicoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        quantidade REAL,
        total_kcal REAL,
        total_proteina REAL,
        total_carboidrato REAL,
        total_gordura REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE metas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        calorias REAL,
        proteinas REAL,
        carboidratos REAL,
        gorduras REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE peso_medidas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meta TEXT UNIQUE,
        peso REAL,
        altura REAL,
        meta_calorias REAL,
        meta_proteinas REAL,
        meta_carboidratos REAL,
        meta_gorduras REAL
      )
    ''');

    // 🔹 Insere uma meta padrão na primeira inicialização
    await db.insert('metas', {
      'calorias': 3000.0,
      'proteinas': 180.0,
      'carboidratos': 400.0,
      'gorduras': 80.0,
    });
  }

  // 🧱 Atualização de estrutura (caso já exista banco antigo)
  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE peso_medidas ADD COLUMN meta_calorias REAL');
      await db.execute('ALTER TABLE peso_medidas ADD COLUMN meta_proteinas REAL');
      await db.execute('ALTER TABLE peso_medidas ADD COLUMN meta_carboidratos REAL');
      await db.execute('ALTER TABLE peso_medidas ADD COLUMN meta_gorduras REAL');
    }
  }

  // ======================== REFEIÇÕES =========================
  Future<void> insertRefeicao(Map<String, dynamic> dados) async {
    final db = await database;

    await db.insert(
      'refeicoes',
      {
        'nome': dados['nome'],
        'quantidade': dados['quantidade'],
        'total_kcal': dados['total_kcal'],
        'total_proteina': dados['total_proteina'],
        'total_carboidrato': dados['total_carboidrato'],
        'total_gordura': dados['total_gordura'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    notifyUpdates();
  }

  Future<Map<String, double>> getSomaTotalAlimentos() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT 
        SUM(total_kcal) AS calorias,
        SUM(total_proteina) AS proteinas,
        SUM(total_carboidrato) AS carboidratos,
        SUM(total_gordura) AS gorduras
      FROM refeicoes
    ''');

    if (result.isNotEmpty) {
      final row = result.first;
      return {
        'calorias': (row['calorias'] ?? 0.0) as double,
        'proteinas': (row['proteinas'] ?? 0.0) as double,
        'carboidratos': (row['carboidratos'] ?? 0.0) as double,
        'gorduras': (row['gorduras'] ?? 0.0) as double,
      };
    }
    return {'calorias': 0, 'proteinas': 0, 'carboidratos': 0, 'gorduras': 0};
  }

  Future<Map<String, double>> getUltimaMeta() async {
    final db = await database;
    final result = await db.query('metas', orderBy: 'id DESC', limit: 1);

    if (result.isNotEmpty) {
      final row = result.first;
      return {
        'calorias': (row['calorias'] ?? 0.0) as double,
        'proteinas': (row['proteinas'] ?? 0.0) as double,
        'carboidratos': (row['carboidratos'] ?? 0.0) as double,
        'gorduras': (row['gorduras'] ?? 0.0) as double,
      };
    }
    return {'calorias': 0, 'proteinas': 0, 'carboidratos': 0, 'gorduras': 0};
  }

  Future<void> updateMeta(Map<String, double> novaMeta) async {
    final db = await database;
    await db.insert('metas', novaMeta, conflictAlgorithm: ConflictAlgorithm.replace);
    notifyUpdates();
  }

  // ===================== PESO E MEDIDAS =====================
  Future<void> insertOrUpdatePesoMedidas(Map<String, dynamic> dados) async {
    final db = await database;
    await db.insert(
      'peso_medidas',
      dados,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyUpdates();
  }

  Future<Map<String, dynamic>?> getPeso(String meta) async {
    final db = await database;
    final result = await db.query(
      'peso_medidas',
      where: 'meta = ?',
      whereArgs: [meta],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // ===================== RESET DE METAS =====================
  Future<void> resetDatabase() async {
  final db = await instance.database;

  // Zera apenas os valores de macronutrientes nas tabelas relevantes
  await db.update('metas', {
    'calorias': 0.0,
    'proteinas': 0.0,
    'carboidratos': 0.0,
    'gorduras': 0.0,
  });

  // Remove todas as refeições adicionadas
  await db.delete('refeicoes');

  notifyUpdates();
  print('✅ Refeições resetadas com sucesso!');
}


  // Notifica listeners (Dashboard)
  void notifyUpdates() {
    if (!_updatesController.isClosed) {
      _updatesController.add(null);
    }
  }

  // Fecha o controlador ao encerrar o app
  void dispose() {
    _updatesController.close();
  }
}
