import 'package:flutter/material.dart';
import '../banco_dados/bd.dart';
import '../model/cnpj_model.dart';
import '../saida_excel/export_excel.dart';

class ClientesInfoScreen extends StatefulWidget {
  @override
  _ClientesInfoScreenState createState() => _ClientesInfoScreenState();
}

class _ClientesInfoScreenState extends State<ClientesInfoScreen> {
  late Future<List<Cliente>> futureClientes;

  @override
  void initState() {
    super.initState();
    futureClientes = DatabaseHelper.instance
        .getClientes(); // Substitua pelo seu método de busca
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Informações dos Clientes'),
          actions: <Widget>[
            PopupMenuButton<int>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text('Excluir banco de dados'),
                ),
              ],
            ),
          ],
        ),
        body: FutureBuilder<List<Cliente>>(
          future: futureClientes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text("Erro ao carregar dados.");
              }
              return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  Cliente cliente = snapshot.data![index];
                  return ListTile(
                    title: Text("CNPJ: ${formatarCnpj(cliente.cnpj)}"),
                    // Mantém o CNPJ como título
                    subtitle: Text(
                      'Razão Social: ${cliente.razaoSocial ?? "Não informado"}\n'
                      'Nome Fantasia: ${cliente.nomeFantasia ?? "Não informado"}\n'
                      'Natureza Jurídica: ${cliente.naturezaJuridica ?? "Não informado"}\n'
                      'Logradouro: ${cliente.logradouro ?? "Não informado"}, Nº ${cliente.numero ?? ""}\n'
                      'Bairro: ${cliente.bairro ?? "Não informado"}\n'
                      'Município: ${cliente.municipio ?? "Não informado"} - UF: ${cliente.uf ?? "Não informado"}\n'
                      'CEP: ${cliente.cep ?? "Não informado"}\n'
                      'Tipo de Logradouro: ${cliente.tipoLogradouro ?? "Não informado"}\n'
                      'Identificador Matriz/Filial: ${cliente.identificadorMatrizFilial}\n'
                      'Início Atividade: ${cliente.inicioAtividade ?? "Não informado"}\n'
                      'Situação Cadastral: ${cliente.situacaoCadastral ?? "Não informado"}\n'
                      'Data Atualização: ${cliente.dataCadastro ?? "Não informado"}',
                    ),
                    isThreeLine: true, // Permitir múltiplas linhas no subtitle
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await exportarClientesParaExcel();
            // Exibir uma mensagem de confirmação, se desejar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Clientes exportados para Excel com sucesso!')),
            );
          },
          tooltip: 'Exportar para Excel',
          child: const Icon(Icons.download),
        ));
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        _deleteDatabase();
        break;
    }
  }

  void _deleteDatabase() async {
    // Aqui, implemente a lógica para excluir o banco de dados
    await DatabaseHelper.instance.deleteDatabase();
    // Exibir uma mensagem de confirmação
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Banco de dados excluído com sucesso!')),
    );
    // Atualizar o estado para refletir a exclusão no UI, se necessário
    setState(() {
      futureClientes = DatabaseHelper.instance.getClientes();
    });
  }

  String formatarCnpj(String cnpj) {
    // Verifica se o CNPJ tem a quantidade correta de dígitos para evitar erros
    if (cnpj.length == 14) {
      return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12, 14)}';
    }
    // Retorna o CNPJ sem formatação se não tiver a quantidade correta de dígitos
    return cnpj;
  }
}
