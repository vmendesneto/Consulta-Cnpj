import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:external_path/external_path.dart';
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
  var status = await Permission.storage.request();
  if (status.isGranted) {
    // Obtém o caminho da pasta Downloads
    String downloadsDirectory = await ExternalPath
        .getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    String filePath = '$downloadsDirectory/clientes.xlsx';

    // Salva o arquivo no diretório escolhido
    File file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.save()!);

    print('Arquivo salvo em: $filePath');
  } else {
    // Handle the permission denied error
    print('Permissão negada');
  }
}