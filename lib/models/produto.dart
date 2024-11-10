class Produto {
  final int id;
  final String descricao;
  final double preco;
  final int estoque;
  final String data;

  Produto({
    required this.id,
    required this.descricao,
    required this.preco,
    required this.estoque,
    required this.data,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      descricao: json['descricao'],
      preco:
          json['preco'] != null ? double.parse(json['preco'].toString()) : 0.0,
      estoque: json['estoque'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'preco': preco,
      'estoque': estoque,
      'data': data,
    };
  }
}
