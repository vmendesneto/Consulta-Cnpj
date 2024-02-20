import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../banco_dados/bd.dart';
import '../model/cnpj_model.dart';

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

Future<void> fetchInfoForClientesAndUpdate(BuildContext context) async {
  List<Cliente> clientes = await fetchClientes();

  for (Cliente cliente in clientes) {
    var url = Uri.parse('https://minhareceita.org/${cliente.cnpj}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      Cliente updatedCliente = Cliente.fromMap(data);
      await updateSituacao(updatedCliente);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'CNPJ inserido e atualizado com sucesso!')),
      );
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('CNPJ Inválido'),
        duration: Duration(seconds: 4),
      ));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
        Text('Sem conexão com a internet\n erro:${response.statusCode}'),
        duration: const Duration(seconds: 4),
      ));
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
