import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../banco_dados/bd.dart';
import '../model/cnpj_model.dart';
import '../screen/carregar_cnpj.dart';
import 'package:http/http.dart' as http;

// Definindo o ValueNotifier globalmente para ser acessado e modificado por diferentes partes do código.
ValueNotifier<int> jNotifier = ValueNotifier<int>(0);

class variavel {
  int get count => jNotifier.value;
  set count(int newValue) {
    jNotifier.value = newValue;
  }
}


Future<void> fetchInfoForClientesAndUpdateLote(BuildContext context) async {
  variavel i = variavel();
  List<Cliente> clientes = await fetchClientes();
  int? j = i.count;
  for (Cliente cliente in clientes) {

    var url = Uri.parse('https://minhareceita.org/${cliente.cnpj}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      Cliente updatedCliente = Cliente.fromMap(data);
      var clienteMap = updatedCliente.toMap();
      String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      clienteMap['dataBusca'] = formattedDate;
      Cliente t = Cliente.fromMap2(clienteMap);
      print(t);
      await updateSituacao(t);
    } else {

    }
    // Incrementando e atualizando jNotifier diretamente
    jNotifier.value += 1;
    j = j!+1;
    print(j);
    i.count = j;
    print(i.count);
  }
}
Future<void> fetchInfoCnpj(BuildContext context, String cnpj) async {
    var url = Uri.parse('https://minhareceita.org/$cnpj');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      // Supondo que a classe Cliente tenha um construtor fromMap.
      Cliente cliente = Cliente.fromMap(data);
      // Obtém a instância do banco de dados.
      final db = await DatabaseHelper.instance.database;
      var clienteMap = cliente.toMap();
      String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      clienteMap['dataBusca'] = formattedDate;

      await db.update(
        'cliente_table',
        clienteMap,
        where: 'cnpj = ?',
        whereArgs: [cliente.cnpj],
      );
    }  else{

    }
  }

