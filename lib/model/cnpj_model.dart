class Cliente {
  final String cnpj;
  final String? situacaoCadastral;
  final String? dataCadastro;
  final String? razaoSocial;
  final String? nomeFantasia;
  final String? naturezaJuridica;
  final String? logradouro;
  final String? numero;
  final String? bairro;
  final String? municipio;
  final String? uf;
  final String? tipoLogradouro;
  final String? cep;
  final String? identificadorMatrizFilial;
  final String? inicioAtividade;
  final String? dataBusca;

  Cliente({
    required this.cnpj,
    this.situacaoCadastral,
    this.dataCadastro,
    this.razaoSocial,
    this.nomeFantasia,
    this.naturezaJuridica,
    this.logradouro,
    this.numero,
    this.bairro,
    this.municipio,
    this.uf,
    this.tipoLogradouro,
    this.cep,
    this.identificadorMatrizFilial,
    this.inicioAtividade,
    this.dataBusca,
  });

  Map<String, dynamic> toMap() {
    return {
      'cnpj': cnpj,
      'situacaoCadastral': situacaoCadastral,
      // Usando o campo "descricao_situacao_cadastral" para "situacao"
      'dataCadastral': dataCadastro,
      // Usando "data_situacao_cadastral"
      'razaoSocial': razaoSocial,
      'nomeFantasia': nomeFantasia,
      'naturezaJuridica': naturezaJuridica,
      'logradouro': logradouro,
      'numero': numero,
      'bairro': bairro,
      'municipio': municipio,
      'uf': uf,
      'tipoLogradouro': tipoLogradouro,
      // Usando "descricao_tipo_de_logradouro" para "tipoLogradouro"
      'cep': cep,
      'identificadorMatrizFilial': identificadorMatrizFilial,
      // Usando "descricao_identificador_matriz_filial"
      'inicioAtividade': inicioAtividade,
      'dataBusca': dataBusca.toString(),
    };
  }

  //FROMMAP QUANDO RECEBO O JSON
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      cnpj: map['cnpj'],
      situacaoCadastral: map['descricao_situacao_cadastral'],
      dataCadastro: map['data_situacao_cadastral'],
      razaoSocial: map['razao_social'],
      nomeFantasia: map['nome_fantasia'],
      naturezaJuridica: map['natureza_juridica'],
      logradouro: map['logradouro'],
      numero: map['numero'],
      bairro: map['bairro'],
      municipio: map['municipio'],
      uf: map['uf'],
      tipoLogradouro: map['descricao_tipo_de_logradouro'],
      cep: map['cep'],
      identificadorMatrizFilial: map['descricao_identificador_matriz_filial'],
      inicioAtividade: map['data_inicio_atividade'],
    );
  }
//FROMMAP QUANDO LEIO OS DADOS DO BANCO
  factory Cliente.fromMap2(Map<String, dynamic> map) {
    return Cliente(
      cnpj: map['cnpj'],
      situacaoCadastral: map['situacaoCadastral'],
      // Ajustado para corresponder ao mapa
      dataCadastro: map['dataCadastral'],
      // Ajustado para corresponder ao mapa
      razaoSocial: map['razaoSocial'],
      // Ajustado para corresponder ao mapa
      nomeFantasia: map['nomeFantasia'],
      // Ajustado para corresponder ao mapa
      naturezaJuridica: map['naturezaJuridica'],
      // Ajustado para corresponder ao mapa
      logradouro: map['logradouro'],
      // Ajustado para corresponder ao mapa
      numero: map['numero'],
      // Ajustado para corresponder ao mapa
      bairro: map['bairro'],
      // Ajustado para corresponder ao mapa
      municipio: map['municipio'],
      // Ajustado para corresponder ao mapa
      uf: map['uf'],
      // Ajustado para corresponder ao mapa
      tipoLogradouro: map['tipoLogradouro'],
      // Ajustado para corresponder ao mapa
      cep: map['cep'],
      // Ajustado para corresponder ao mapa
      identificadorMatrizFilial: map['identificadorMatrizFilial'],
      // Ajustado para corresponder ao mapa
      inicioAtividade: map['inicioAtividade'],
      // Ajustado para corresponder ao mapa
      dataBusca: map['dataBusca'], // Ajustado para corresponder ao mapa
    );
  }
}