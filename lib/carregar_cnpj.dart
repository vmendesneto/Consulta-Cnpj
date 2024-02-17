import 'package:http/http.dart' as http;
import 'dart:convert';

import 'banco_dados/bd.dart';
import 'model/cnpj_model.dart';

Future<List<Cliente>> fetchClientes() async {
  final db = await DatabaseHelper.instance.database;
  final List<Map<String, dynamic>> maps = await db.query('cliente_table');

  return List.generate(maps.length, (i) {
    return Cliente(
      id: maps[i]['id'],
      cnpj: maps[i]['cnpj'],
    );
  });
}

Future<void> fetchInfoForClientesAndUpdate() async {
  List<Cliente> clientes = await fetchClientes();

  for (Cliente cliente in clientes) {
    var url = Uri.parse('https://minhareceita.org/${cliente.cnpj}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String situacao = data['descricao_situacao_cadastral'];
      String dataCadastro = data['data_situacao_cadastral'];
      // Atualiza a situação no banco de dados
      await updateSituacao(cliente.cnpj, situacao, dataCadastro);
    } else {
      print('Falha na requisição para o CNPJ: ${cliente.cnpj}');
    }
  }
}
Future<void> updateSituacao(String cnpj, String situacao, String dataCadastro) async {
  final db = await DatabaseHelper.instance.database;

  await db.update(
    'cliente_table',
    {'situacao': situacao,
    'dataCadastro': dataCadastro,
    },
    where: 'cnpj = ?',
    whereArgs: [cnpj],
  );
}
