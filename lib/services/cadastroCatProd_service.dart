import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/produtosModel.dart';
import '/models/categoriasModel.dart';

class ApiService {
  final String baseUrl = 'http://seuipv4:3000'; // Substitua pela URL do seu backend

  // Função para criar categoria
  Future<void> criarCategoria(Categoria categoria) async {
    final url = Uri.parse(
        '$baseUrl/categorias'); // Rota de criação de categoria no backend

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(categoria.toJson()),
    );

    if (response.statusCode == 201) {
      print('Categoria criada com sucesso');
    } else {
      print('Erro ao criar categoria: ${response.body}');
    }
  }

  // Função para obter categorias
  Future<List<CategoriaBuscar>> obterCategorias() async {
    final url = Uri.parse(
        '$baseUrl/categorias'); // Rota para obter categorias do backend

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(
          response.body); // Decodifica o JSON em uma lista dinâmica
      return data.map((json) => CategoriaBuscar.fromJson(json))
          .toList(); // Converte cada item para Categoria
    } else {
      throw Exception('Erro ao obter categorias: ${response.body}');
    }
  }

  // Função para criar produto
  Future<void> criarProduto(Produto produto) async {
    final url = Uri.parse(
        '$baseUrl/produtos'); // Rota de criação de produto no backend

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produto.toJson()),
    );

    if (response.statusCode == 201) {
      print('Produto criado com sucesso');
    } else {
      print('Erro ao criar produto: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> obterProdutos() async {
    final url = Uri.parse('$baseUrl/produtos'); // Ajuste para a rota correta

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>(); // Converte para lista de mapas
    } else {
      throw Exception('Erro ao obter produtos: ${response.body}');
    }
  }

  Future<void> deletarProduto(int id) async {
    final url = Uri.parse('$baseUrl/produtos/$id'); // Endpoint para exclusão

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Produto excluído com sucesso');
    } else {
      throw Exception('Erro ao excluir produto: ${response.body}');
    }
  }
}
