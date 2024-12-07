class Categoria {
  final String nome;

  Categoria({required this.nome});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
    };
  }
}

class CategoriaBuscar {
  final int id;
  final String nome;

  CategoriaBuscar({required this.id, required this.nome});

  factory CategoriaBuscar.fromJson(Map<String, dynamic> json) {
    return CategoriaBuscar(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'nome': nome,
    };
  }
}

/*
* class Categoria {
  final int id;
  final String nome;

  Categoria({required this.id, required this.nome});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
* */