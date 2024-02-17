import 'package:http/http.dart' as http;
import 'dart:convert';

import 'banco_dados/bd.dart';
import 'model/cnpj_model.dart';

Future<List<Cliente>> fetchClientes() async {
  final db = await DatabaseHelper.instance.database;
  final List<Map<String, dynamic>> maps = await db.query('cliente_table');

  return List.generate(maps.length, (i) {
    return Cliente(
      //id: maps[i]['id'],
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
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      Cliente updatedCliente = Cliente.fromMap(data);
      await updateSituacao(updatedCliente);
    } else {
      print('Falha na requisição para o CNPJ: ${cliente.cnpj}');
    }
  }
}

Future<void> updateSituacao(Cliente cliente) async {
  final db = await DatabaseHelper.instance.database;

  await db.update(
    'cliente_table',
    cliente.toMap(),
    where: 'cnpj = ?',
    whereArgs: [cliente.cnpj],
  );
}
