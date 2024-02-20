import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';
import '../banco_dados/bd.dart';
import '../model/cnpj_model.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> exportarClientesParaExcel() async {
  final List<Cliente> clientes = await DatabaseHelper.instance.getClientes();
  var excel = Excel.createExcel(); // Cria uma nova instância do Excel
  Sheet sheetObject = excel['Sheet1'];

  // Cria um cabeçalho para a planilha
  List<String> headers = [
    "CNPJ",
    "Razão Social",
    "Nome Fantasia",
    "Natureza Jurídica",
    "Tipo de Logradouro",
    "Logradouro",
    "Número",
    "Bairro",
    "Município",
    "UF",
    "CEP",
    "Identificador Matriz/Filial",
    "Início Atividade",
    "Situação Cadastral",
    "Data Atualização",
  ];
  sheetObject.appendRow(headers);

  // Adiciona os dados dos clientes na planilha
  for (var cliente in clientes) {
    List<dynamic> row = [
      cliente.cnpj,
      cliente.razaoSocial,
      cliente.nomeFantasia,
      cliente.naturezaJuridica,
      cliente.tipoLogradouro,
      cliente.logradouro,
      cliente.numero,
      cliente.bairro,
      cliente.municipio,
      cliente.uf,
      cliente.cep,
      cliente.identificadorMatrizFilial,
      cliente.inicioAtividade,
      cliente.situacaoCadastral,
      cliente.dataCadastro,
    ];
    sheetObject.appendRow(row);
  }
  var bytes = excel.save();

  // Obtém o diretório temporário
  final directory = await getTemporaryDirectory();
  final path = '${directory.path}/clientes.xlsx';

  // Cria um arquivo temporário e escreve os bytes do Excel
  File file = File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes!);

  // Compartilha o arquivo Excel
  Share.shareFiles([file.path], text: 'Clientes.xlsx');

  // Opcional: Remove o arquivo temporário após o compartilhamento
  // await file.delete();
}

