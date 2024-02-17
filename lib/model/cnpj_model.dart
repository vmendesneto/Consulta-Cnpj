class Cliente {
  final int? id;
  final String cnpj;
  final String? situacao;
  final String? dataCadastro;

  Cliente({this.id, required this.cnpj,this.situacao,this.dataCadastro});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cnpj': cnpj,
      'situacao': situacao,
      'dataCadastro': dataCadastro,
    };
  }

  // Usado para converter um objeto User de um mapa
  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      cnpj: map['cnpj'],
      situacao: map['descricao_situacao_cadastral'],
      dataCadastro: map['data_situacao_cadastral'],
    );
  }
}
