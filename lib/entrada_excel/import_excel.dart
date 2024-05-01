import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import '../banco_dados/bd.dart';
import '../model/cnpj_model.dart';

// Definindo o ValueNotifier globalmente para ser acessado e modificado por diferentes partes do código.
ValueNotifier<int> carregarNotifier = ValueNotifier<int>(0);

class carregar {
  int get count => carregarNotifier.value;
  set count(int newValue) {
    carregarNotifier.value = newValue;
  }
}
Future importExcel(File file) async {
  if (file.path.endsWith('.xlsx')) {
  var bytes = file.readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  for (var table in excel.tables.keys) {
    for (var row in excel.tables[table]!.rows) {
      var cellValueCnpj = row[0];
      String cnpj = cellValueCnpj?.value?.toString() ?? '';
      // Verifica se o CNPJ original contém letras
      bool containsLetters = RegExp(r'[a-zA-Z]').hasMatch(cnpj);

      if (!containsLetters) {
        // Se não contém letras, remove caracteres não numéricos
        String cleanedCnpj = cnpj.replaceAll(RegExp(r'[^\d]'), '');

        // Expressão regular para verificar se a string resultante contém apenas dígitos
        RegExp regex = RegExp(r'^\d+$');
        // Verifica se o CNPJ limpo contém apenas dígitos
        if (regex.hasMatch(cleanedCnpj)) {
          if(cleanedCnpj.length == 14){
          // CNPJ válido (apenas dígitos após limpeza), então chame o método para salvar no banco de dados
          await DatabaseHelper.instance.insertCnpj(Cliente(cnpj: cleanedCnpj));

        } else{
            print("CNPJ faltando numero: $cnpj");
          }
          }else {
          // Se chegou aqui, algo deu errado na validação
          print("Erro de validação para o CNPJ: $cnpj");
        }
      } else {
        // CNPJ contém letras, considerar inválido
        print("CNPJ inválido encontrado (contém letras): $cnpj");
      }
      carregarNotifier.value += 1;
    }
  }
}else{

    print("Arquivo não suportado. Por favor, selecione um arquivo .xlsx.");
    return false;
  }
  }