class Situacao {
  final String? situacao;
  final String? dataCadastro;


  Situacao({this.situacao,this.dataCadastro});

  Map<String, dynamic> toMap() {
    return {
      'situacao': situacao,
      'dataCadastro': dataCadastro,
    };
  }

  // Usado para converter um objeto User de um mapa
  factory Situacao.fromMap(Map<String, dynamic> map) {
    return Situacao(
      situacao: map['descricao_situacao_cadastral'],
      dataCadastro: map['data_situacao_cadastral'],
    );
  }
}