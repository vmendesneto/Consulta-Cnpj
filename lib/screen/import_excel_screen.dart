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
      // O usuário cancelou a seleção
      print("Nenhum arquivo selecionado.");
    }
  }
  void fetchInfoFor() async {
    print('Atualizando informações dos clientes...');
    await fetchInfoForClientesAndUpdate();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Importar Excel'),
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
            const ElevatedButton(
              onPressed: fetchInfoForClientesAndUpdate,
              child: Text('Atualizar Informações dos Clientes'),
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
