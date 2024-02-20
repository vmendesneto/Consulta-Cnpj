import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/cnpj_model.dart';
import '../screen/carregar_cnpj.dart';
import 'package:http/http.dart' as http;


Future<void> fetchInfoForClientesAndUpdateLote(BuildContext context) async {
  List<Cliente> clientes = await fetchClientes();

  for (Cliente cliente in clientes) {
    var url = Uri.parse('https://minhareceita.org/${cliente.cnpj}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      Cliente updatedCliente = Cliente.fromMap(data);
      await updateSituacao(updatedCliente);
    } else{

    }
  }
}