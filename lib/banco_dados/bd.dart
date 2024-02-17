import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/cnpj_model.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;
  static final table = 'cliente_table';

  static final columnId = 'id';
  static final columnCnpj = 'cnpj';
  static final columnSituacaoCadastral = 'situacao';
  static final columnDataCadastral = 'dataCadastro';
  // Torna esta classe singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  // Abre a conexão com o banco de dados
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL para criar o banco de dados
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnCnpj TEXT NOT NULL,
            $columnSituacaoCadastral TEXT,
            $columnDataCadastral TEXT
          )
          ''');
  }

  // Método para inserir um usuário
  Future<int> insertCnpj(Cliente cliente) async {
    final Database db = await instance.database;

    // Verifica se o cliente já existe no banco de dados.
    // Supondo que 'cnpj' seja a coluna que armazena o CNPJ do cliente na sua tabela.
    final List<Map<String, dynamic>> existing = await db.query(
      table, // Substitua 'table' pelo nome real da sua tabela.
      where: 'cnpj = ?', // Substitua 'cnpj' pelo nome real da coluna, se for diferente.
      whereArgs: [cliente.cnpj],
    );

    // Se 'existing' não estiver vazio, o cliente já existe e não será inserido novamente.
    if (existing.isNotEmpty) {
      // Retorna algum valor ou lança uma exceção, dependendo de como você quer lidar com essa situação.
    print("já cadastrado no banco de dados");
      return 0;
    }

    // Se o cliente não existe, insere-o no banco de dados.
    return await db.insert(table, cliente.toMap());
  }
  Future<List<Cliente>> getClientes() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('cliente_table');

    return List.generate(maps.length, (i) {
      return Cliente(
        id: maps[i]['id'],
        cnpj: maps[i]['cnpj'],
        situacao: maps[i]['situacao'],
        dataCadastro: maps[i]['dataCadastro'],
      );
    });
  }
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'MyDatabase.db');

    await databaseFactory.deleteDatabase(path);
    _database = null; // Resetar a referência ao banco de dados
  }
}
