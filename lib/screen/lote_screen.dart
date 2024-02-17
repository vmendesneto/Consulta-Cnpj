import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../carregar_cnpj.dart';
import '../entrada_excel/import_excel.dart';

class loteScreen extends StatefulWidget {
  @override
  _loteScreenState createState() => _loteScreenState();
}

class _loteScreenState extends State<loteScreen> {
  String _texto = "Insira um arquivo excel com as seguintes caracteristicas:\n"
      "Os CNPJ deveram estar na primeira planilha \n"
      " e primeira coluna,"
      "conforme imagem abaixo: \n\n"
      "*Não há limite de linhas.";
  bool _isUpdating = false;
  Future<bool> _pickExcelFile() async {
    // Abre o seletor de arquivos e permite apenas arquivos Excel
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      await importExcel(file);
      return true; // Arquivo foi selecionado
    } else {
      print("Nenhum arquivo selecionado.");
      return false; // Nenhum arquivo foi selecionado
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir em Lote'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_texto),
            const SizedBox(height: 20), // Espaçamento entre o texto e a imagem
            Image.asset('imagens/exemplo.png'), // Exibe a imagem
            const SizedBox(height: 20), // Espaçamento entre a imagem e o botão
            ElevatedButton(
              onPressed: _isUpdating
                  ? null
                  : () async {
                setState(() {
                  _isUpdating = true;
                });
                bool filePicked = await _pickExcelFile();
                if (filePicked) {
                  await fetchInfoForClientesAndUpdate();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'CNPJs inserido e atualizados com sucesso!')),
                  );
                  setState(() {
                    _isUpdating = false;
                  });
                } else {
                  setState(() {
                    _isUpdating = false;
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text(_isUpdating
                  ? 'Processando.....'
                  : 'Selecionar o Arquivo Excel'),
            ),
          ],
        ),
      ),
    );
  }
}
