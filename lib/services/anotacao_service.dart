import 'dart:convert';
import 'package:http/http.dart' as http;

class AnotacaoService {
  final String baseUrl = 'http://seuipv4:3000/anotacoes';

  Future<List<dynamic>> obterAnotacoes() async {
    final response = await http.get(Uri.parse(baseUrl));
    return jsonDecode(response.body);
  }

  Future<void> criarAnotacao(String conteudo) async {
    await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({'conteudo': conteudo}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> excluirAnotacao(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }
}
