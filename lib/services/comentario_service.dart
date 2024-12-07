import 'dart:convert';
import 'package:http/http.dart' as http;

class ComentarioService {
  final String baseUrl = 'http://seuipv4:3000/comentarios'; // URL base da sua API

  Future<List<dynamic>> obterComentarios() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar comentários');
    }
  }

  Future<void> criarComentario(String comentario) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({'comentario': comentario}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Falha ao criar comentário');
    }
  }

  Future<void> excluirComentario(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao excluir comentário');
    }
  }
}
