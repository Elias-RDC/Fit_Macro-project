import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Model Alimento
class Alimento {
  int? id;
  String nome;
  double calorias;
  double proteinas;
  double carboidratos;
  double gorduras;
  String data; // ISO string

  Alimento({
    this.id,
    required this.nome,
    required this.calorias,
    required this.proteinas,
    required this.carboidratos,
    required this.gorduras,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'calorias': calorias,
      'proteinas': proteinas,
      'carboidratos': carboidratos,
      'gorduras': gorduras,
      'data': data,
    };
  }

  factory Alimento.fromMap(Map<String, dynamic> m) => Alimento(
        id: m['id'] as int?,
        nome: m['nome'] as String,
        calorias: (m['calorias'] as num).toDouble(),
        proteinas: (m['proteinas'] as num).toDouble(),
        carboidratos: (m['carboidratos'] as num).toDouble(),
        gorduras: (m['gorduras'] as num).toDouble(),
        data: m['data'] as String,
      );
}

/// Model Meta
class Meta {
  int? id;
  int calorias;
  int proteinas;
  int carboidratos;
  int gorduras;
  double altura;
  double peso;
  String tipoMeta; // Bulking, Cutting, Manutenção
  String data;

  Meta({
    this.id,
    required this.calorias,
    required this.proteinas,
    required this.carboidratos,
    required this.gorduras,
    required this.altura,
    required this.peso,
    required this.tipoMeta,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'calorias': calorias,
      'proteinas': proteinas,
      'carboidratos': carboidratos,
      'gorduras': gorduras,
      'altura': altura,
      'peso': peso,
      'tipo_meta': tipoMeta,
      'data': data,
    };
  }

  /// Map para inserir no banco sem enviar o id (resolve UNIQUE constraint)
  Map<String, dynamic> toMapForInsert() {
    return {
      'calorias': calorias,
      'proteinas': proteinas,
      'carboidratos': carboidratos,
      'gorduras': gorduras,
      'altura': altura,
      'peso': peso,
      'tipo_meta': tipoMeta,
      'data': data,
    };
  }

  factory Meta.fromMap(Map<String, dynamic> m) => Meta(
        id: m['id'] as int?,
        calorias: m['calorias'] as int,
        proteinas: m['proteinas'] as int,
        carboidratos: m['carboidratos'] as int,
        gorduras: m['gorduras'] as int,
        altura: (m['altura'] as num).toDouble(),
        peso: (m['peso'] as num).toDouble(),
        tipoMeta: m['tipo_meta'] as String,
        data: m['data'] as String,
      );
}

/// Database helper singleton
class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _db;

  // Stream controller to notify changes
  final StreamController<void> _updatesController =
      StreamController<void>.broadcast();
  Stream<void> get updates => _updatesController.stream;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'fit_macro.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE alimentos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      calorias REAL,
      proteinas REAL,
      carboidratos REAL,
      gorduras REAL,
      data TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE metas (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      calorias INTEGER,
      proteinas INTEGER,
      carboidratos INTEGER,
      gorduras INTEGER,
      altura REAL,
      peso REAL,
      tipo_meta TEXT,
      data TEXT
    )
    ''');
  }

  // ---------- ALIMENTOS ----------
  Future<int> insertAlimento(Alimento a) async {
    final db = await database;
    final id = await db.insert('alimentos', a.toMap());
    _notifyUpdate();
    return id;
  }

  Future<List<Alimento>> getAllAlimentos() async {
    final db = await database;
    final res = await db.query('alimentos', orderBy: 'id DESC');
    return res.map((m) => Alimento.fromMap(m)).toList();
  }

  Future<Map<String, double>> getSomaTotalAlimentos() async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT 
        SUM(calorias) as total_calorias,
        SUM(proteinas) as total_proteinas,
        SUM(carboidratos) as total_carboidratos,
        SUM(gorduras) as total_gorduras
      FROM alimentos
    ''');
    final row = res.first;
    double parse(dynamic v) {
      if (v == null) return 0.0;
      return (v as num).toDouble();
    }

    return {
      'calorias': parse(row['total_calorias']),
      'proteinas': parse(row['total_proteinas']),
      'carboidratos': parse(row['total_carboidratos']),
      'gorduras': parse(row['total_gorduras']),
    };
  }

  // ---------- METAS ----------
  Future<int> insertMeta(Meta m) async {
    final db = await database;
    // Usa ConflictAlgorithm.replace para evitar UNIQUE constraint failed
    final id = await db.insert(
      'metas',
      m.toMapForInsert(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _notifyUpdate();
    return id;
  }

  Future<Meta?> getLastMeta() async {
    final db = await database;
    final res = await db.query('metas', orderBy: 'id DESC', limit: 1);
    if (res.isEmpty) return null;
    return Meta.fromMap(res.first);
  }

  Future<List<Meta>> getAllMetas() async {
    final db = await database;
    final res = await db.query('metas', orderBy: 'id DESC');
    return res.map((m) => Meta.fromMap(m)).toList();
  }

  // ---------- UTIL ----------
  void _notifyUpdate() {
    try {
      _updatesController.add(null);
    } catch (e) {
      // ignore if closed
    }
  }

  Future<void> close() async {
    await _updatesController.close();
    final db = await database;
    await db.close();
    _db = null;
  }
}
