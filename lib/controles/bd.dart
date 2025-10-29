import 'package:meu_primeiro_app/models/usuarios.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteController{
  late final Database _db;

  Database get db => _db; 

  Future<void> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = '$databasesPath/maisquepixels.db'; 

    final String _usuario  = '''
      CREATE TABLE usuario(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         nome TEXT NOT NULL,
         email TEXT NOT NULL,
         senha TEXT NOT NULL
      )
    ''';
    final String _categoria  = '''
      CREATE TABLE categoria(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         titulo TEXT NOT NULL,
         descricao TEXT
      )
    ''';
    final String _desafio  = '''
      CREATE TABLE desafio(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         titulo TEXT NOT NULL,
         descricao TEXT NOT NULL,
         concluida INTEGER,
         pontuacao INTEGER NOT NULL,
         idCategoria INTEGER,
         FOREIGN KEY (idCategoria) REFERENCES categoria (id)
      )
    ''';
    final String _progresso_usuario  = '''
      CREATE TABLE progresso_usuario(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         idUsuario INTEGER NOT NULL,
         idDesafio INTEGER NOT NULL,
         dataConclusao DATETIME,
         pontosGanhos REAL,
         FOREIGN KEY (idUsuario) REFERENCES usuario (id),
         FOREIGN KEY (idDesafio) REFERENCES desafio (id)
      )
    ''';
    final String _recompensa  = '''
      CREATE TABLE recompensa(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         nome TEXT NOT NULL,
         custoPontos INTEGER NOT NULL,
         status INTEGER
      )
    ''';
    final String _feedback  = '''
      CREATE TABLE feedback(
         id INTEGER PRIMARY KEY AUTOINCREMENT,
         idUsuario INTEGER NOT NULL,
         descricao TEXT NOT NULL,
         data DATETIME,
         FOREIGN KEY (idUsuario) REFERENCES usuario (id)
      )
    ''';
    
    _db = await openDatabase(
      path, 
      version: 1, 
      onCreate: (Database db, int version) async {
        await db.execute(_usuario);
        await db.execute(_categoria);
        await db.execute(_desafio);
        await db.execute(_progresso_usuario);
        await db.execute(_recompensa);
        await db.execute(_feedback);
      }
    );
  }

  Future<void> insertUser(Usuario user) async {
     await db.insert('usuario', user.toMap());
     printDatabase();
  }

  Future<List<Usuario>> getUsers() async {
    final List<Map<String, dynamic>> users = await db.query('usuario');
    printDatabase();
    return users.map((e) => Usuario.fromMap(e)).toList();
  }

  Future<void> deleteUser(int UserId) async{
    await db.delete('usuario', where: 'id = ?', whereArgs: [UserId]);
    printDatabase();
  }

  Future<void> updateUser(Usuario user) async{
    await db.update('usuario', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
    printDatabase();
  }

  Future<void> printDatabase() async{
    List<Map<String, dynamic>> users = await db.query('usuario');

    print('----users---');
    for (var user in users) { 
      print('ID: ${user['id']}, Nome: ${user['nome']}, Email: ${user['email']}');
    }
  }
}