import 'package:flutter/material.dart';
// Importe seu helper de banco de dados e o modelo de cliente aqui
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
    futureClientes = DatabaseHelper.instance.getClientes(); // Substitua pelo seu método de busca
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informações dos Clientes'),
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
                  title: Text(cliente.cnpj), // Adapte conforme o seu modelo
                  subtitle: Text('Situação Cadastral: ${cliente.situacao}, Data Atualização: ${cliente.dataCadastro}'), // Adapte conforme o seu modelo
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await exportarClientesParaExcel();
            // Exibir uma mensagem de confirmação, se desejar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Clientes exportados para Excel com sucesso!')),
            );
          },
          child: const Icon(Icons.download),
          tooltip: 'Exportar para Excel',
        )
    );
  }
}
