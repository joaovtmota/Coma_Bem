import 'package:flutter/foundation.dart' show debugPrint;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instancia = DatabaseHelper._interno();
  static Database? _bancoDeDados;

  factory DatabaseHelper() => instancia;

  DatabaseHelper._interno();

  Future<Database> get bancoDeDados async {
    if (_bancoDeDados != null) return _bancoDeDados!;
    _bancoDeDados = await _iniciarBanco();
    return _bancoDeDados!;
  }

  Future<Database> _iniciarBanco() async {
    String caminhoBanco = await getDatabasesPath();
    String caminhoCompleto = join(caminhoBanco, 'coma_bem.db');

    return await openDatabase(
      caminhoCompleto,
      // BUG CORRIGIDO: o schema mudou (novas tabelas e colunas), mas a
      // versão continuava "1". Quem já tinha instalado/testado o app
      // antes ficava com um banco antigo (sem 'usu_nm_usuario', sem
      // 'restaurante'/'prato'/'avaliacao') e nunca conseguia criar
      // conta nem logar. Subir a versão força o onUpgrade a rodar.
      version: 2,
      onCreate: _criarTabelas,
      onUpgrade: _atualizarBanco,
    );
  }

  Future<void> _atualizarBanco(Database db, int versaoAntiga, int versaoNova) async {
    // Projeto ainda em desenvolvimento: a forma mais segura de garantir
    // que todo mundo fique com o schema novo é apagar as tabelas antigas
    // e recriar do zero (não há dados de produção a preservar).
    await db.execute('DROP TABLE IF EXISTS avaliacao');
    await db.execute('DROP TABLE IF EXISTS prato');
    await db.execute('DROP TABLE IF EXISTS restaurante');
    await db.execute('DROP TABLE IF EXISTS usuario');
    await _criarTabelas(db, versaoNova);
  }

  Future<void> _criarTabelas(Database db, int version) async {
    // BUG CORRIGIDO: antes só a tabela 'usuario' era criada. Como
    // 'restaurante', 'prato' e 'avaliacao' nunca existiam, qualquer
    // tentativa de cadastro travava com "no such table".
    await db.execute('''
      CREATE TABLE usuario (
        usu_id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        usu_nm_usuario TEXT NOT NULL,
        usu_tx_email TEXT NOT NULL UNIQUE,
        usu_tx_senha TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE restaurante (
        res_id_restaurante INTEGER PRIMARY KEY AUTOINCREMENT,
        res_nm_restaurante TEXT NOT NULL,
        res_nu_latitude TEXT,
        res_nu_longitude TEXT,
        res_ds_tipo_culinaria TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE prato (
        pra_id_prato INTEGER PRIMARY KEY AUTOINCREMENT,
        pra_nm_prato TEXT NOT NULL,
        pra_im_foto TEXT,
        pra_id_restaurante INTEGER NOT NULL,
        FOREIGN KEY (pra_id_restaurante) REFERENCES restaurante (res_id_restaurante)
      )
    ''');

    await db.execute('''
      CREATE TABLE avaliacao (
        avl_id_avaliacao INTEGER PRIMARY KEY AUTOINCREMENT,
        avl_nu_ranking INTEGER NOT NULL,
        avl_tx_recomendacao TEXT NOT NULL,
        avl_id_prato INTEGER NOT NULL,
        avl_id_usuario INTEGER NOT NULL,
        FOREIGN KEY (avl_id_prato) REFERENCES prato (pra_id_prato),
        FOREIGN KEY (avl_id_usuario) REFERENCES usuario (usu_id_usuario)
      )
    ''');
  }

  /// Cadastra um novo usuário (necessário para o login funcionar --
  /// antes não existia NENHUMA forma de criar uma conta no app).
  /// Retorna null em caso de sucesso, ou uma mensagem de erro amigável.
  Future<String?> cadastrarUsuario({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      Database db = await bancoDeDados;
      await db.insert('usuario', {
        'usu_nm_usuario': nome,
        'usu_tx_email': email,
        'usu_tx_senha': senha,
      });
      return null;
    } on DatabaseException catch (erro) {
      debugPrint('Erro ao cadastrar usuário: $erro');
      if (erro.isUniqueConstraintError()) {
        return 'Já existe uma conta cadastrada com esse e-mail.';
      }
      return 'Não foi possível criar a conta. Tente novamente.';
    } catch (erro) {
      debugPrint('Erro ao cadastrar usuário: $erro');
      return 'Não foi possível criar a conta. Tente novamente.';
    }
  }

  Future<Map<String, dynamic>?> autenticarUsuario(
      String email, String senha) async {

    Database db = await bancoDeDados;

    List<Map<String, dynamic>> resultado = await db.query(
      'usuario',
      where: 'usu_tx_email = ? AND usu_tx_senha = ?',
      whereArgs: [email, senha],
    );

    if (resultado.isNotEmpty) return resultado.first;

    return null;
  }

  Future<int> inserirDados(String tabela, Map<String, dynamic> dados) async {
    Database db = await bancoDeDados;
    return await db.insert(tabela, dados);
  }

  Future<List<Map<String, dynamic>>> consultarDados(String tabela) async {
    Database db = await bancoDeDados;
    return await db.query(tabela);
  }

  Future<int> alterarDados(
    String tabela,
    Map<String, dynamic> novosDados,
    String colunaId,
    int id,
  ) async {
    Database db = await bancoDeDados;

    return await db.update(
      tabela,
      novosDados,
      where: '$colunaId = ?',
      whereArgs: [id],
    );
  }
  
  Future<int> deletarDados(
    String tabela,
    String colunaId,
    int id,
  ) async {
    Database db = await bancoDeDados;

    return await db.delete(
      tabela,
      where: '$colunaId = ?',
      whereArgs: [id],
    );
  }

  Future<void> inserirRestaurante(Map<String, dynamic> dadosRestaurante) async {
    try {
       Database db = await bancoDeDados;
       int idGerado = await db.insert('restaurante', dadosRestaurante);
       print('Sucesso: Restaurante cadastrado com o ID $idGerado.');
    } catch(erro) {
      print('Erro ao tentar cadastrar o restaurante: $erro'); 
    }
  }

  Future<List<Map<String, dynamic>>> listarRestaurantesPortipo(String tipo) async {
    try{
      Database db = await bancoDeDados;

      List<Map<String, dynamic>> lista = await db.query(
        'restaurante',
        where: 'res_ds_tipo_culinaria = ?',
        whereArgs: [tipo],
      );
      print('Sucesso: Foram encontrados ${lista.length} restaurantes.');
      return lista;
    } catch (erro) {
      print('Erro ao buscar restaurantes do tipo $tipo: $erro');
      return [];
    }
  }

  Future<void> atualizarAvaliacao(int idAvaliacao, int novaNota, String novoTexto) async {
    try{
       Database db = await bancoDeDados;

       int linhasAfetadas = await db.update(
         'avaliacao',
         {'avl_nu_ranking': novaNota, 'avl_tx_recomendacao': novoTexto},
         where: 'avl_id_avaliacao = ?',
         whereArgs: [idAvaliacao],
       );

       if (linhasAfetadas > 0) {
        print('Sucesso: Avaliação atualizada.');
       } else {
        print('Aviso: Nenhuma avaliação encontrada com o ID $idAvaliacao.');
       } 
    } catch (erro) {
        print('Erro ao atualizar: $erro'); 
    }
  }

  Future<void> removerPrato(int idPrato) async {
    try {
      Database db = await bancoDeDados;

      int linhasAfetadas = await db.delete(
        'prato',
        where: 'pra_id_prato = ?',
        whereArgs: [idPrato],
      );

      if (linhasAfetadas > 0) {
        print('Sucesso: Prato deletado do cardápio.');
      } else {
        print('Aviso: Nenhum prato encontrado com o ID $idPrato');
      }
    } catch (erro) {
      print('Erro ao tentar remover o prato: $erro'); 
    }
  }

  Future<List<Map<String , dynamic>>> buscarRestaurantePorNome(String termoBusca) async {
    try {
      Database db = await bancoDeDados;

      List<Map<String, dynamic>> lista = await db.query(
        'restaurante',
        where: 'res_nm_restaurante LIKE ?',
        whereArgs: ['%$termoBusca%'],
      );
      print('Sucesso: Foram encontrados ${lista.length} restaurantes contendo "$termoBusca".');
      return lista;
    } catch (erro) {
      print('Erro ao buscar retaurante por nome: $erro');
      return []; 
    }
  }

  Future<List<Map<String, dynamic>>> listarPratosPorRestaurante(int idRestaurante) async {
    try {
      Database db = await bancoDeDados;
      List<Map<String, dynamic>> cardapio = await db.query(
         'prato',
         where: 'pra_id_restaurante = ?',
         whereArgs: [idRestaurante],
      );
      print('Sucesso: ${cardapio.length} pratos carregados para o restaurante ID $idRestaurante.');
      return cardapio;
    } catch (erro) {
      print('Erro ao carregar o cardápio: $erro');
      return []; 
    }
  }
}