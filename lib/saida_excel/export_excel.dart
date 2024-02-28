import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';
import '../banco_dados/bd.dart';
import '../model/cnpj_model.dart';

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
    "Endereco",
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
      formatarCNPJ(cliente.cnpj),
      cliente.razaoSocial,
      cliente.nomeFantasia,
      cliente.naturezaJuridica,
      endereco(cliente.tipoLogradouro ?? "", cliente.logradouro ?? ""),
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
print('${directory.path}/clientes.xlsx');
  // Cria um arquivo temporário e escreve os bytes do Excel
  File file = File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes!);

  // Compartilha o arquivo Excel
  Share.shareFiles([file.path], text: 'Consulta_Cnpj.xlsx');

  // Opcional: Remove o arquivo temporário após o compartilhamento
  // await file.delete();
}
String formatarCNPJ(String cnpj) {
    return "${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12, 14)}";
}
String? endereco (String rua, String nome){
  return "$rua $nome";
}
