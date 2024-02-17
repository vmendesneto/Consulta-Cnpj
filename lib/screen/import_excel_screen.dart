import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../banco_dados/bd.dart';
import '../carregar_cnpj.dart';
import '../model/cnpj_model.dart';
import 'clientes_screen.dart';
import 'lote_screen.dart';

class ExcelImportScreen extends StatefulWidget {
  @override
  _ExcelImportScreenState createState() => _ExcelImportScreenState();
}

class _ExcelImportScreenState extends State<ExcelImportScreen> {
  bool _isInsert = false;

  // Criando o controller com a máscara de CNPJ
  var _cnpjController = MaskedTextController(mask: '00.000.000/0000-00');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultar Cnpj na Receita'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cnpjController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Digite um CNPJ',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        // Remove os caracteres não numéricos para validar
                        String digits = value!.replaceAll(RegExp(r'\D'), '');
                        if (digits.length != 14) {
                          return 'O CNPJ precisa ter 14 números';
                        }
                        return null; // Retorna null se o valor passar na validação
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isInsert
                        ? null
                        : () async {
                      setState(() {
                        _isInsert = true;
                      });
                      // Verifica se o campo do CNPJ é válido
                      if (_cnpjController.text.length == 18) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        String cnpj = _cnpjController.text.replaceAll(".", "")
                            .replaceAll("/", "")
                            .replaceAll("-", "");
                        await DatabaseHelper.instance.insertCnpj(
                            Cliente(cnpj: cnpj));
                        await fetchInfoForClientesAndUpdate();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'CNPJ inserido e atualizado com sucesso!')),
                        );
                        setState(() {
                          _isInsert = false;
                        });
                      } else {
                        setState(() {
                          _isInsert = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(
                              'CNPJ inválido. Insira 14 números.')),
                        );
                      }
                    },
                    child: Text(_isInsert
                        ? 'Inserindo'
                        : 'Buscar'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => loteScreen()),
                );
              },
              child: const Column(
                children: [
                  Text('Inserir CNPJs em Lote'),
                  Text('(Arquivo no formato Excel)',
                      style: TextStyle(fontSize: 8)),
                ],
              ),
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