import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';

import '../banco_dados/bd.dart';
import '../model/cnpj_model.dart';


Future<void> exportarClientesParaExcel() async {
  final List<Cliente> clientes = await DatabaseHelper.instance.getClientes();
  var excel = Excel.createExcel(); // Cria uma nova instância do Excel
  Sheet sheetObject = excel['Clientes'];

  // Cria um cabeçalho para a planilha
  List<String> headers = ["ID", "Cnpj", "Situação", "Data Atualização"];
  sheetObject.appendRow(headers);

  // Adiciona os dados dos clientes na planilha
  for (var cliente in clientes) {
    List<dynamic> row = [
      cliente.id,
      cliente.cnpj,
      cliente.situacao,
      cliente.dataCadastro,
    ];
    sheetObject.appendRow(row);
  }

  // Salvar o arquivo Excel
  Directory? dir = await getExternalStorageDirectory();
  String filePath = "${dir!.path}/clientes.xlsx";

  // Salva o arquivo no diretório escolhido
  File file = File(filePath)
    ..createSync(recursive: true)
    ..writeAsBytesSync(excel.save()!);

  print("Arquivo Excel salvo em $filePath");
}
