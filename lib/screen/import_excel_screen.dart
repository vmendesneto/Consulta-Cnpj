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
        title: const Text('Consultar Cnpj na Receita'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                              content: Text('CNPJ atualizados com sucesso!')),
                        );
                        setState(() {
                          _isUpdating = false;
                        });
                      } else {
                        setState(() {
                          _isUpdating = false;
                        });
                      }
                    },
              child: Text(_isUpdating
                  ? 'Processando.....'
                  : 'Selecionar Arquivo Excel'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClientesInfoScreen()),
                );
              },
              child: const Text('Ver Todos os CNPJ salvos'),
            ),
          ],
        ),
      ),
    );
  }
}
