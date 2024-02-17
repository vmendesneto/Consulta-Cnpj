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
    };
  }

  // Construtor factory para criar um Cliente a partir de um Map<String, dynamic>
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
}
