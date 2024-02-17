import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../carregar_cnpj.dart';
import '../entrada_excel/import_excel.dart';
import 'clientes_screen.dart';

class ExcelImportScreen extends StatefulWidget {
  @override
  _ExcelImportScreenState createState() => _ExcelImportScreenState();
}

class _ExcelImportScreenState extends State<ExcelImportScreen> {
  void _pickExcelFile() async {
    // Abre o seletor de arquivos e permite apenas arquivos Excel
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      importExcel(file);
    } else {
      print("Nenhum arquivo selecionado.");
    }
  }

  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar Cnpj na Receita'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickExcelFile,
              child: const Text('Selecionar Arquivo Excel'),
            ),
            const SizedBox(height: 20), // Espaço entre os botões
            ElevatedButton(
              onPressed: _isUpdating
                  ? null
                  : () async {
                      setState(() {
                        _isUpdating = true;
                      });
                      await fetchInfoForClientesAndUpdate();
                      setState(() {
                        _isUpdating = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Clientes atualizados com sucesso!')),
                      );
                    },
              child: Text(_isUpdating
                  ? 'Atualizando...'
                  : 'Atualizar Informações dos Clientes'),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientesInfoScreen()),
                );
              },
              child: const Text('Ver Todos os Clientes'),
            ),
          ],
        ),
      ),
    );
  }
}
