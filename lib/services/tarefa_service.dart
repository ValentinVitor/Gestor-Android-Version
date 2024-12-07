import 'dart:convert';
import 'package:http/http.dart' as http;

class TarefaService {
  final String baseUrl = 'http://seuipv4:3000/tarefas';

  Future<List<dynamic>> obterTarefas() async {
    final response = await http.get(Uri.parse(baseUrl));
    return jsonDecode(response.body);
  }

  Future<void> criarTarefa(String descricao) async {
    await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode({'descricao': descricao}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> atualizarTarefa(int id, bool concluida, String descricao) async {
    await http.patch(
      Uri.parse('$baseUrl/$id'),
      body: jsonEncode({
        'descricao': descricao,  // Incluindo a descrição para não apagá-la
        'concluida': concluida ? 1 : 0,
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> excluirTarefa(int id) async {
    await http.delete(Uri.parse('$baseUrl/$id'));
  }

}
