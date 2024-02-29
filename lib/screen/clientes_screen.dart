import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../banco_dados/bd.dart';
import 'carregar_cnpj.dart';
import '../model/cnpj_model.dart';
import '../saida_excel/export_excel.dart';

class ClientesInfoScreen extends StatefulWidget {
  @override
  _ClientesInfoScreenState createState() => _ClientesInfoScreenState();
}

class _ClientesInfoScreenState extends State<ClientesInfoScreen> {
  late Future<List<Cliente>> futureClientes;


  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    futureClientes = DatabaseHelper.instance
        .getClientes(); // Substitua pelo seu método de busca
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Informações dos CNPJ',
            style: TextStyle(color: Colors.amber),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.amber,
              ),
              onPressed: () => _showUpdateDialog(context),
            ),
            PopupMenuButton<int>(
              color: Colors.amber,
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text('Excluir banco de dados'),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
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
                    title: Text(
                      "CNPJ: ${formatarCnpj(cliente.cnpj)}",
                      style: const TextStyle(color: Colors.black),
                    ),
                    // Mantém o CNPJ como título
                    subtitle: Text(
                      'Razão Social: ${cliente.razaoSocial ?? "Não informado"}\n'
                      'Nome Fantasia: ${cliente.nomeFantasia ?? "Não informado"}\n'
                      'Logradouro: ${cliente.tipoLogradouro ?? ""} ${cliente.logradouro ?? "Não informado"}, Nº ${cliente.numero ?? ""}\n'
                      'Bairro: ${cliente.bairro ?? "Não informado"}\n'
                      'Município: ${cliente.municipio ?? "Não informado"} - UF: ${cliente.uf ?? "Não informado"}\n'
                      'CEP: ${cliente.cep ?? "Não informado"}\n'
                      'Situação Cadastral: ${cliente.situacaoCadastral ?? "Não informado"}\n'
                      'Identificador Matriz/Filial: ${cliente.identificadorMatrizFilial}\n'
                      'Natureza Jurídica: ${cliente.naturezaJuridica ?? "Não informado"}\n'
                      'Início Atividade: ${cliente.inicioAtividade ?? "Não informado"}\n'
                      'Data Atualização: ${cliente.dataCadastro ?? "Não informado"}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    isThreeLine: true, // Permitir múltiplas linhas no subtitle
                  );
                },
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.amber,
              ));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () async {
            await exportarClientesParaExcel();
            // Exibir uma mensagem de confirmação, se desejar
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //       content: Text('Clientes exportados em Excel na pasta Downloads com sucesso!')),
            // );
          },
          tooltip: 'Compartilhar',
          child: const Icon(
            Icons.share,
            color: Colors.amber,
          ),
        ));
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0: // Excluir banco de dados foi selecionado
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar',style: TextStyle(color: Colors.red)),
              content: const Text('Tem certeza que deseja excluir o banco de dados?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o diálogo
                  },
                  child: const Text('Cancelar',style: TextStyle(color: Colors.amber)),
                ),
                TextButton(
                  onPressed: () {
                    _deleteDatabase();
                    print('Banco de dados excluído');
                    Navigator.of(context).pop(); // Fecha o diálogo
                  },
                  child: const Text('Excluir',style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
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

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool status = false;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: Text('Confirmar'),
              content: Text('Tem certeza que deseja atualizar os dados?'),
              actions: <Widget>[
                TextButton(
                  onPressed: status
                      ? null
                      : () {
                          Navigator.of(context).pop(); // Fecha o diálogo
                        },
                  child: Text(status ? " " : 'Cancelar', style: const TextStyle(color: Colors.amber),),
                ),
                TextButton(
                  onPressed: status
                      ? null
                      : () async {
                          setStateDialog(() {
                            status = true;
                          });

                          await fetchInfoForClientesAndUpdate(context);

                          setStateDialog(() {
                            status = false;
                          });
                          Navigator.of(context)
                              .pop(); // Fecha o diálogo após a atualização
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'CNPJs atualizados com sucesso!')),
                          );
                        },
                  child: Text(status ? "Processando...." : "Atualizar",style: const TextStyle(color: Colors.amber),),
                ),
              ],
            );
          },
        );
      },
    );
  }


}