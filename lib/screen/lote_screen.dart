import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../lote_excel/lote_excel.dart';
import '../entrada_excel/import_excel.dart';

class loteScreen extends StatefulWidget {
  @override
  _loteScreenState createState() => _loteScreenState();
}

class _loteScreenState extends State<loteScreen> {
  String _texto = "Arquivo tem que está no fomrato .xlsx\n"
      "Insira um arquivo excel com as seguintes caracteristicas:\n"
      "Os CNPJ deveram estar na primeira planilha "
      "e primeira coluna,\n"
      "conforme imagem abaixo: \n\n"
      "***Não há limite de linhas.";
  bool _estaProcessando = false;
  bool _isUpdating = false;

  Future<bool> _pickExcelFile() async {
    // Abre o seletor de arquivos e permite apenas arquivos Excel
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
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
    return WillPopScope(
        onWillPop: () async {
          // Se estiver processando, impede o retorno.
          return !_estaProcessando;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text(
              'Inserir em Lote',
              style: TextStyle(color: Colors.amber),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _texto,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Espaçamento entre o texto e a imagem
                Image.asset('imagens/exemplo.png'),
                // Exibe a imagem
                const SizedBox(height: 20),
                // Espaçamento entre a imagem e o botão
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor:
                            Colors.amber, // Cor do texto e ícones do botão
                      ),
                      onPressed: _isUpdating
                          ? null
                          : () async {
                              setState(() {
                                _isUpdating = true;
                                _estaProcessando = true;
                              });
                              bool filePicked = await _pickExcelFile();
                              if (filePicked) {
                                await fetchInfoForClientesAndUpdateLote(
                                    context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'CNPJs inserido e atualizados com sucesso!')),
                                );
                                setState(() {
                                  _isUpdating = false;
                                  _estaProcessando = false;
                                });
                              } else {
                                setState(() {
                                  _isUpdating = false;
                                  _estaProcessando = false;
                                });
                              }
                              Navigator.of(context).pop();
                            },
                      child: Text(
                          _isUpdating
                              ? 'Processando.....'
                              : 'Selecionar o Arquivo Excel',
                          style: const TextStyle(color: Colors.black)),
                    ),

                    _isUpdating
                        ?Container(
                      height: 60,
                      width: 90,
                      color: Colors.white,
                      child: Column(children: [
                        Text('Carregando',style: const TextStyle(
                            fontSize: 14, color: Colors.black),),
                      ValueListenableBuilder<int>(
                        valueListenable: carregarNotifier,
                        builder: (context, c, child) {
                          return Container(
                            height: 33,
                            width: 90,
                            color: Colors.white,
                            alignment: Alignment.center,
                            child: Text(
                              c.toString(),
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.black),
                            ),
                          );
                        },
                      ),
                      ],)
                    ):Container(),
                    _isUpdating
                        ?Container(
                      height: 60,
                      width: 90,
                      color: Colors.white,
                      child: Column(children: [
                        Text('Pesquisando',style: const TextStyle(
                            fontSize: 14, color: Colors.black),),
                        ValueListenableBuilder<int>(
                          valueListenable: jNotifier,
                          builder: (context, j, child) {
                            return Container(
                              height: 30,
                              width: 90,
                              color: Colors.white,
                              alignment: Alignment.center,
                              child: Text(
                                j.toString(),
                                style: const TextStyle(
                                    fontSize: 24, color: Colors.black),
                              ),
                            );
                          },
                        ),
                      ],),
                    ):Container(),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
