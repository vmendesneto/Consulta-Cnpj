import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../lote_excel/lote_excel.dart';
import 'carregar_cnpj.dart';
import '../entrada_excel/import_excel.dart';

class loteScreen extends StatefulWidget {
  @override
  _loteScreenState createState() => _loteScreenState();
}

class _loteScreenState extends State<loteScreen> {
  String _texto = "Insira um arquivo excel com as seguintes caracteristicas:\n"
      "Os CNPJ deveram estar na primeira planilha "
      "e primeira coluna,\n"
      "conforme imagem abaixo: \n\n"
      "***Não há limite de linhas.";
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
        backgroundColor: Colors.black,
        title: const Text('Inserir em Lote',style: TextStyle(color: Colors.amber),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_texto, style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            const SizedBox(height: 20), // Espaçamento entre o texto e a imagem
            Image.asset('imagens/exemplo.png'), // Exibe a imagem
            const SizedBox(height: 20), // Espaçamento entre a imagem e o botão
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.black, // Cor de fundo do botão
                  onPrimary: Colors.amber, // Cor do texto e ícones do botão
                ),
              onPressed: _isUpdating
                  ? null
                  : () async {
                setState(() {
                  _isUpdating = true;
                });
                bool filePicked = await _pickExcelFile();
                if (filePicked) {
                  await fetchInfoForClientesAndUpdateLote(context);
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
                  : 'Selecionar o Arquivo Excel',style: const TextStyle(color: Colors.amber)),
            ),
          ],
        ),
      ),
    );
  }
}
