class Produto {
  final String nome;
  final String marca;
  final int quantidade;
  final double preco;
  final String validade;
  final int categoriaId;

  Produto({
    required this.nome,
    required this.marca,
    required this.quantidade,
    required this.preco,
    required this.validade,
    required this.categoriaId,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'marca': marca,
      'quantidade': quantidade,
      'preco': preco,
      'validade': validade,
      'categoria_id': categoriaId,
    };
  }
}
